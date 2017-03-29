//
//  Engine.swift
//  EventEngine
//
//  Created by Giacomo Pinato on 15/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import Foundation

class Engine {

    static var campaingsArray: [Campaign]?

    static func eventReceived(_ event: Event) {


        Swift.debugPrint("received event \(event.toString()) in engine")

        var triggeredForms: [String] = []

        if let campaigns = campaingsArray {
            for campaign in campaigns {
                let triggered = campaign.triggers(event: event)
                if triggered {
                    triggeredForms.append(campaign.formId)
                    print("triggered \(triggeredForms)")
                }
            }
        }
        saveToDatabase()
    }

    static func saveToDatabase() {
        print(campaingsArray![0])


        let data = NSKeyedArchiver.archivedData(withRootObject: campaingsArray!)
        UserDefaults.standard.setValue(data, forKey: "usabillaRulesDatabase")

        if let data = UserDefaults.standard.object(forKey: "usabillaRulesDatabase") as? Data {
            let books = NSKeyedUnarchiver.unarchiveObject(with: data)
            if let asd = books as? [Campaign] {
                print(asd)
                campaingsArray = asd
            }
        }

    }
}
