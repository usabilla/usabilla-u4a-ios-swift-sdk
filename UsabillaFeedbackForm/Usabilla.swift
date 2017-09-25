//
//  Usabilla.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 25/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

open class Usabilla {

    open static weak var delegate: UsabillaFeedbackFormDelegate?
    open static var hideGiveMoreFeedback: Bool = true
    open static var dismissAutomatically: Bool = true
    open static var theme: UsabillaTheme = UsabillaTheme()
    open static var canDisplayCampaigns: Bool = true
    open static var customVariables: [String: Any] {
        get {
            return UsabillaFeedbackForm.customVariables
        }
        set {
            if !JSONSerialization.isValidJSONObject(newValue) {
                print("UBError: attempting to set invalid custom variables object. For more on how to use custom variables, visit https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#other-configuration")
                return
            }
            UsabillaFeedbackForm.customVariables = newValue
        }
    }

    static var defaultLocalisationFile = true

    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }

    open class func sendEvent(event: String) {
        UsabillaFeedbackForm.sendEvent(event: event)
    }

    open class func setCustomVariable(value: Any?, forKey key: String) {
        UsabillaFeedbackForm.setCustomVariable(value: value, forKey: key)
    }

    /**
     Initialize the **Usabilla SDK**

     This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.

     The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
     It also allows to fetch the campaigns associated to the **appID**.

     - parameter appID: The app identifier (eg: **0D5424BE-41AD-4434-A081-32C393A998A3**)
     */
    open class func initialize(appID: String?) {
        UsabillaFeedbackForm.initialize(appID: appID)
    }

    open class func removeCachedForms() {
        UsabillaFeedbackForm.removeCachedForms()
    }

    open class func resetCampaignData(completion: (() -> Void)?) {
        UsabillaFeedbackForm.resetCampaignData(completion: completion)
    }

    open class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
       UsabillaFeedbackForm.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        return UsabillaFeedbackForm.takeScreenshot(view)
    }
}

public struct FeedbackResult {
    public let rating: Int?
    public let abandonedPageIndex: Int?
    public var sent: Bool {
        return abandonedPageIndex == nil
    }
}

public protocol UsabillaFeedbackFormDelegate: class {

    func formLoadedCorrectly(_ form: UINavigationController)
    func formFailedLoading()

    /**
     This method is called once the form is closed

     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form
     - Parameter feedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store

     If UsabillaFeedbackForm.**hideGiveMoreFeedback** is set to **false**, the **feedbackResults** array will always contains only one value.
     Otherwise the feedbackResults can contains between 1 and n FeedbackResult
     */
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**

     This method is called before the form is closed

     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form
     - Parameter feedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store

     This method should be used to dismiss the form if the UsabillaFeedbackForm.**dismissAutomatically** attribute is set to **false**
     */
    func formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)

    /**

     This method is called once a campaign form is closed

     - Parameter campaign: UIViewController which is being dismissed
     - Parameter feedbackResult: FeedbackResult containing the campaign data submitted by the user
     - Parameter isRedirectToAppStoreEnabled: Bool indicating whether or not the form is set to redirect to the App Store

     */
    func campaignDidClose(_ campaign: UIViewController, with feedbackResult: FeedbackResult, isRedirectToAppStoreEnabled: Bool)
}

public extension UsabillaFeedbackFormDelegate {
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    }
    func formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    }
    func campaignDidClose(_ campaign: UIViewController, with feedbackResult: FeedbackResult, isRedirectToAppStoreEnabled: Bool) { }
}
