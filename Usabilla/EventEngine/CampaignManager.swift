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

    // customVariables sent from the interface are the activeStatuses used inside our SDK.
    func sendEvent(event: String, customVariables: [String: Any]) {
        let (respondingCampaigns, triggeredCampaigns) = eventEngine.sendEvent(event, activeStatuses: filterActiveStatuses(fromCustomVariables: customVariables))

        // Persist all updated campaigns
        respondingCampaigns.forEach {
            UBCampaignDAO.shared.create($0)
        }

        // Display first triggered campaign that can be displayed
        let displayableCampaign = triggeredCampaigns.sorted {
            $0.0.createdAt > $0.1.createdAt
        }.first {
            $0.canBeDisplayed == true
        }

        guard let campaignToDisplay = displayableCampaign else {
            return
        }
        displayCampaign(campaignToDisplay, withUserContext: customVariables)
    }

    func displayCampaign(_ campaign: CampaignModel, withUserContext userContext: [String: Any]) {
        guard campaign.canBeDisplayed && UsabillaInternal.canDisplayCampaigns else {
            return
        }
        campaignStore.getCampaignForm(withFormID: campaign.formID, theme: UsabillaInternal.theme, position: campaign.position).then { form in
            let submissionManager = CampaignSubmissionRequestManager(appID: self.appID, campaignID: campaign.identifier, formVersion: form.version, userContext: userContext, campaignSubmissionManager: self.submissionManager)
            if self.displayCampaignForm(form, manager: submissionManager) {
                campaign.numberOfTimesTriggered += 1
                UBCampaignDAO.shared.create(campaign)
                self.incrementViews(forCampaign: campaign)
                return
            }
            PLog("A campaign is already displayed")
        }.catch { error in
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
