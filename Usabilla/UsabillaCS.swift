//
//  UsabillaCS.swift
//  UsabillaCS
//
//  Created by Hitesh Jain on 05/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import UIKit
//import Usabilla
@objc(Usabilla)
open class UsabillaCS: NSObject {
    @objc
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
     A Boolean value that determines whether the SDK should send telemetry data.
     */
    @objc
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
//    Used in Xamarin as the above gets translated into
//    sendEventWithEven in the objective-c generated file
    @objc
    public class func sendEvent(_ eventName: String) {
        UsabillaInternal.sendEvent(event: eventName)
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
    @objc
    open class func dismiss() -> Bool {
        return UsabillaInternal.dismiss()
    }
    @objc
    open class func removeCachedForms() {
        UsabillaInternal.removeCachedForms()
    }
    @objc
    public class func resetCampaignData() {
        UsabillaInternal.resetCampaignData(completion: nil)
    }

    /**
     Preloads a list of forms to make them available to the user even without network connectivity.
     */
    @objc
    open class func preloadFeedbackForms(withFormIDs formIDs: [String]) {
        UsabillaInternal.preloadFeedbackForms(withFormIDs: formIDs)
    }

    @objc
    public class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil) {
            UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }

    open class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
        UsabillaInternal.loadFeedbackForm(formID, screenshot: screenshot, theme: theme)
    }
    @objc
    open class func showFeedbackForm(_ formID: String) {
        UsabillaInternal.showFeedbackForm(formID)
    }
    @objc
    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        return UsabillaInternal.takeScreenshot(view)
    }

    @objc
    open class func setDataMasking(masks: [String] = defaultDataMasks,
                                   maskCharacter: String = "X") {
        
        guard let aChar: Character = maskCharacter.first else {return}
        UsabillaInternal.setDataMasking(
            masks: masks,
            maskCharacter: aChar)
    }
    @objc
    open class func setThemWithJson(_ jsonString: String) {
        UIFont.loadAllFonts();
        DLogInfo("JSON: \(jsonString)")
        if let dataFromJsonString = jsonString.data(using: .utf8) {
            do {
                let themeData = try JSONDecoder().decode(Theme.self, from: dataFromJsonString)
                UsabillaInternal.theme =  themeData.getTheme()
                UsabillaInternal.bannerConfiguration = themeData.getBannerConfiguration()
                return
            } catch {
                DLogInfo(error.localizedDescription)
            }
        }
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
    @objc
    func feedbackResultSubmitted(userResponse: Data)
}

public extension UsabillaDelegate {
    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) { }
    func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) { }
    func feedbackResultSubmitted(userResponse: Data) {}
}
private struct Theme: Codable {
    var headerColor: String
    var fonts: Fonts
    var images: Images
    var banner: Banner?
    
    func getTheme() -> UsabillaTheme {
        var newTheme = UsabillaTheme()
        
        if !fonts.regular.isEmpty && fonts.textSize > 0  {
            let afont =  UIFont(name: fonts.regular, size: CGFloat(fonts.textSize) ?? 0 )
            newTheme.fonts.regular = afont
        }
        if !fonts.bold.isEmpty && fonts.titleSize > 0  {
            let afont =  UIFont(name: fonts.bold, size: CGFloat(fonts.titleSize) ?? 0)
            newTheme.fonts.bold = afont
        }

        if let data = imagesToArray(images.enabledEmoticons) {
            newTheme.images.enabledEmoticons = data
        }

        if let data = imagesToArray(images.disabledEmoticons) {
            newTheme.images.disabledEmoticons = data
        }

        if let starImage = UIImage.getImageFromUnit(name: images.star) {
            newTheme.images.star = starImage
        }

        if let starImageOutLine = UIImage.getImageFromUnit(name: images.starOutline) {
            newTheme.images.starOutline = starImageOutLine
        }

        if !headerColor.isEmpty {
            newTheme.colors.header = UIColor(rgba: headerColor)
        }
        return newTheme
    }
    
    func getBannerConfiguration() -> BannerConfiguration? {
        
        guard let banner = banner else {return nil}
        var bannerConfig = BannerConfiguration()
        bannerConfig.buttonStyle = .gfpButtonVertical
        bannerConfig.bannerType = .gfpBackgroundImageAndLogo
        bannerConfig.titleAlignment = .center
        bannerConfig.componentTextAlignment = .center

        if banner.logo.assetName.isEmpty &&
            banner.contourBgAssetName.isEmpty &&
            banner.navigation.cancelButtonBgAssetName.isEmpty &&
            banner.navigation.cancelButtonTextColor.isEmpty &&
            banner.navigation.continueButtonBgAssetName.isEmpty &&
            banner.navigation.continueButtonTextColor.isEmpty {return nil}
        
        // logo image
        if !banner.logo.assetName.isEmpty {
            if let unityImage = UIImage.getImageFromUnit(name: banner.logo.assetName) {
                bannerConfig.logoImage = unityImage
            } else if let aImage = UIImage(named: banner.logo.assetName) {
                bannerConfig.logoImage = aImage
            }
        }
        // background image
        if !banner.contourBgAssetName.isEmpty {
            if let unityImage = UIImage.getImageFromUnit(name: banner.contourBgAssetName) {
                bannerConfig.backgroundImage = unityImage
            } else if let aImage = UIImage(named: banner.contourBgAssetName) {
                bannerConfig.backgroundImage = aImage
            }
        }

        // continue buttom image
        if !banner.navigation.continueButtonBgAssetName.isEmpty {
            if let unityImage = UIImage.getImageFromUnit(name: banner.navigation.continueButtonBgAssetName) {
                bannerConfig.continueButtonImage = unityImage
            } else if let aImage = UIImage(named: banner.navigation.continueButtonBgAssetName) {
                bannerConfig.continueButtonImage  = aImage
            }
        }
        if !banner.navigation.continueButtonTextColor.isEmpty {
            bannerConfig.continueButtonTitleColor = UIColor(rgba: banner.navigation.continueButtonTextColor)
        }
        
        // continue buttom image
        if !banner.navigation.cancelButtonBgAssetName.isEmpty {
            if let unityImage = UIImage.getImageFromUnit(name: banner.navigation.cancelButtonBgAssetName) {
                bannerConfig.cancelButtonImage = unityImage
            } else if let aImage = UIImage(named: banner.navigation.cancelButtonBgAssetName) {
                bannerConfig.cancelButtonImage  = aImage
            }
        }
        if !banner.navigation.cancelButtonTextColor.isEmpty {
            bannerConfig.cancelButtonTitleColor = UIColor(rgba: banner.navigation.cancelButtonTextColor)
        }
        return bannerConfig
    }
    
    private func imagesToArray(_ imageData: [String]) -> [UIImage]? {
        var imageArray: [UIImage] = []
        imageData.forEach {
            if let newImage = UIImage.getImageFromUnit(name: $0) {
                imageArray.append(newImage)
            }
        }
        if imageArray.count > 0 {
            return imageArray
        }
        return nil
    }
}

private struct Fonts: Codable {
    var regular: String
    var bold: String
    var titleSize: Int
    var textSize: Int
    var miniSize: Int
}

private struct Images: Codable {
    var enabledEmoticons: [String]
    var disabledEmoticons: [String]
    var star: String
    var starOutline: String
}

private struct Banner: Codable {
    var enableClickThrough: Bool
    var contourBgAssetName: String

    var logo: BannerLogo
    var navigation: BannerNavigation
}


public struct BannerLogo: Codable {
    var assetName: String
}


public struct BannerNavigation: Codable {
    var continueButtonBgAssetName: String
    var continueButtonTextColor: String
    var cancelButtonBgAssetName: String
    var cancelButtonTextColor: String
}

