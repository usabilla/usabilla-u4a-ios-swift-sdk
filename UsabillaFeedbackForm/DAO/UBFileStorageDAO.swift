//
//  UBFileStorageDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFileStorageDAO<ModelType: NSCoding>: UBDAO {
    typealias DataType = ModelType

    var directoryName: String

    init(directoryName: String) {
        self.directoryName = directoryName
    }

    func create(_ obj: DataType) {
        print(String(describing: type(of: self)))
    }

    func readAll() -> [DataType] {
        return []
    }

    func read(id: String) -> DataType? {
        return nil
    }

    func update(_ obj: DataType) {

    }

    func delete(_ obj: DataType) {

    }

    func deleteAll() {

    }
}
