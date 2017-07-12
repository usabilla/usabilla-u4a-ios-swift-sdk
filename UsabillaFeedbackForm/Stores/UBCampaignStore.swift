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
    func getCampaignForm(withFormId formId: String, theme: UsabillaTheme) -> Promise<FormModel>
}

class UBCampaignStore: UBCampaignStoreProtocol {

    let campaignService: CampaignServiceProtocol

    init(service: CampaignServiceProtocol) {
        self.campaignService = service
    }

    private func deleteCachedCampaigns(notInCampaigns campaigns: [CampaignModel]) {
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

    private func updateTargeting(forCampaigns campaigns: [CampaignModel], completion: (([CampaignModel]) -> Void)?) {
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
            self.campaignService.getTargeting(withId: campaignModel.targetingId).then { result in
                if result.hasChanged {
                    campaignModel.rule = result.value
                } else {
                    let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                    campaignModel.rule = cachedRule
                }
                doneFetchingTargeting(campaignModel)
            }.catch { _ in
                let cachedRule = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.rule
                campaignModel.rule = cachedRule
                doneFetchingTargeting(campaignModel)
            }
        }
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppId appId: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaigns(withAppId: appId).then { cachableCampainModels in
                let cachedCampaignsList = UBCampaignDAO.shared.readAll()
                if !cachableCampainModels.hasChanged {
                    return fulfill(cachedCampaignsList)
                }

                let campaignModelList = cachableCampainModels.value.filter { $0.status != .invalid }
                if campaignModelList.count == 0 {
                    UBCampaignDAO.shared.deleteAll()
                    return fulfill([])
                }
                self.deleteCachedCampaigns(notInCampaigns: campaignModelList)

                let activeCampaigns = campaignModelList.filter { $0.status == .active }

                self.updateTargeting(forCampaigns: activeCampaigns) { campaigns in
                    fulfill(campaigns)
                }
            }.catch { error in
                PLog("Error loading campaigns :\(error.localizedDescription)")
                let cachedCampaigns = UBCampaignDAO.shared.readAll()
                if cachedCampaigns.count > 0 {
                    fulfill(cachedCampaigns)
                    return
                }
                reject(error)
            }
        }
    }

    func getCampaignForm(withFormId formId: String, theme: UsabillaTheme) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaignForm(withId: formId).then { formModel in
                formModel.theme = theme
                formModel.updateTheme()
                fulfill(formModel)
            }.catch(execute: reject)
        }
    }

}
