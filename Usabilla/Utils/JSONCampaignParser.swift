//
//  JSONCampaignParser.swift
//  Usabilla
//
//  Created by Hitesh Jain on 02/12/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class JSONCampaignParser {
    // This class method returns reset duration for reactivation
    class func calculateReactivationDuration(reactivation: JSON) -> Int64 {
        var resetDur: Int64 = 0
        if reactivation != nil {
            let interval = reactivation["interval"].int64 ?? 0
            var unit: Int64 = 0
            switch reactivation["unit"].string {
            case "days":
                unit = 86400 // day to seconds 1 * 86400
            case "weeks":
                unit = 604800 // weeks to seconds 7 * 86400
            case "months":
                unit = 2592000 // months to seconds 30 * 86400
            case "years":
                unit = 31536000 // year to seconds 365 * 86400
            default:
                unit = 86400
            }
            resetDur = interval * unit
        }
        return resetDur
    }
}
