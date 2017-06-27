//
//  AppDelegate.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_try

import UIKit
import UsabillaFeedbackForm
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UsabillaFeedbackForm.load(appId: "")
        UsabillaFeedbackForm.showCancelButton = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        var controller: UIViewController!

        if let scenario = ProcessInfo.processInfo.environment["scenario"] {
            let path = Bundle(for: AppDelegate.self).path(forResource: scenario, ofType: "json")!
            let data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            let json: JSON = JSON(data: data as Data)
            controller = UsabillaFeedbackForm.formViewController(forFormJson: json)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateInitialViewController()
        }

        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
