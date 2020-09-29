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
    func sendEvent(event: String, customVariables: [String: Any], logId: String? = nil) {
        let (respondingCampaigns, triggeredCampaigns) = eventEngine.sendEvent(event, activeStatuses: filterActiveStatuses(fromCustomVariables: customVariables))

        // Persist all updated campaigns
        respondingCampaigns.forEach {
            UBCampaignDAO.shared.create($0)
        }

        // Display first triggered campaign that can be displayed
        let displayableCampaign = triggeredCampaigns.sorted {
            $0.createdAt > $1.createdAt
        }.first {
            $0.canBeDisplayed == true
        }

        guard let campaignToDisplay = displayableCampaign else {
            if telemetric != nil {
                if triggeredCampaigns.count == 0 {
                    self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodMessage, value: TelemetryConstants.noCampaingFound, logLevel: .methods)
                } else {
                    self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodMessage, value: TelemetryConstants.campaingAlraedyTriggered, logLevel: .methods)
                }
                telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)
            }
            return
        }
        displayCampaign(campaignToDisplay, withUserContext: customVariables, logId: logId)
    }

    func displayCampaign(_ campaign: CampaignModel, withUserContext userContext: [String: Any], logId: String? = nil) {
        guard campaign.canBeDisplayed && UsabillaInternal.canDisplayCampaigns else {
            if telemetric != nil {
                telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)
            }
            return
        }
        campaignStore.getCampaignForm(withFormID: campaign.formID, theme: UsabillaInternal.theme, position: campaign.position, maskModel: maskModel).then { form in

            guard self.testIntegrityOfCampaginForm(form) else {
                let text = "form: \(campaign.formID) integrity incorrect"
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodMessage, value: text, logLevel: .methods)
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodResult, value: false, logLevel: .methods)
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
                self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)
                return
            }
            let submissionManager = CampaignSubmissionRequestManager(appID: self.appID, campaignID: campaign.identifier, formVersion: form.version, userContext: userContext, campaignSubmissionManager: self.submissionManager)
            if self.displayCampaignForm(form, manager: submissionManager) {
                self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: true, logLevel: .methods)
                campaign.numberOfTimesTriggered += 1
                UBCampaignDAO.shared.create(campaign)
                self.incrementViews(forCampaign: campaign)
                self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)
                return
            }

            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodMessage, value: TelemetryConstants.campaingAlreadyShowing, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodResult, value: false, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
            self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)

            PLog(TelemetryConstants.campaingAlreadyShowing)
        }.catch { error in
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodMessage, value: error.localizedDescription, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.methodResult, value: false, logLevel: .methods)
            self.telemetric?.alterData(for: logId, keyPath: \UBTelemetricSendEvent.displayed, value: false, logLevel: .methods)
            self.telemetric?.logEnd(for: logId, keyPath: \UBTelemetricSendEvent.duration)
            PLog(error)
        }
    }

    private func incrementViews(forCampaign campaign: CampaignModel) {
        self.campaignService.incrementCampaignViews(forCampaignID: campaign.identifier, viewCount: 1).then { _ in
            PLog("View count increment for campaign id \(campaign.identifier)")
        }.catch { _ in
            PLog("Error incrementing view count for campaign id \(campaign.identifier)")
        }
    }

    func filterActiveStatuses(fromCustomVariables variables: [String: Any]) -> [String: String] {
        let filtered = variables.filter { type(of: $0.1) == String.self }
        var activeStatuses = [String: String]()
        for result in filtered {
            //swiftlint:disable:next force_cast
            activeStatuses[result.0] = (result.1 as! String)
        }
        return activeStatuses
    }

    func resetData(completion: (() -> Void)?) {
        UBCampaignDAO.shared.deleteAll()
        fetchCampaignForEventEngine(completion: completion)
    }

    private func fetchCampaignForEventEngine(completion: (() -> Void)? = nil) {
        campaignStore.getCampaigns(withAppID: appID).then { campaigns in
            self.eventEngine.campaigns = campaigns.filter { $0.status == .active }
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
            //swiftlint:disable:next force_unwrapping
            let campaignViewModel = CampaignViewModel(form: form, manager: manager!)
            return CampaignWindow.shared.showCampaign(campaignViewModel)
        }

    #else
        @discardableResult func displayCampaignForm(_ form: FormModel, manager: CampaignSubmissionRequestManager, campaignID: String = "id") -> Bool {
            let campaignViewModel = CampaignViewModel(form: form, manager: manager)
            return CampaignWindow.shared.showCampaign(campaignViewModel)
        }
    #endif
}
