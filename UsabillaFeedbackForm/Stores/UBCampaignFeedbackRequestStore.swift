//
//  UBCampaignResultsStore.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 14/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

protocol UBCampaignFeedbackRequestStoreProtocol {
    func save(feedbackRequest request: UBCampaignFeedbackRequestItem)
    func getRequest(withFeedbackId id: String) -> UBCampaignFeedbackRequest?
    func getAll() -> [UBCampaignFeedbackRequest]
}

class UBCampaignFeedbackRequestStore: UBCampaignFeedbackRequestStoreProtocol {

    let campaignDAO: UBCampaignFeedbackRequestDAO

    init(campaignDAO: UBCampaignFeedbackRequestDAO) {
        self.campaignDAO = campaignDAO
    }

    func save(feedbackRequest request: UBCampaignFeedbackRequestItem) {
        if let saved = campaignDAO.read(id: request.feedbackId) {
            saved.items.append(request)
            campaignDAO.saveToFile(id: request.feedbackId, data: saved)
            return
        }
        let toSave = UBCampaignFeedbackRequest(id: request.feedbackId, items: [request])
        campaignDAO.saveToFile(id: request.feedbackId, data: toSave)
    }

    func getRequest(withFeedbackId id: String) -> UBCampaignFeedbackRequest? {
        if let result = campaignDAO.read(id: id) {
            result.items = orderRequestItems(items: result.items)
            return result
        }
        return nil
    }

    func getAll() -> [UBCampaignFeedbackRequest] {
        let collection = campaignDAO.readAll()
        for item in collection {
            item.items = orderRequestItems(items: item.items)
        }
        return collection
    }

    func delete(id: String) {
        if let toDelete = campaignDAO.read(id: id) {
            campaignDAO.delete(toDelete)
        }
    }

    func delete(obj: UBCampaignFeedbackRequest) {
        campaignDAO.delete(obj)
    }

    private func orderRequestItems(items: [UBCampaignFeedbackRequestItem]) -> [UBCampaignFeedbackRequestItem] {
        var orderedArray: [UBCampaignFeedbackRequestItem] = []
        if let sub = items.first(where: { $0.type == .start }) {
            orderedArray.append(sub)
        }
        let sub = items.filter({ $0.type == .page })
        orderedArray.append(contentsOf: sub)
        if let sub = items.first(where: { $0.type == .close }) {
            orderedArray.append(sub)
        }
        return orderedArray
    }

}
