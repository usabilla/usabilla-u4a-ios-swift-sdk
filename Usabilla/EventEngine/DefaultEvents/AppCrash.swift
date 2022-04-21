//
//  AppCrash.swift
//  Usabilla
//
//  Created by Hitesh Jain on 11/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

// MARK: - GLOBAL VARIABLE
private var appOldExceptionHandler:(@convention(c) (NSException) -> Swift.Void)?

// MARK: - AppCrashDelegate
protocol AppCrashDelegate: NSObjectProtocol {
   func appCrashDidCatchCrash(with model: AppCrashModel)
}

// MARK: - WeakAppCrashDelegate
class AppCrashWeakDelegate: NSObject {
    weak var delegate: AppCrashDelegate?

    init(delegate: AppCrashDelegate) {
        super.init()
        self.delegate = delegate
    }
}

// MARK: - AppCrashModelType
enum AppCrashModelType: Int {
   case signal = 1
   case exception = 2
}

// MARK: - AppCrashModel
 class AppCrashModel: NSObject {
     var type: AppCrashModelType
     var name: String
     var reason: String
     var appinfo: String
     var callStack: String

     init(type: AppCrashModelType,
          name: String,
          reason: String,
          appinfo: String,
          callStack: String) {
         self.type = type
         self.name = name
         self.reason = reason
         self.appinfo = appinfo
         self.callStack = callStack
         super.init()
     }
}

// MARK: - AppCrash
 class AppCrash: NSObject {
     private(set) static var isOpen: Bool = false
     fileprivate static var delegates = [AppCrashWeakDelegate]()

     class func add(delegate: AppCrashDelegate) {
        // delete null week delegate
        self.delegates = self.delegates.filter {
            return $0.delegate != nil
        }

        // judge if contains the delegate from parameter
        let contains = self.delegates.contains {
            return $0.delegate?.hash == delegate.hash
        }
        // if not contains, append it with weak wrapped
        if contains == false {
            let week = AppCrashWeakDelegate(delegate: delegate)
            self.delegates.append(week)
        }

        if self.delegates.count > 0 {
            self.open()
        }
    }

     class func remove(delegate: AppCrashDelegate) {
        self.delegates = self.delegates.filter {
            // filter null weak delegate
            return $0.delegate != nil
            }.filter {
                // filter the delegate from parameter
                return $0.delegate?.hash != delegate.hash
        }

        if self.delegates.count == 0 {
            self.close()
        }
    }

     private class func open() {
         guard self.isOpen == false else {
             return
         }
         AppCrash.isOpen = true

         appOldExceptionHandler = NSGetUncaughtExceptionHandler()
         NSSetUncaughtExceptionHandler(AppCrash.RecieveException)
         self.setCrashSignalHandler()
     }

     private class func close() {
         guard self.isOpen == true else {
             return
         }
         AppCrash.isOpen = false
         NSSetUncaughtExceptionHandler(appOldExceptionHandler)
     }

     private class func setCrashSignalHandler() {
         signal(SIGABRT, AppCrash.RecieveSignal)
         signal(SIGILL, AppCrash.RecieveSignal)
         signal(SIGSEGV, AppCrash.RecieveSignal)
         signal(SIGFPE, AppCrash.RecieveSignal)
         signal(SIGBUS, AppCrash.RecieveSignal)
         signal(SIGPIPE, AppCrash.RecieveSignal)
         signal(SIGTRAP, AppCrash.RecieveSignal)
     }

     private static let RecieveException: @convention(c) (NSException) -> Swift.Void = { (exteption) -> Void in
         if appOldExceptionHandler != nil {
             // swiftlint:disable:next force_unwrapping
             appOldExceptionHandler!(exteption)
         }

         guard AppCrash.isOpen == true else {
             return
         }

         let callStack = exteption.callStackSymbols.joined(separator: "\r")
         let reason = exteption.reason ?? ""
         let name = exteption.name
         let appinfo = String(describing: AppMetaData().metadata)

         let model = AppCrashModel(type: AppCrashModelType.exception,
                                name: name.rawValue,
                                reason: reason,
                                appinfo: appinfo,
                                callStack: callStack)
         for delegate in AppCrash.delegates {
             delegate.delegate?.appCrashDidCatchCrash(with: model)
         }
     }
     private static let RecieveSignal : @convention(c) (Int32) -> Void = { (signal) -> Void in
         guard AppCrash.isOpen == true else {
             return
         }
         var stack = Thread.callStackSymbols
         stack.removeFirst(2)
         let callStack = stack.joined(separator: "\r")
         let reason = "Signal \(AppCrash.name(of: signal))(\(signal)) was raised.\n"
         let appinfo = String(describing: AppMetaData().metadata)

         let model = AppCrashModel(type: AppCrashModelType.signal,
                                name: AppCrash.name(of: signal),
                                reason: reason,
                                appinfo: appinfo,
                                callStack: callStack)

         for delegate in AppCrash.delegates {
             delegate.delegate?.appCrashDidCatchCrash(with: model)
         }

         AppCrash.killApp()
     }

     private class func name(of signal: Int32) -> String {
         switch signal {
         case SIGABRT:
             return "SIGABRT"
         case SIGILL:
             return "SIGILL"
         case SIGSEGV:
             return "SIGSEGV"
         case SIGFPE:
             return "SIGFPE"
         case SIGBUS:
             return "SIGBUS"
         case SIGPIPE:
             return "SIGPIPE"
         default:
             return "OTHER"
         }
     }

     private class func killApp() {
         NSSetUncaughtExceptionHandler(nil)
         signal(SIGABRT, SIG_DFL)
         signal(SIGILL, SIG_DFL)
         signal(SIGSEGV, SIG_DFL)
         signal(SIGFPE, SIG_DFL)
         signal(SIGBUS, SIG_DFL)
         signal(SIGPIPE, SIG_DFL)
         kill(getpid(), SIGKILL)
     }
 }
