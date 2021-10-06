//
//  UsabillaCS.swift
//  UsabillaCS
//
//  Created by Hitesh Jain on 05/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import UIKit
@objc(Usabilla)
open class UsabillaCS: NSObject {
    public static var customVariables: [String: String] {
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

    public static var defaultDataMasks: [String] {
        return UsabillaInternal.defaultDataMasks
    }

    public static var orientation: UIInterfaceOrientationMask {
        get {
            return UsabillaInternal.supportedOrientations
        }
        set {
            UsabillaInternal.supportedOrientations = newValue
        }
    }

    public static var localizedStringFile: String {
        get {
            return UsabillaInternal.localizedStringFile
        }
        set {
            UsabillaInternal.localizedStringFile = newValue
        }
    }

    public static var theme: UsabillaTheme {
        get {
            return UsabillaInternal.theme
        }
        set {
            UsabillaInternal.theme = newValue
        }
    }
    @objc
    public static var delegate: UsabillaDelegate? {
        get {
            return UsabillaInternal.delegate
        }
        set {
            UsabillaInternal.delegate = newValue
        }
    }

    public static var dismissAutomatically: Bool {
        get {
            return UsabillaInternal.dismissAutomatically
        }
        set {
            UsabillaInternal.dismissAutomatically = newValue
        }
    }

    public static var canDisplayCampaigns: Bool {
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
    @objc
    public static var debugEnabled: Bool {
        get {
            return UsabillaInternal.debugEnabled
        }
        set {
            UsabillaInternal.debugEnabled = newValue
        }
    }

    /**
     A Boolean value that determines whether the SDK should send telemetry data.
     */
    public static var submitTelemetryData: Bool {
        get {
            return UsabillaInternal.submitTelemetryData
        }
        set {
            UsabillaInternal.submitTelemetryData = newValue
        }
    }
  /**
     A Boolean value that determines whether the SDK powered by logo clickable.
     */
    @objc
    public static var setFooterLogoClickable: Bool {
        get {
            return UsabillaInternal.setFooterLogoClickable
        }
        set {
            UsabillaInternal.setFooterLogoClickable = newValue
        }
    }
    @objc
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
    @objc
    open class func initialize(appID: String?, completion: (() -> Void)? = nil) {
        UsabillaInternal.initialize(appID: appID) {
            completion?()
        }
    }

    /**
     If it's needed to dismiss a campaign this method will dismiss the current presented campaign.
     - Returns: true if there is a campaign and it's closed, false if there is no presented campaign
     */
    open class func dismiss() -> Bool {
        return UsabillaInternal.dismiss()
    }

    open class func removeCachedForms() {
        UsabillaInternal.removeCachedForms()
    }
    @objc
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
    @objc
    open class func showFeedbackForm(_ formID: String) {
        UsabillaInternal.showFeedbackForm(formID)
    }

    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        return UsabillaInternal.takeScreenshot(view)
    }

    open class func setDataMasking(masks: [String] = defaultDataMasks,
                                   maskCharacter: Character = "X") {
        UsabillaInternal.setDataMasking(
            masks: masks,
            maskCharacter: maskCharacter)
    }
}
@objc(FeedbackResult)
public class FeedbackResult: NSObject {
    public let rating: Int?

    public let abandonedPageIndex: Int?
    @objc
    public var sent: Bool {
        return abandonedPageIndex == nil
    }

    public init(rating: Int?, abandonedPageIndex: Int?) {
        if let aRating = rating {
            self.rating = aRating
        } else {
            self.rating = 0
        }
        if let aAbandonedPageIndex = abandonedPageIndex {
            self.abandonedPageIndex = aAbandonedPageIndex
        } else  { self.abandonedPageIndex = 0 }
    }
}

@objc(UBError)
public class UBError: NSObject {
    @objc public var errorDescription: NSString?
    public init(description: String?) {
      if let errorDesc = description {
            self.errorDescription = "\(errorDesc)" as NSString
        }
    }
}
@objc
public protocol UsabillaDelegate: class {
    /**
     This method is called once a passive feedback form is correctly loaded
     
     - Parameter form: The view controller containing the form
     */
    @objc
    func formDidLoad(form: UINavigationController)

    /**
     This method is called if the SDK encountered an error while loading the passive feedback form
     
     - Parameter error: An error describing the issue encoutered
     */
    func formDidFailLoading(error: Any)

    /**
     This method is called once the form is closed
     
     - Parameter formID: String representing the ID of the form
     - Parameter withFeedbackResults: Array of FeedbackResult
     - Parameter isRedirectToAppStoreEnabled: Indicates whether or not the form is set to redirect to the App Store
     
     withFeedbackResults can contain between 1 and n FeedbackResult
     */
    @objc
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
    @objc
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool)
    /**
     
     This method is called once a campaign or feedback Form is being submittted
     
     - Parameter userResponse: Dictionary<String, Any> containing the answers submitted by the user
     
     */
    func feedbackResultSubmitted(userResponse: Data)
}

public extension UsabillaDelegate {
    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) { }
    func feedbackResultSubmitted(userResponse: Data) {}
}
