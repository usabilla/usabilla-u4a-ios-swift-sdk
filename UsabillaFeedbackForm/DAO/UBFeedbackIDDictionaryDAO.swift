//
//  UBFeedbackIDDictionaryDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class UBFeedbackIDDictionaryDAO: UBFileStorageDAO<NSMutableDictionary> {
    static let directoryName = "UBFeedbackIDDictionaryDAO"
    static let shared = UBFeedbackIDDictionaryDAO()
    static let dictionaryID = "id"

    required init() {
        super.init(directoryName: UBFeedbackIDDictionaryDAO.directoryName)
    }

    override func id(forObj: NSMutableDictionary) -> String {
        return UBFeedbackIDDictionaryDAO.dictionaryID
    }
}
