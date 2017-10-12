//
//  UBFeedbackIDDictionaryDAO.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 19/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFeedbackIDDictionaryDAO: UBFileStorageDAO<NSMutableDictionary> {
    static let directory = FileDirectory.feedbackIds
    static let shared = UBFeedbackIDDictionaryDAO()
    static let dictionaryID = "id"

    required init() {
        super.init(directory: UBFeedbackIDDictionaryDAO.directory)
    }

    override func id(forObj: NSMutableDictionary) -> String {
        return UBFeedbackIDDictionaryDAO.dictionaryID
    }
}
