//
//  UBFeedbackRequestDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFeedbackRequestDAO: UBFileStorageDAO<UBFeedbackRequest> {
    static let directoryName = "FeedbackRequests"
    static let shared = UBFeedbackRequestDAO()

    internal required init() {
        super.init(directoryName: UBFeedbackRequestDAO.directoryName)
    }

    override func id(forObj: UBFeedbackRequest) -> String {
        return forObj.id
    }
}
