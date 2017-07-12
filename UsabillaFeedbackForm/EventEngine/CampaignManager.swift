//
//  CampaignManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 05/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignManager {

    private(set) var campaignStore: UBCampaignStoreProtocol
    private(set) var campaignService: CampaignServiceProtocol
    private(set) var eventEngine: EventEngine
    private(set) var appId: String

    private let submissionManager: CampaignSubmissionManager

    init(campaignStore: UBCampaignStoreProtocol, campaignService: CampaignServiceProtocol, appId: String) {
        self.campaignStore = campaignStore
        self.campaignService = campaignService
        self.eventEngine = EventEngine(campaigns: [])
        self.appId = appId
        self.submissionManager = CampaignSubmissionManager(DAO: UBCampaignFeedbackRequestDAO.shared)
        campaignStore.getCampaigns(withAppId: appId).then { campaigns in
            self.eventEngine = EventEngine(campaigns: campaigns.filter { $0.canBeDisplayed })
        }
    }

    func sendEvent(event: String) {
        let (respondingCampaigns, triggeredCampaigns) = eventEngine.sendEvent(event)

        // Persist all updated campaigns
        respondingCampaigns.forEach {
            UBCampaignDAO.shared.create($0)
        }

        // Display first triggered campaign
        if let campaignToDisplay = triggeredCampaigns.first {
            displayCampaign(campaignToDisplay)
        }
    }

    func displayCampaign(_ campaign: CampaignModel) {
        guard campaign.canBeDisplayed && UsabillaFeedbackForm.canDisplayCampaigns else {
            return
        }
        campaignStore.getCampaignForm(withFormId: campaign.formId, theme: UsabillaFeedbackForm.theme).then { form in
            let submissionManager = CampaignSubmissionRequestManager(appId: self.appId, campaignId: campaign.identifier, formVersion: form.version, customVars: nil, campaignSubmissionManager: self.submissionManager)
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

    @discardableResult func displayCampaignForm(_ form: FormModel, manager: CampaignSubmissionRequestManager? = nil, campaignId: String = "id") -> Bool {
        var manager = manager
        if manager == nil {
            //TODO REMOVE ME FOR GOD'S SAKE I'M HERE JUST FOR DEV PURPOSES
            manager = CampaignSubmissionRequestManager(appId: self.appId, campaignId: campaignId, formVersion: form.version, customVars: nil, campaignSubmissionManager: self.submissionManager)
        }

        let campaignViewModel = CampaignViewModel(form: form, manager: manager!)
        return CampaignWindow.shared.showCampaign(campaignViewModel)
    }

    private func incrementViews(forCampaign campaign: CampaignModel) {
        self.campaignService.incrementCampaignViews(forCampaignId: campaign.identifier, viewCount: 1).then { _ in
            PLog("View count increment for campaign id \(campaign.identifier)")
        }.catch { _ in
            PLog("Error incrementing view count for campaign id \(campaign.identifier)")
        }
    }
}
