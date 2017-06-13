//
//  CampaignManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 05/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol CampaignSubmissionManagerDelegate: class {
    func pageDidTurn(pageIndex: Int, pageModel: PageModel, nextPageType: PageType)
}

class CampaignManager {

    private(set) var campaignStore: UBCampaignStoreProtocol
    private(set) var eventEngine: EventEngine
    private(set) var appId: String
    private(set) var submissionManager: CampaignSubmissionManager?

    init(campaignStore: UBCampaignStoreProtocol, appId: String) {
        self.campaignStore = campaignStore
        self.eventEngine = EventEngine(campaigns: [])
        self.appId = appId

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
            self.submissionManager = CampaignSubmissionManager(appId: self.appId, campaignId: campaign.identifier, formVersion: form.version, customVars: nil, campaignService: CampaignService())
            if self.displayCampaignForm(form) {
                campaign.numberOfTimesTriggered += 1
                UBCampaignDAO.shared.create(campaign)
                return
            }
            PLog("A campaign is already displayed")
        }.catch { error in
            PLog(error)
        }
    }

    @discardableResult func displayCampaignForm(_ form: FormModel) -> Bool {
        if self.submissionManager == nil {
            //TODO REMOVE ME FOR GOD'S SAKE I'M HERE JUST FOR DEV PURPOSES
            self.submissionManager = CampaignSubmissionManager(appId: self.appId, campaignId: "removemeplz", formVersion: form.version, customVars: nil, campaignService: CampaignService())
        }

        let campaignViewModel = CampaignViewModel(form: form, delegate: self)
        return CampaignWindow.shared.showCampaign(campaignViewModel)
    }
}

extension CampaignManager: CampaignSubmissionManagerDelegate {
    func pageDidTurn(pageIndex: Int, pageModel: PageModel, nextPageType: PageType) {
        submissionManager?.submitPage(page: pageModel, nextPageType: nextPageType)
    }
}
