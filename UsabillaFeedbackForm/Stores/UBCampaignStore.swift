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

    private func deleteCachedCampaigns(notIn campaigns: [CampaignModel]) {
        let cachedCampaignsList = UBCampaignDAO.shared.readAll()
        for cachedCampaign in cachedCampaignsList {
            let shouldDeleteCampaign = !campaigns.contains {
                $0.identifier == cachedCampaign.identifier
            }
            if shouldDeleteCampaign {
                UBCampaignDAO.shared.delete(cachedCampaign)
            }
        }
    }

    private func updateTargeting(campaigns: [CampaignModel], completion: (([CampaignModel]) -> Void)?) {
        var count = 0
        let doneFetchingTargeting: (_ campaign: CampaignModel) -> Void = { campaign in
            UBCampaignDAO.shared.create(campaign)
            count += 1
            if count == campaigns.count {
                completion?(campaigns)
                return
            }
        }
        for campaignModel in campaigns {
            // load targetings
            self.campaignService.getTargeting(withId: campaignModel.targetingId).then(execute: { result in
                if result.hasChanged {
                    campaignModel.rule = result.value
                } else {
                    let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                    campaignModel.rule = cachedRule
                }
                doneFetchingTargeting(campaignModel)
            }).catch(execute: { _ in
                let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                campaignModel.rule = cachedRule
                doneFetchingTargeting(campaignModel)
            })
        }
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaigns(withAppId: appId).then(execute: { cachableCampainModels in
                let cachedCampaignsList = UBCampaignDAO.shared.readAll()
                if !cachableCampainModels.hasChanged {
                    return fulfill(cachedCampaignsList)
                }

                let campaignModelList = cachableCampainModels.value
                if campaignModelList.count == 0 {
                    UBCampaignDAO.shared.deleteAll()
                    return fulfill(campaignModelList)
                }
                self.deleteCachedCampaigns(notIn: campaignModelList)

                self.updateTargeting(campaigns: campaignModelList) { campaigns in
                    fulfill(campaigns)
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
