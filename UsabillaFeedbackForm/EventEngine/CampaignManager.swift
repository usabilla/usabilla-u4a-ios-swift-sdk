//
//  CampaignManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 05/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignManager {

    private var campaignStore: UBCampaignStoreProtocol

    init(campaignStore: UBCampaignStoreProtocol) {
        self.campaignStore = campaignStore
    }

    static func sendEvent(event: String) { }

    func start(appId: String) {
        campaignStore.getCampaigns(appId: appId).then { campaigns in
            EventEngine.campaigns = campaigns.filter { $0.canBeDisplayed }
        }
    }

    class func saveCampaigns() {
        //Save the status of all campaigns
    }

    class func saveCampaign(campaign: CampaignModel) {
        //Saves a single campaign in DB
    }

//    class func fetchCampaigns() -> [CampaignModel] {
//        //Retrieves campaigns from DB
//    }

}
