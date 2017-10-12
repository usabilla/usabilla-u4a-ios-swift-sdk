//
//  UBFeedbackRequestDAO.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFeedbackRequestDAO: UBFileStorageDAO<UBFeedbackRequest> {
    static let directory = FileDirectory.passiveFeedbackRequest
    static let shared = UBFeedbackRequestDAO()

    required init() {
        super.init(directory: UBFeedbackRequestDAO.directory)
    }

    override func id(forObj: UBFeedbackRequest) -> String {
        return forObj.id
    }
}
