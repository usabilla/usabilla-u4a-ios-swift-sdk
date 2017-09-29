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

    open static var hideGiveMoreFeedback: Bool {
        get {
            return UsabillaInternal.hideGiveMoreFeedback
        }
        set {
            UsabillaInternal.hideGiveMoreFeedback = newValue
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

    open class func sendEvent(event: String) {
        UsabillaInternal.sendEvent(event: event)
    }

    open class func setCustomVariable(value: Any?, forKey key: String) {
        UsabillaInternal.setCustomVariable(value: value, forKey: key)
    }

    /**
     Initialize the **Usabilla SDK**
     
     This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.
     
     The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
     It also allows to fetch the campaigns associated to the **appID**.
     
     - parameter appID: The app identifier (eg: **0D5424BE-41AD-4434-A081-32C393A998A3**)
     */
    open class func initialize(appID: String?) {
        UsabillaInternal.initialize(appID: appID)
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
    open class func preloadForms(withFormIDs formIDs: [String]) {
        UsabillaInternal.preloadForms(withFormIDs: formIDs)
    }

    open class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
        UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        return UsabillaInternal.takeScreenshot(view)
    }

    #if INTERNAL_USE || DEBUG
        open class func formViewController(forFormJson json: JSON) -> UINavigationController? {
            return UsabillaInternal.formViewController(forFormJson: json)
        }

        open class func displayCampaignForm(withFormID formID: String, theme: UsabillaTheme = theme) {
            UsabillaInternal.displayCampaignForm(withFormID: formID)
        }

        open class func showCampaignForm(formJson: JSON, campaignID: String = "id") {
            UsabillaInternal.showCampaignForm(formJson: formJson, campaignID: campaignID)
        }
    #endif

}

public struct FeedbackResult {
    public let rating: Int?
    public let abandonedPageIndex: Int?
    public var sent: Bool {
        return abandonedPageIndex == nil
    }
}

public struct UBError: Error, LocalizedError {
    let description: String
}

public protocol UsabillaDelegate: class {

    func formDidLoad(form: UINavigationController)
    func formDidFailLoading(error: UBError)

    /**
     This method is called once the form is closed
     
     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form
     - Parameter feedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store
     
     If Usabilla.**hideGiveMoreFeedback** is set to **false**, the **feedbackResults** array will always contains only one value.
     Otherwise the feedbackResults can contains between 1 and n FeedbackResult
     */
    func formDidClose(form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**
     
     This method is called before the form is closed
     
     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form
     - Parameter feedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store
     
     This method should be used to dismiss the form if the Usabilla.**dismissAutomatically** attribute is set to **false**
     */
    func formWillClose(form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**
     
     This method is called once a campaign form is closed
     
     - Parameter campaign: UIViewController which is being dismissed
     - Parameter feedbackResult: FeedbackResult containing the campaign data submitted by the user
     - Parameter isRedirectToAppStoreEnabled: Bool indicating whether or not the form is set to redirect to the App Store
     
     */
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool)
}

public extension UsabillaDelegate {
    func formDidClose(form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    }
    func formWillClose(form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    }
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) { }
}