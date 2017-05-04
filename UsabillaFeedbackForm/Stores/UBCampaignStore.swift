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

    let campaignService: CampaignServiceProtocol

    init(service: CampaignServiceProtocol) {
        self.campaignService = service
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaigns(withAppId: appId).then(execute: { cachableCampainModels in

                let hasChanged = cachableCampainModels.hasChanged
                let cachedCampaignsList = UBCampaignDAO.shared.readAll()

                // nothing has changed, return the cached campaigns list
                if !hasChanged {//
                    return fulfill(cachedCampaignsList)//
                }

                let campaignModelList = cachableCampainModels.value
                if campaignModelList.count == 0 {//
                    UBCampaignDAO.shared.deleteAll()
                    return fulfill(campaignModelList)//
                }
                // if something has changed
                // loop over Cached campaigns and delete ones that does not exist in new list
                for cachedCampaign in cachedCampaignsList {
                    var found = false
                    for newCampaign in campaignModelList where cachedCampaign.identifier == newCampaign.identifier {
                        found = true
                    }
                    if !found {
                        UBCampaignDAO.shared.delete(cachedCampaign)
                    }
                }

                // counter of how many trigger requests are done.
                // fulfill only if count == campaignModelList.count
                var count = 0
                for campaignModel in campaignModelList {
                    // load targetings
                    self.campaignService.getTargeting(withId: campaignModel.targetingId).then(execute: { result in
                        if result.hasChanged {
                            campaignModel.rule = result.value
                        } else {
                            let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                            campaignModel.rule = cachedRule
                        }
                        // persist campaign even if targetting hasn't changed
                        UBCampaignDAO.shared.create(campaignModel)
                        // increment counter and fulfill if all requests are done
                        count += 1
                        if count == campaignModelList.count {
                            fulfill(campaignModelList)
                            return
                        }
                    }).catch(execute: { _ in
                        let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                        campaignModel.rule = cachedRule
                        UBCampaignDAO.shared.create(campaignModel)

                        count += 1
                        if count == campaignModelList.count {
                            fulfill(campaignModelList)
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
