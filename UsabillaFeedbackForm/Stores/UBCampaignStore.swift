//
//  UBCampaignStore.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBCampaignStoreProtocol {
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]>
}

class UBCampaignStore: UBCampaignStoreProtocol {

    let campaignService: CampaignService

    init(service: CampaignService) {
        self.campaignService = service
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaigns(withAppId: appId).then(execute: { campainModelList in
                if campainModelList.count == 0 {
                    return fulfill(campainModelList)
                }
                // counter of how many trigger requests are done.
                // fulfill only if count == campaignModelList.count
                var count = 0
                for campaignModel in campainModelList {
                    // load targetings
                    self.campaignService.getTargeting(withId: campaignModel.targetingId).then(execute: { result in
                        if result.hasChanged {
                            campaignModel.rule = result.value
                        }
                        // persist campaign even if targetting hasn't changed
                        UBCampaignDAO.shared.create(campaignModel)
                        // increment counter and fulfill if all requests are done
                        count += 1
                        if count == campainModelList.count {
                            fulfill(campainModelList)
                            return
                        }
                    }).catch(execute: { _ in
                        count += 1
                        if count == campainModelList.count {
                            fulfill(campainModelList)
                            return
                        }
                    })
                }
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
}
