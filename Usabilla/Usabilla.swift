//
//  Usabilla.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 25/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//
import UIKit

open class Usabilla {

    open static var customVariables: [String: Any] {
        get {
            return UsabillaInternal.customVariables
        }
        set {
            if !JSONSerialization.isValidJSONObject(newValue) {
                print("UBError: attempting to set invalid custom variables object. For more on how to use custom variables, visit https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#other-configuration")
                return
            }
            UsabillaInternal.customVariables = newValue
        }
    }

    open static var localizedStringFile: String {
        get {
            return UsabillaInternal.localizedStringFile
        }
        set {
            UsabillaInternal.localizedStringFile = newValue
        }
    }

    open static var theme: UsabillaTheme {
        get {
            return UsabillaInternal.theme
        }
        set {
            UsabillaInternal.theme = newValue
        }
    }

    open static var delegate: UsabillaDelegate? {
        get {
            return UsabillaInternal.delegate
        }
        set {
            UsabillaInternal.delegate = newValue
        }
    }

    open static var dismissAutomatically: Bool {
        get {
            return UsabillaInternal.dismissAutomatically
        }
        set {
            UsabillaInternal.dismissAutomatically = newValue
        }
    }

    open static var canDisplayCampaigns: Bool {
        get {
            return UsabillaInternal.canDisplayCampaigns
        }
        set {
            UsabillaInternal.canDisplayCampaigns = newValue
        }
    }

    /**
     A Boolean value that determines whether the SDK should display logs.
     */
    open static var debugEnabled: Bool {
        get {
            return UsabillaInternal.debugEnabled
        }
        set {
            UsabillaInternal.debugEnabled = newValue
        }
    }

    open class func sendEvent(event: String) {
        UsabillaInternal.sendEvent(event: event)
    }

    /**
     Initialize the **Usabilla SDK**
     
     This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.
     
     The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
     It also allows to fetch the campaigns associated to the **appID**.
     
     - parameter appID: The app identifier (eg: **0D5424BE-41AD-4434-A081-32C393A998A3**)
     */
    open class func initialize(appID: String?, completion: (() -> Void)? = nil) {
        UsabillaInternal.initialize(appID: appID) {
            completion?()
        }
    }

    open class func removeCachedForms() {
        UsabillaInternal.removeCachedForms()
    }

    open class func resetCampaignData(completion: (() -> Void)?) {
        UsabillaInternal.resetCampaignData(completion: completion)
    }

    /**
     Preloads a list of forms to make them available to the user even without network connectivity.
     */
    open class func preloadFeedbackForms(withFormIDs formIDs: [String]) {
        UsabillaInternal.preloadFeedbackForms(withFormIDs: formIDs)
    }

    open class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
        UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        return UsabillaInternal.takeScreenshot(view)
    }
}

public struct FeedbackResult {
    public let rating: Int?
    public let abandonedPageIndex: Int?
    public var sent: Bool {
        return abandonedPageIndex == nil
    }
}

public struct UBError: Error {
    public let description: String
}

public protocol UsabillaDelegate: class {

    /**
     This method is called once a passive feedback form is correctly loaded

     - Parameter form: The view controller containing the form
     */
    func formDidLoad(form: UINavigationController)

    /**
     This method is called if the SDK encountered an error while loading the passive feedback form

     - Parameter error: An error describing the issue encoutered
     */
    func formDidFailLoading(error: UBError)

    /**
     This method is called once the form is closed
     
     - Parameter formID: String representing the ID of the form
     - Parameter withFeedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store
     
     withFeedbackResults can contain between 1 and n FeedbackResult
     */
    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**
     
     This method is called before the form is closed
     
     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form
     - Parameter withFeedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store
     
     This method should be used to dismiss the form if the Usabilla.**dismissAutomatically** attribute is set to **false**
     */
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**
     
     This method is called once a campaign form is closed

     - Parameter withFeedbackResult: FeedbackResult containing the campaign data submitted by the user
     - Parameter isRedirectToAppStoreEnabled: Bool indicating whether or not the form is set to redirect to the App Store
     
     */
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool)
}

public extension UsabillaDelegate {
    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) { }
}
