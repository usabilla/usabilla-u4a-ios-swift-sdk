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
    private(set) var eventEngine: EventEngine

    init(campaignStore: UBCampaignStoreProtocol, appId: String) {
        self.campaignStore = campaignStore
        self.eventEngine = EventEngine(campaigns: [])

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
        let campaignViewModel = CampaignViewModel(form: form)
        return CampaignWindow.shared.showCampaign(campaignViewModel)
    }
}
