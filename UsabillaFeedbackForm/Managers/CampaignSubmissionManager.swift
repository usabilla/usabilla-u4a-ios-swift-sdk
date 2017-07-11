//
//  CampaignSubmissionManager.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 16/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class CampaignSubmissionManager: CampaignSubmissionManagerProtocol {

    private var reachability: Reachable
    private let submissionSerialQueue = DispatchQueue(label: "com.usabilla.u4a.campaignsubmissionmanager")
    private let semaphore = DispatchSemaphore(value: 0)
    private let service: SubmissionServiceProtocol
    private let DAO: UBCampaignFeedbackRequestDAO
    private let maxNumberOfSubmissionAttempts = 3

    init(DAO: UBCampaignFeedbackRequestDAO, service: SubmissionServiceProtocol = CampaignService(), reachability: Reachable = Reachability()!) {
        self.service = service
        self.DAO = DAO
        self.reachability = reachability
        try? reachability.startNotifier()
        self.reachability.whenReachable = { reachability in
            if self.reachability.isReachable {
                self.submitNextItem()
            }
        }
    }

    private func submitNextItem() {
        guard let item = nextStoreItem(), reachability.isReachable else { return }
        sendToService(request: item)
    }

    private func nextStoreItem() -> UBCampaignFeedbackRequest? {
        return self.DAO.readAll().first
    }

    private func sendToService(request: UBCampaignFeedbackRequest) {
        submissionSerialQueue.async {
            self.service.submit(withRequest: request.request).then { _ in
                self.DAO.delete(request)
                self.submitNextItem()
                self.semaphore.signal()
            }.catch { _ in
                request.numberOfSubmissionAttempts += 1
                if request.numberOfSubmissionAttempts >= self.maxNumberOfSubmissionAttempts {
                    self.DAO.delete(request)
                    self.semaphore.signal()
                    return
                }
                self.DAO.create(request)
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
