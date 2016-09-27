//
//  Rule.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class Rule {
    
    let dependsOnID: String
    let targetValues: [String]
    unowned let pageModel: PageModel
    
    init(dependsOnID: String, targetValues: [String], pageModel: PageModel) {
        
            self.pageModel = pageModel
            self.dependsOnID = dependsOnID
            self.targetValues = targetValues
    }
    
    
    func isSatisfied() -> Bool {
        for value in targetValues {
            if let isThere = pageModel.fieldValuesCollection[dependsOnID] {
            
                if isThere.contains(value) {
                    return true
                }
            }
        }
        return false
    }
    
}
