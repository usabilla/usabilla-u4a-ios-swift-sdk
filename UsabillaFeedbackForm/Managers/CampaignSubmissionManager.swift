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
    private let service: CampaignServiceProtocol
    private let campaignDAO: UBCampaignFeedbackRequestDAO

    init(campaignDAO: UBCampaignFeedbackRequestDAO, campaignService: CampaignServiceProtocol = CampaignService(), reachability: Reachable = Reachability()!) {
        self.service = campaignService
        self.campaignDAO = campaignDAO
        self.reachability = reachability
        try? reachability.startNotifier()
        self.reachability.whenReachable = { reachability in
            if self.reachability.isReachable {
                self.trySendData()
            }
        }
    }

    private func trySendData() {
        submissionSerialQueue.async {
            guard let request = self.campaignDAO.readAll().first else {
                return
            }
            self.service.submitCampaignResult(withRequest: request.request).then { _ in
                self.campaignDAO.delete(request)
                self.trySendData()
                self.semaphore.signal()
                }.catch { _ in
                    self.semaphore.signal()
            }
            self.semaphore.wait()
        }
    }

    func handle(request: UBCampaignFeedbackRequest) {
        campaignDAO.create(request)
        if reachability.isReachable {
            trySendData()
        }
    }
}
