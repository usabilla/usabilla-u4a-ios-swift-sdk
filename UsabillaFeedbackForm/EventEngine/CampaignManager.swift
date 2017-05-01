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
        if CampaignWindow.shared.showCampaign(campaign) {
            campaign.numberOfTimesTriggered += 1
            UBCampaignDAO.shared.create(campaign)
        }
    }
}
