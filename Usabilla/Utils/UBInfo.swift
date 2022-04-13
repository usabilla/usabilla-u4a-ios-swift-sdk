//
//  UBInfo.swift
//  Usabilla
//
//  Created by Hitesh Jain on 21/01/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

class UBInfo {
    // get the classname of the class before the UsabillaInternal.
    // It's used to dertermine if the sdk was called from our bridge
     class func getCallingClass() -> String {
        let data = Thread.callStackSymbols
        var className: String {
            switch data {
            case _ where (data.first(where: {$0.contains("GetfeedbackCapacitor")}) != nil) :
                return "Capacitor"
            case _ where (data.first(where: {$0.contains("SwiftFlutterUsabillaPlugin")}) != nil) :
                return "Flutter"
            case _ where (data.first(where: {$0.contains("UsabillaBridge")}) != nil) :
                return "ReactNative"
            case _ where (data.first(where: {$0.contains("UsabillaB0")}) != nil) :
                return "Cordova"
            case _ where (data.first(where: {$0.contains("UsabillaInternal")}) != nil) :
                return "Internal"
            case _ where (data.first(where: {$0.contains("UsabillaXamarin")}) != nil) :
                return "Xamarin"
            case _ where (data.first(where: {$0.contains("UnityFramework")}) != nil) :
                return "Unity"
            default:
                return "Usabilla"
            }
        }
        return className
    }
}
