//
//  ShowHideRule.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class ShowHideRule: Rule {

    let showIfRuleIsSatisfied: Bool

    init(dependsOnID: String, targetValues: [String], pageModel: PageModel, show: Bool) {
        showIfRuleIsSatisfied = show
        super.init(dependsOnID: dependsOnID, targetValues: targetValues, pageModel: pageModel)
    }

}
