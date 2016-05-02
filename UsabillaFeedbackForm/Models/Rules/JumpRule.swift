//
//  JumpRule.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class JumpRule: Rule {
    
    let jumpTo: String
    
    init(jumpTo: String, dependsOnID: String, targetValues: [String], pageModel: PageModel) {
        self.jumpTo = jumpTo
        super.init(dependsOnID: dependsOnID, targetValues: targetValues, pageModel: pageModel)
    }

    
}
