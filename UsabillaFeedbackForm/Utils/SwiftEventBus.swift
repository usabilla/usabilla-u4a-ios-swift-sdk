//All credits to
// https://github.com/cesarferreira/SwiftEventBus
//For some reason cocoapods would not let me use it.

import Foundation

 class SwiftEventBus {

    struct Static {
        static let instance = SwiftEventBus()
        static let queue = dispatch_queue_create("com.cesarferreira.SwiftEventBus", DISPATCH_QUEUE_SERIAL)
    }

    struct NamedObserver {
        let observer: NSObjectProtocol
        let name: String
    }

    var cache = [UInt:[NamedObserver]]()


    ////////////////////////////////////
    // Publish
    ////////////////////////////////////

     class func post(name: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
    }

     class func post(name: String, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender)
    }

     class func post(name: String, sender: NSObject?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender)
    }

     class func post(name: String, userInfo: [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: userInfo)
    }

     class func post(name: String, sender: AnyObject?, userInfo: [NSObject : AnyObject]?) {
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender, userInfo: userInfo)
    }

     class func postToMainThread(name: String) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil)
        }
    }

     class func postToMainThread(name: String, sender: AnyObject?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender)
        }
    }

     class func postToMainThread(name: String, sender: NSObject?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender)
        }
    }

     class func postToMainThread(name: String, userInfo: [NSObject : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: nil, userInfo: userInfo)
        }
    }

     class func postToMainThread(name: String, sender: AnyObject?, userInfo: [NSObject : AnyObject]?) {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(name, object: sender, userInfo: userInfo)
        }
    }



    ////////////////////////////////////
    // Subscribe
    ////////////////////////////////////

     class func on(target: AnyObject, name: String, sender: AnyObject?, queue: NSOperationQueue?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        let id = ObjectIdentifier(target).uintValue
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: sender, queue: queue, usingBlock: handler)
        let namedObserver = NamedObserver(observer: observer, name: name)

        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers + [namedObserver]
            } else {
                Static.instance.cache[id] = [namedObserver]
            }
        }

        return observer
    }

     class func onMainThread(target: AnyObject, name: String, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: NSOperationQueue.mainQueue(), handler: handler)
    }

     class func onMainThread(target: AnyObject, name: String, sender: AnyObject?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: NSOperationQueue.mainQueue(), handler: handler)
    }

     class func onBackgroundThread(target: AnyObject, name: String, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: nil, queue: NSOperationQueue(), handler: handler)
    }

     class func onBackgroundThread(target: AnyObject, name: String, sender: AnyObject?, handler: ((NSNotification!) -> Void)) -> NSObjectProtocol {
        return SwiftEventBus.on(target, name: name, sender: sender, queue: NSOperationQueue(), handler: handler)
    }

    ////////////////////////////////////
    // Unregister
    ////////////////////////////////////

     class func unregister(target: AnyObject) {
        let id = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()

        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache.removeValueForKey(id) {
                for namedObserver in namedObservers {
                    center.removeObserver(namedObserver.observer)
                }
            }
        }
    }

     class func unregister(target: AnyObject, name: String) {
        let id = ObjectIdentifier(target).uintValue
        let center = NSNotificationCenter.defaultCenter()

        dispatch_sync(Static.queue) {
            if let namedObservers = Static.instance.cache[id] {
                Static.instance.cache[id] = namedObservers.filter({ (namedObserver: NamedObserver) -> Bool in
                    if namedObserver.name == name {
                        center.removeObserver(namedObserver.observer)
                        return false
                    } else {
                        return true
                    }
                })
            }
        }
    }

}
