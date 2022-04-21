//
//  DefaultEvent.swift
//  Usabilla
//
//  Created by Hitesh Jain on 10/03/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

// import Foundation
//
// enum EventType: String {
//    case appCrash
//    case appLaunch
//    case appUpToDate
//    case appOutdated
//    case appCloseEarly
//    case specificDate
// }
//
//// protocol DefaultEventModelProtocol {
////    var type: String { get }
////    var params: [String: Any] { get }
//// //   func getParam<T>(key: String)
//// }
//
// class DefaultEventModel: NSObject, NSCoding {
//    var type: String
//    var params: [String: Any]
//
//    private struct Archiving {
//        static let type = "type"
//        static let params = "params"
//    }
//
//    required init?(json: JSON) {
//        guard let type = json["type"].string, let params = json["params"].rawValue as? [String: Any] else {
//                return nil
//        }
//
//        self.type = type
//        self.params = params
//    }
//
//    // MARK: NSCoding
//    required init?(coder aDecoder: NSCoder) {
//        guard let type = aDecoder.decodeObject(forKey: Archiving.type) as? String else {
//            PLog("❌ impossible to decode type")
//            return nil
//        }
//        guard let params = aDecoder.decodeObject(forKey: Archiving.params) as? [String: Any] else {
//            PLog("❌ impossible to decode params")
//            return nil
//        }
//
//        self.type = type
//        self.params = params
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.type, forKey: Archiving.type)
//        aCoder.encode(self.params, forKey: Archiving.params)
//    }
// }
//
//// protocol DefaultEventProtocol {
////    var eventType: EventType { get }
////    func check() -> [CampaignModel]
////    func activate()
////    func deactivate()
////    func addConfig(campaignModel: CampaignModel) -> [CampaignModel]
//// }
//
// protocol DefaultEventProtocol: class {
//    var events: [DefaultEventListenerProtocol] { get set }
//
//    func addDefaultEvent(_ event: DefaultEventListenerProtocol)
//    func removeDefaultEvent(_ event: DefaultEventListenerProtocol)
//    func notifyDefaultEvents(_ events: [DefaultEventListenerProtocol])
// }
//
// protocol DefaultEventListenerProtocol {
//
//    var eventType: EventType { get set}
//    func check() -> [CampaignModel]
// }
//
// protocol DefaultEventObserver: class {
//    func respondingDefaultEvents(campaigns: [CampaignModel]) -> [CampaignModel]
// }
//
// protocol DefaultEventObservable: class {
//  //  var eventType: EventType { get }
//    var observers: [DefaultEventObserver] { get set }
//    func addObserver(observer: DefaultEventObserver)
//    func removeObsever(observer: DefaultEventObserver)
//    func notifyObservers(campaigns: [CampaignModel])
// }
//
// class DefaultEvent: DefaultEventObservable {
//    private var event  = String()
//       var eventTypeString : String
//       {
//           get
//           {
//               return event
//           }
//           set
//           {
//               event = newValue
//           }
//       }
//    internal var observers : [DefaultEventObserver] = []
//    func addObserver(observer: DefaultEventObserver) {
//        if observers.contains(where: { $0 === observer }) == false {
//            observers.append(observer)
//        }
//    }
//
//    func removeObsever(observer: DefaultEventObserver) {
//        if let index = observers.index(where: { $0 === observer }) {
//            observers.remove(at: index)
//        }
//    }
//
//    func notifyObservers(campaigns: [CampaignModel]) {
//        observers.forEach { (observer) in
//         let validCampaigns = observer.respondingDefaultEvents(campaigns: campaigns)
//            print("validCampaigns - \(validCampaigns)")
//        }
//    }
//
//    deinit {
//        observers.removeAll()
//    }
// }
