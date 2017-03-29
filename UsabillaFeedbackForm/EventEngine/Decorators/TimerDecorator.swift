//
//  TimerDecorator.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 20/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

//class TimerDecorator: Decorator {
//
//    let timeWindowInSeconds: Double
//    var beginTimestamp: Date?
//    var resetCounterOnNewEvent: Bool = false
//
//    init(rule: Rule, timeWindowInSeconds: Double, resetCounterOnNewEvent: Bool = true) {
//        self.timeWindowInSeconds = timeWindowInSeconds
//        self.resetCounterOnNewEvent = resetCounterOnNewEvent
//        super.init(rule: rule)
//    }
//
//    override func customTriggersWith(event: Event) -> Bool {
//        if rule.checkIfEventIsTarget(event: event) {
//            //Event belongs to rule targets
//            if let start = beginTimestamp {
//                //Timer already started
//                let secondsPassed = Date().timeIntervalSince(start)
//                if resetCounterOnNewEvent {
//                    //If needed, reset timer
//                    beginTimestamp = Date()
//                }
//                if secondsPassed > timeWindowInSeconds {
//                    //Timer expired
//                    return false
//                }
//
//            } else {
//                beginTimestamp = Date()
//            }
//            return rule.triggersWith(event: event)
//
//        }
//
//        return false
//
//    }
//
//
//    // MARK: NSCoding
//    
//    public required init?(coder aDecoder: NSCoder) {
//        let timeWindowInSeconds = aDecoder.decodeDouble(forKey: "timeWindowInSeconds") as? Double
//        let resetCounterOnNewEvent = aDecoder.decodeBool(forKey: "resetCounterOnNewEvent") as? Bool
//
//        self.timeWindowInSeconds = timeWindowInSeconds!
//        self.resetCounterOnNewEvent = resetCounterOnNewEvent!
//        self.beginTimestamp = nil
//        super.init(coder: aDecoder)
//        
//    }
//    
//    public override func encode(with aCoder: NSCoder) {
//        super.encode(with: aCoder)
//        aCoder.encode(self.timeWindowInSeconds, forKey: "timeWindowInSeconds")
//        aCoder.encode(self.resetCounterOnNewEvent, forKey: "resetCounterOnNewEvent")
//    }
//
//}
