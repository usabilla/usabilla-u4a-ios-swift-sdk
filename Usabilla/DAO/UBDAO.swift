//
//  UBDAO.swift
//  Usabilla
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
    @discardableResult func delete(_ obj: DataType) -> Bool
    @discardableResult func deleteAll() -> Bool
}
