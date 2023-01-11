//
//  Array.swift
//  Usabilla
//
//  Created by Hitesh Jain on 11/01/2023.
//  Copyright © 2023 Usabilla. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
