//
//  UBFormDAO.swift
//  Usabilla
//
//  Created by Adil Bougamza on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFormDAO: UBFileStorageDAO<FormModel> {
    static let directory = FileDirectory.form
    static let shared = UBFormDAO()

    internal required init() {
        super.init(directory: UBFormDAO.directory)
    }

    override func id(forObj: FormModel) -> String {
        return forObj.identifier
    }
}
