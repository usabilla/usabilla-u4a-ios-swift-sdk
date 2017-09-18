//
//  CampaignSubmissionManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 16/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignSubmissionManager: CampaignSubmissionManagerProtocol {

    private var reachability: Reachable
    private let submissionSerialQueue = DispatchQueue(label: "com.usabilla.u4a.campaignsubmissionmanager")
    private let semaphore = DispatchSemaphore(value: 0)
    private let service: SubmissionServiceProtocol
    private let DAO: UBCampaignFeedbackRequestDAO
    private let maxNumberOfSubmissionAttempts = 3
    private var feedbackIDs: NSMutableDictionary = [:]
    private var dictionaryStore: UBFeedbackIDDictionaryDAO

    // swiftlint:disable:next force_unwrapping
    init(DAO: UBCampaignFeedbackRequestDAO, dictionaryStore: UBFeedbackIDDictionaryDAO, service: SubmissionServiceProtocol = CampaignService(), reachability: Reachable = Reachability()!) {
        self.service = service
        self.DAO = DAO
        self.reachability = reachability
        try? reachability.startNotifier()
        self.dictionaryStore = dictionaryStore
        if let dictionary = dictionaryStore.read(id: UBFeedbackIDDictionaryDAO.dictionaryID) {
            feedbackIDs = dictionary
        }

        self.reachability.whenReachable = { reachability in
            if self.reachability.isReachable {
                self.submitNextItem()
            }
        }
    }

    private func submitNextItem() {
        guard let partialFeedbackItem = nextPartialFeedbackRequest(), reachability.isReachable else { return }
        sendToService(partialFeedbackRequest: partialFeedbackItem)
    }

    private func nextPartialFeedbackRequest() -> UBCampaignFeedbackRequest? {
        return self.DAO.readAll().first
    }

    //swiftlint:disable force_unwrapping
    private func updateUrl(request: URLRequest, oldID: String, newID: String) -> URLRequest {
        var mutableRequest = request
        let url = mutableRequest.url!.absoluteString
        let newUrl = url.replacingOccurrences(of: oldID, with: newID)
        mutableRequest.url = URL(string: newUrl)!
        return mutableRequest
    }
    //swiftlint:enable force_unwrapping

    private func sendToService(partialFeedbackRequest: UBCampaignFeedbackRequest) {
        submissionSerialQueue.async {
            var request = partialFeedbackRequest.request
            if let backendFeedbackID = self.feedbackIDs[partialFeedbackRequest.internalID] as? String {
                request = self.updateUrl(request: request, oldID: partialFeedbackRequest.internalID, newID: backendFeedbackID)
            }

            self.service.submit(withRequest: request).then { feedbackID in
                if let feedbackID = feedbackID {
                    self.feedbackIDs.setObject(feedbackID, forKey: partialFeedbackRequest.internalID as NSCopying)
                    self.dictionaryStore.create(self.feedbackIDs)
                }
                self.DAO.delete(partialFeedbackRequest)
                self.submitNextItem()
                self.semaphore.signal()
            }.catch { _ in
                partialFeedbackRequest.numberOfSubmissionAttempts += 1
                if partialFeedbackRequest.numberOfSubmissionAttempts >= self.maxNumberOfSubmissionAttempts {
                    self.DAO.delete(partialFeedbackRequest)
                    self.semaphore.signal()
                    return
                }
                self.DAO.create(partialFeedbackRequest)
                self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }

    func handle(request: UBCampaignFeedbackRequest) {
        DAO.create(request)
        submitNextItem()
    }
}
