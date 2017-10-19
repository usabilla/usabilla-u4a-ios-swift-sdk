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

    private func deleteLocalCampaigns(notInCampaigns campaigns: [CampaignModel]) {
        let localCampaignsList = UBCampaignDAO.shared.readAll()
        for localCampaign in localCampaignsList {
            let shouldDeleteCampaign = !campaigns.contains {
                $0.identifier == localCampaign.identifier
            }
            if shouldDeleteCampaign {
                UBCampaignDAO.shared.delete(localCampaign)
            }
        }
    }

    private func updateCampaignData(serverCampaign: CampaignModel, localCampaigns: [CampaignModel]) -> CampaignModel {
        if let localCampaign = localCampaigns.first(where: { model in
            model.identifier == serverCampaign.identifier
        }) {
            serverCampaign.numberOfTimesTriggered = localCampaign.numberOfTimesTriggered
            if !shouldUpdateTargeting(serverTargeting: serverCampaign.targeting, localTargeting: localCampaign.targeting) {
                serverCampaign.targeting = localCampaign.targeting
            }
        }
        return serverCampaign
    }

    private func shouldUpdateTargeting(serverTargeting: TargetingOptionsModel, localTargeting: TargetingOptionsModel) -> Bool {
        if let lastModifiedServer = serverTargeting.lastModifiedDate {
            let lastModifiedLocal = localTargeting.lastModifiedDate
            //swiftlint:disable:next force_unwrapping
            if lastModifiedLocal == nil || lastModifiedServer > lastModifiedLocal! {
                return true
            }
        }
        return false
    }

    /**
     - returns: a promise of CampaignModel array
     */
    func getCampaigns(withAppID appID: String) -> Promise<[CampaignModel]> {
        return Promise { fulfill, reject in
            getCampaignsFromService(withAppID: appID).then { cachableCampaigns in
                guard cachableCampaigns.hasChanged else {
                    fulfill(cachableCampaigns.value)
                    return
                }
                let validServerCampaigns = cachableCampaigns.value.filter { $0.status != .invalid }

                let localCampaigns = UBCampaignDAO.shared.readAll()

                self.deleteLocalCampaigns(notInCampaigns: validServerCampaigns)

                let updatedCampaigns = validServerCampaigns.map {
                    self.updateCampaignData(serverCampaign: $0, localCampaigns: localCampaigns)
                }

                updatedCampaigns.forEach { UBCampaignDAO.shared.create($0) }
                fulfill(updatedCampaigns)

            }.catch { error in
                PLog("Error loading campaigns :\(error.localizedDescription)")
                let localCampaigns = UBCampaignDAO.shared.readAll()
                if localCampaigns.count > 0 {
                    fulfill(localCampaigns)
                    return
                }
                reject(error)
            }
        }
    }

    private func getCampaignsFromService(withAppID appID: String) -> Promise<Cachable<[CampaignModel]>> {
        return Promise { fulfill, reject in
            self.campaignService.getCampaignsJSON(withAppID: appID).then { cachableArray in
                guard cachableArray.hasChanged else {
                    fulfill(Cachable(value: UBCampaignDAO.shared.readAll(), hasChanged: false))
                    return
                }
                let targetingIDs = cachableArray.value.flatMap { $0["targeting_options_id"].stringValue }
                guard cachableArray.value.count > 0 || targetingIDs.count > 0 else {
                    fulfill(Cachable(value: [], hasChanged: true))
                    return
                }
                self.campaignService.getTargetings(withIDs: targetingIDs).then { targetings in
                    let campaigns = UBCampaignStore.buildCampaigns(fromJsonArray: cachableArray.value, withTargetings: targetings)
                    fulfill(Cachable(value: campaigns, hasChanged: true))
                }.catch { error in
                    reject(error)
                }
            }.catch { error in
                reject(error)
            }
        }
    }

    private class func buildCampaigns(fromJsonArray: [JSON], withTargetings targetings: [TargetingOptionsModel]) -> [CampaignModel] {
        var campaigns: [CampaignModel] = []
        for json in fromJsonArray {
            guard let targeting = targetings.first(where: { $0.targetingID == json["targeting_options_id"].string }),
                let campaign = CampaignModel(json: json, targeting: targeting) else { continue }
            campaigns.append(campaign)
        }
        return campaigns
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
