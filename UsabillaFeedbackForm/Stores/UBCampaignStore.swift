//
//  UBCampaignStore.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBCampaignStoreProtocol {
    func getCampaigns(appId: String) -> Promise<[CampaignModel]>
    func getTargetingForCampaign(id: String) -> Promise<Rule>
}

class UBCampaignStore: UBCampaignStoreProtocol {

    let campaignService: CampaignService

    init(service: CampaignService) {
        self.campaignService = service
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            // TO DO Add networking
            self.campaignService.getCampaignsFor(appId: appId).then(execute: { campainModelList in
                for campaignModel in campainModelList {
                    UBCampaignDAO.shared.create(campaignModel)
                    PLog("campaign identifier : \(campaignModel.identifier)")
                }
                fulfill(campainModelList)
                return
            }).catch(execute: { error in
                PLog("Error loading campaigns :\(error.localizedDescription)")
                let cachedCampaigns = UBCampaignDAO.shared.readAll()
                if cachedCampaigns.count > 0 {
                    fulfill(cachedCampaigns)
                    return
                }
                reject(error)
            })
        }
    }
    
    func getTargetingForCampaign(id: String) -> Promise<Rule> {
        return self.campaignService.getTargetingForCampaign(id: "campId").then(execute: { rule in
            PLog(rule.ruleID)
        })
    }
}
