//
//  CampaignManager.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 05/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignManager {

    private(set) var campaignStore: UBCampaignStoreProtocol
    private(set) var campaignService: CampaignServiceProtocol
    private(set) var eventEngine: EventEngine
    private(set) var appID: String
    private let submissionManager: CampaignSubmissionManager
    weak var telemetric: UBTelemetrics?
    var maskModel: MaskModel?
    var bannerConfig: BannerConfiguration?
    init(campaignStore: UBCampaignStoreProtocol, campaignService: CampaignServiceProtocol, appID: String, completion: (() -> Void)? = nil) {
        self.campaignStore = campaignStore
        self.campaignService = campaignService
        self.eventEngine = EventEngine(campaigns: [])
        self.appID = appID
        self.submissionManager = CampaignSubmissionManager(DAO: UBCampaignFeedbackRequestDAO.shared, dictionaryStore: UBFeedbackIDDictionaryDAO.shared)
        fetchCampaignForEventEngine {
            completion?()
        }
    }

    func closeCampaign() -> Bool {
        return CampaignWindow.shared.removeCampaign()
    }
    // customVariables sent from the interface are the activeStatuses used inside our SDK.
    func sendEvent(event: String, customVariables: [String: String], logId: String? = nil) {
        fetchCampaignStatusForEventEngine(eventName: event) {
            let (respondingCampaigns, triggeredCampaigns) = self.eventEngine.sendEvent(event, activeStatuses: self.filterActiveStatuses(fromCustomVariables: customVariables))

            // Persist all updated campaigns
            respondingCampaigns.forEach {
                UBCampaignDAO.shared.create($0)
            }

            // Display first triggered campaign that can be displayed
            let displayableCampaign = triggeredCampaigns.sorted {
                $0.createdAt < $1.createdAt
            }.first {
                $0.canBeDisplayed == true
            }

            guard let campaignToDisplay = displayableCampaign else {
                if self.telemetric != nil {
                    if triggeredCampaigns.count == 0 {
                        self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errM, value: TelemetryConstants.noCampaingFound, logLevel: .methods)
                    } else {
                        self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errM, value: TelemetryConstants.campaingAlraedyTriggered, logLevel: .methods)
                    }
                    self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                    self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
                    self.telemetric?.submitLogData()
                    self.telemetric?.submitLogData()
                }
                return
            }
            self.displayCampaign(campaignToDisplay, withUserContext: customVariables, logId: logId)
        }
    }

    func displayCampaign(_ campaign: CampaignModel, withUserContext userContext: [String: Any], logId: String? = nil) {
        guard campaign.canBeDisplayed && UsabillaInternal.canDisplayCampaigns else {
            if telemetric != nil {
                telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
                telemetric?.submitLogData()
            }
            return
        }
        campaignStore.getCampaignForm(withFormID: campaign.formID, theme: UsabillaInternal.theme, position: campaign.position, maskModel: maskModel).then { form in

            guard self.testIntegrityOfCampaginForm(form) else {
                let text = "form: \(campaign.formID) integrity incorrect"
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errM, value: text, logLevel: .methods)
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errC, value: 1, logLevel: .methods)
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
                self.telemetric?.submitLogData()
                return
            }
            let submissionManager = CampaignSubmissionRequestManager(appID: self.appID, campaignID: campaign.identifier, formVersion: form.version, userContext: userContext, campaignSubmissionManager: self.submissionManager)
            if self.displayCampaignForm(form, manager: submissionManager) {
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: true, logLevel: .methods)
                campaign.numberOfTimesTriggered += 1
                UBCampaignDAO.shared.create(campaign)
                self.incrementViews(forCampaign: campaign)
                self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
                self.telemetric?.submitLogData()
                return
            }

            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errM, value: TelemetryConstants.campaingAlreadyShowing, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
            self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
            self.telemetric?.submitLogData()

            PLog(TelemetryConstants.campaingAlreadyShowing)
        }.catch { error in
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errM, value: error.localizedDescription, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
            self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
            self.telemetric?.submitLogData()
            PLog(error)
        }
    }

    func displayCampaignFromDispatcher(_ campaign: CampaignModel, withUserContext userContext: [String: Any], logId: String? = nil) -> Promise<SurveyDispatcherResult> {
        return Promise { fulfill, _ in
            guard campaign.canBeDisplayed && UsabillaInternal.canDisplayCampaigns else {
                fulfill(.displayNotAllowed)
                return
            }
            campaignStore.getCampaignForm(withFormID: campaign.formID, theme: UsabillaInternal.theme, position: campaign.position, maskModel: maskModel).then { form in

            guard self.testIntegrityOfCampaginForm(form) else {
                fulfill(.errorInFormat)
                return
            }
            let submissionManager = CampaignSubmissionRequestManager(appID: self.appID, campaignID: campaign.identifier, formVersion: form.version, userContext: userContext, campaignSubmissionManager: self.submissionManager)
            if self.displayCampaignForm(form, manager: submissionManager) {
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: true, logLevel: .methods)
                campaign.numberOfTimesTriggered += 1
                UBCampaignDAO.shared.create(campaign)
                self.incrementViews(forCampaign: campaign)
                self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.dur)
                self.telemetric?.submitLogData()
                fulfill(.didDisplay)
                return
            }
                fulfill(.undefinded)
        }.catch { error in
                    PLog(error)
            fulfill(.undefinded)
                }
        }
    }

    private func incrementViews(forCampaign campaign: CampaignModel) {
        self.campaignService.incrementCampaignViews(forCampaignID: campaign.identifier, viewCount: 1).then { _ in
            PLog("View count increment for campaign id \(campaign.identifier)")
        }.catch { _ in
            PLog("Error incrementing view count for campaign id \(campaign.identifier)")
        }
    }

    func filterActiveStatuses(fromCustomVariables variables: [String: String]) -> [String: String] {
        let filtered = variables.filter { type(of: $0.1) == String.self }
        var activeStatuses = [String: String]()
        for result in filtered {
            activeStatuses[result.0] = result.1
        }
        return activeStatuses
    }

    func resetData(completion: (() -> Void)?, logid: String? = nil) {
        UBCampaignDAO.shared.deleteAll(completion: { [logid] in
            self.telemetric?.alterData(for: logid, keyPath: \UBTelemetricReset.errC, value: 0, logLevel: .methods)
            self.telemetric?.logEnd(for: logid, keyPath: \UBTelemetricReset.dur)
        })
        self.resetDefaultEvents()
        fetchCampaignForEventEngine(completion: completion)
    }

    func resetDefaultEvents() {
        DefaultEventDAO.shared.deleteAll()
        DefaultEventModuleDAO.shared.deleteAll()
    }

    func fetchCampaignForEventEngine(completion: (() -> Void)? = nil) {
        campaignStore.getCampaigns(withAppID: appID).then { campaigns in
            self.eventEngine.campaigns = campaigns.filter { $0.status == .active }
            if var appData = DefaultEventAppStateDAO.shared.read(id: "AppStateID") {
                appData.lastFetchDate = Date()
                DefaultEventAppStateDAO.shared.create(appData)
            } else {
                let appData = AppEventData()
                DefaultEventAppStateDAO.shared.create(appData)
            }
            completion?()
        }
    }

    /*
     *  Any given send event must check the status
     *  check if campaign exist in event engine & status is not active
     *  check if campaign doesn't exist in event engine & status is active
     */
    private func fetchCampaignStatusForEventEngine(eventName: String, completion: (() -> Void)? = nil) {
        let localCampaigns = UBCampaignDAO.shared.readAll()
        let event = Event(name: eventName)
        let campaignThatResponds = localCampaigns.filter {
            $0.respondToEvents(event: event)
        }
        if !campaignThatResponds.isEmpty {
            for (idx, campaigns) in campaignThatResponds.enumerated() {
                campaignStore.getCampaignStatus(withID: campaigns.identifier).then { campaign in
                    let campaignEvent = self.eventEngine.campaigns.filter { $0.identifier == campaign.identifier}
                    if campaignEvent.count != 0 && campaign.status != .active {
                        self.eventEngine.campaigns.removeAll { (item) -> Bool in
                            item.identifier == campaign.identifier
                        }
                    } else if campaignEvent.count == 0 && campaign.status == .active {
                        self.eventEngine.campaigns.append(campaign)
                    }
                }
                if idx == campaignThatResponds.endIndex-1 {
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }

    /*
     *  Any given Campaign must have the following
     *  bannerpage
     *  endpage
     */
    private func testIntegrityOfCampaginForm(_ form: FormModel?) -> Bool {
        // A campaign must have a form, and a form must 2 pages
        guard let form = form,
            form.pages.count >= 2 else {
            return false
        }
        if !(form.pages.first is IntroPageModel) {
            PLog("The Campaings first page isn't a start page (banner)")
            return false
        }
        if !(form.pages.last is UBEndPageModel) {
            PLog("The Campaigns last page isn't a endpage (splash)")
            return false
        }

        return true
    }

    #if INTERNAL_USE || DEBUG
    @discardableResult func displayCampaignForm(_ form: FormModel, manager: CampaignSubmissionRequestManager? = nil, campaignID: String = "id") -> Bool {
            var manager = manager
            if manager == nil {
                manager = CampaignSubmissionRequestManager(appID: self.appID, campaignID: campaignID, formVersion: form.version, userContext: ["debug": "debug"], campaignSubmissionManager: self.submissionManager)
            }
            // swiftlint:disable:next force_unwrapping
            let campaignViewModel = CampaignViewModel(form: form, manager: manager!)
            return CampaignWindow.shared.showCampaign(campaignViewModel, bannerConfig: bannerConfig)
        }

    #else
        @discardableResult func displayCampaignForm(_ form: FormModel, manager: CampaignSubmissionRequestManager, campaignID: String = "id") -> Bool {
            let campaignViewModel = CampaignViewModel(form: form, manager: manager)
            return CampaignWindow.shared.showCampaign(campaignViewModel, bannerConfig: bannerConfig)
        }
    #endif
}
