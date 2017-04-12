//
//  SequenceRule.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 16/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class SequenceRule: ConcreteRule {

    init(childRules: [Rule], ruleID: String = UUID().uuidString, alreadyTriggered: Bool = false) {
        super.init(type: .sequence, childRules: childRules, ruleID: ruleID, alreadyTriggered: alreadyTriggered)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func customTriggersWith(event: Event) -> Bool {
        //TO DO reset if strict
        let indexOfFirstNotTriggered = childRules.index(where: { $0.alreadyTriggered == false })

        if let index = indexOfFirstNotTriggered {
            if childRules[index].triggersWith(event: event) && index == self.childRules.count - 1 {
                return true
            }
        }
        return false

    }
}