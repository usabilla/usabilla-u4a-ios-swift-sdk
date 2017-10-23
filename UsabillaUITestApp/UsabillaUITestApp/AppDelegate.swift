//
//  AppDelegate.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable force_try

import UIKit
import Usabilla
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    enum FormType: String {
        case campaignForm
        case passiveForm
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Usabilla.initialize(appID: "8874466A-E523-4F36-9315-EF00E0E2343F")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let environment = ProcessInfo.processInfo.environment
        guard let scenario = environment["scenario"],
            let formTypeString = environment["formType"],
            let type = FormType(rawValue: formTypeString) else {
                loadMain()
                return true
        }

        // swiftlint:disable:next force_unwrapping
        let path = Bundle(for: AppDelegate.self).path(forResource: scenario, ofType: "json")!
        let data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe) as Data

        switch type {
        case .passiveForm:
            self.window?.rootViewController = Usabilla.formViewController(forFormData: data)
            self.window?.makeKeyAndVisible()
        case .campaignForm:
            loadMain()
            Usabilla.displayCampaignForm(withData: data)
        }

        return true
    }

    func loadMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
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
