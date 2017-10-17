//
//  UBCampaignStore.swift
//  Usabilla
//
//  Created by Benjamin Grima on 14/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBCampaignStoreProtocol {
    func getCampaigns(withAppID appID: String) -> Promise<[CampaignModel]>
    func getCampaignForm(withFormID formID: String, theme: UsabillaTheme) -> Promise<FormModel>
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
            self.campaignService.getTargeting(withID: campaignModel.targetingID).then { result in
                if result.hasChanged {
                    campaignModel.targeting = result.value
                } else {
                    let cachedTargeting = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.targeting
                    campaignModel.targeting = cachedTargeting ?? result.value
                }
                doneFetchingTargeting(campaignModel)
            }.catch { _ in
                let cachedTargeting = UBCampaignDAO.shared.read(id: campaignModel.identifier)?.targeting
                campaignModel.targeting = cachedTargeting
                doneFetchingTargeting(campaignModel)
            }
        }
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppID appID: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaigns(withAppID: appID).then { serverCampaigns in
                let localCampaigns = UBCampaignDAO.shared.readAll()
                if !serverCampaigns.hasChanged {
                    return fulfill(localCampaigns)
                }

                let activeInactiveCampaigns = serverCampaigns.value.filter { $0.status != .invalid }

                guard activeInactiveCampaigns.count > 0 else {
                    UBCampaignDAO.shared.deleteAll()
                    return fulfill([])
                }
                self.deleteCachedCampaigns(notInCampaigns: activeInactiveCampaigns)

                // update number of times triggered
                activeInactiveCampaigns
                    .forEach {
                        let campaignIDentifier = $0.identifier
                        let cachedCampaign = localCampaigns.first(where: { model in
                            model.identifier == campaignIDentifier
                        })
                        $0.numberOfTimesTriggered = cachedCampaign?.numberOfTimesTriggered ?? 0
                }

                // update inactive campaigns in cache
                activeInactiveCampaigns
                    .filter { $0.status == .inactive }
                    .forEach {
                        let cachedRule = UBCampaignDAO.shared.read(id: $0.identifier)?.targeting
                        $0.targeting = cachedRule
                        UBCampaignDAO.shared.create($0)
                }

                // update targeting only for active campaigns
                let activeCampaigns = activeInactiveCampaigns.filter { $0.status == .active }
                guard activeCampaigns.count > 0 else {
                    return fulfill([])
                }
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

    func getCampaignForm(withFormID formID: String, theme: UsabillaTheme) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaignForm(withID: formID).then { formModel in
                formModel.theme = theme
                formModel.updateTheme()
                fulfill(formModel)
            }.catch(execute: reject)
        }
    }

}
