//
//  UsabillaXamarin.swift
//  Usabilla
//
//  Created by Hitesh Jain on 05/02/2020.
//  Copyright © 2020 Usabilla. All rights reserved.
//

import UIKit
@objc(Usabilla)
open class UsabillaXamarin: NSObject {
    @objc
    public static var customVariables: [String: Any] {
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
    @objc
    public static var defaultDataMasks: [String] {
        return UsabillaInternal.defaultDataMasks
    }
    @objc
    public static var orientation: UIInterfaceOrientationMask {
        get {
            return UsabillaInternal.supportedOrientations
        }
        set {
            UsabillaInternal.supportedOrientations = newValue
        }
    }
    @objc
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
    @objc
    public static var dismissAutomatically: Bool {
        get {
            return UsabillaInternal.dismissAutomatically
        }
        set {
            UsabillaInternal.dismissAutomatically = newValue
        }
    }
    @objc
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
    public class func sendEvent(_ eventName: String) {
        UsabillaInternal.sendEvent(event: eventName)
    }
    @objc
    public class func sendEvent( event: String) {
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
    public class func initialize(appID: String?, completion: (() -> Void)? = nil) {

        UsabillaInternal.initialize(appID: appID) {
            completion?()
        }
    }
    /**
     If it's needed to dismiss a campaign this method will dismiss the current presented campaign.
     - Returns: true if there is a campaign and it's closed, false if there is no presented campaign
     */
    @objc
    open class func dismiss() -> Bool {
        return UsabillaInternal.dismiss()
    }
    @objc
    public class func removeCachedForms() {
        UsabillaInternal.removeCachedForms()
    }
    @objc
    public class func resetCampaignData(completion: (() -> Void)?) {
        UsabillaInternal.resetCampaignData(completion: completion)
    }
    @objc
    public class func resetCampaignData() {
        UsabillaInternal.resetCampaignData(completion: nil)
    }

    /**
     Preloads a list of forms to make them available to the user even without network connectivity.
     */
    @objc
    public class func preloadFeedbackForms(withFormIDs formIDs: [String]) {
        UsabillaInternal.preloadFeedbackForms(withFormIDs: formIDs)
    }

    @objc
    public class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil) {
            UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    public class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
            UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    @objc
    public class func takeScreenshot(_ view: UIView) -> UIImage? {
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
    @objc public var rating: NSString?
    @objc public var abandonedPageIndex: NSString?
    @objc
    public var sent: Bool {
        return abandonedPageIndex == nil
    }

    public init(rating: Int?, abandonedPageIndex: Int?) {
        if let aRating = rating {
            self.rating = "\(aRating)" as NSString
        }
        if let aAbandonedPageIndex = abandonedPageIndex {
            self.abandonedPageIndex = "\(aAbandonedPageIndex)" as NSString
        }
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
@objc(UsabillaDelegate)
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

    @objc
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
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [Any], isRedirectToAppStoreEnabled: Bool)
    /**
     
     This method is called once a campaign form is closed
     
     - Parameter withFeedbackResult: FeedbackResult containing the campaign data submitted by the user
     - Parameter isRedirectToAppStoreEnabled: Bool indicating whether or not the form is set to redirect to the App Store
     
     */
    func campaignDidClose(withFeedbackResult result: Any, isRedirectToAppStoreEnabled: Bool)
}

public extension UsabillaDelegate {
    func formDidClose(formID: String, withFeedbackResults results: [String], isRedirectToAppStoreEnabled: Bool) {}
    func formDidClose(formID: String, withFeedbackResults results: [Any], isRedirectToAppStoreEnabled: Bool) {
    }
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func campaignDidClose(withFeedbackResult result: Any, isRedirectToAppStoreEnabled: Bool) {
    }
}
