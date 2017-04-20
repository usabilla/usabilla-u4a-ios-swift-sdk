//
//  UBCampaignStore.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCampaignStore {

    /**
     - returns: a promise of CampaignModel array
     */
    class func getCampaigns(appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, _ in
            // TO DO Add networking
            fulfill(UBCampaignDAO.shared.readAll())
        }
    }

    /**
     Persist a CampaignModel object
     - returns: **true** if saving succeed or **false** if it failed
    */
    @discardableResult class func saveCampaign(campaign: CampaignModel) -> Bool {
        return UBCampaignDAO.shared.create(campaign)
    }
}
