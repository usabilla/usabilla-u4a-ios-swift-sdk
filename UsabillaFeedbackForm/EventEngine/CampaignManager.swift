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

        campaignStore.getCampaigns(appId: appId).then { campaigns in
            self.eventEngine = EventEngine(campaigns: campaigns.filter { $0.canBeDisplayed })
        }
    }

    func sendEvent(event: String) {
        let (respondingCampaigns, _) = eventEngine.triggerEvent(event)
        respondingCampaigns.forEach {
            UBCampaignDAO.shared.create($0)
        }
    }

    class func saveCampaigns() {
        //Save the status of all campaigns
    }

    class func saveCampaign(campaign: CampaignModel) {
        //Saves a single campaign in DB
    }
}
