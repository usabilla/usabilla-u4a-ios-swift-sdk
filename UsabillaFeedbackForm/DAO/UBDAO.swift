//
//  UBDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBDAO {
    associatedtype DataType
    @discardableResult func create(_ obj: DataType) -> Bool
    func readAll() -> [DataType]
    func read(id: String) -> DataType?
    func delete(_ obj: DataType) -> Bool
    func deleteAll() -> Bool
}
