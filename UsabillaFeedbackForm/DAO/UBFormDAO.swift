//
//  UBFormDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFormDAO: UBFileStorageDAO<FormModel> {

    static let shared = UBFormDAO()

    internal required init() {
        super.init(directoryName: "Forms")
    }

    override func id(forObj: FormModel) -> String {
        return forObj.appId
    }
}
