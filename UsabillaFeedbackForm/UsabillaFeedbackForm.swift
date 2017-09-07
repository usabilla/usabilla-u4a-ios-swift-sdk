//
//  UsabillaFeedbackForm.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 02/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

open class UsabillaFeedbackForm {

    private static var privateCustomVariables: [String: Any] = [:]

    //Various init methods with many parameters\
    open static weak var delegate: UsabillaFeedbackFormDelegate?
    open static var hideGiveMoreFeedback: Bool = true
    open static var dismissAutomatically: Bool = true
    open static var theme: UsabillaTheme = UsabillaTheme()
    open static var canDisplayCampaigns: Bool = true
    open static var customVariables: [String: Any] {
        get {
            return privateCustomVariables
        }
        set {
            if !JSONSerialization.isValidJSONObject(newValue) {
                print("UBError: attempting to set invalid custom variables object. For more on how to use custom variables, visit https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#other-configuration")
                return
            }
            privateCustomVariables = newValue
        }
    }

    static var appID: String?
    static var defaultLocalisationFile = true
    static let campaignService = CampaignService()
    static let campaignStore: UBCampaignStoreProtocol = UBCampaignStore(service: UsabillaFeedbackForm.campaignService)

    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }

    // services
    private static var campaignManager: CampaignManager?
    private static var formService: FormService = FormService()
    private static var formStore: FormStore = FormStore(service: formService)
    private static var submissionManager: SubmissionManager = SubmissionManager(formService: formService)

    open class func sendEvent(event: String) {
        campaignManager?.sendEvent(event: event, customVariables: customVariables)
    }

    open class func setCustomVariable(value: Any?, forKey key: String) {
        customVariables[key] = value
        PLog(customVariables)
    }

    /**
    Initialize the **Usabilla SDK**
     
    This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.
     
    The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
    It also allows to fetch the campaigns associated to the **appID**.
     
    - parameter appID: The app identifier (eg: **0D5424BE-41AD-4434-A081-32C393A998A3**)
    */
    open class func initialize(appID: String) {
        guard NSUUID(uuidString: appID) != nil else {
            Swift.debugPrint("UsabillaFeedbackForm: provided appID has wrong format: expected UUID")
            return
        }
        UsabillaFeedbackForm.appID = appID
        campaignManager = CampaignManager(campaignStore: campaignStore, campaignService: campaignService, appID: appID)
    }

    open class func removeCachedForms() {
        UBFormDAO.shared.deleteAll()
    }

    open class func resetCampaignData(completion: (() -> Void)?) {
        campaignManager?.resetData(completion: completion)
    }
    #if INTERNAL_USE || DEBUG

        open class func formViewController(forFormJson json: JSON) -> UINavigationController {
            let form = FormModel(json: json, id: "", screenshot: nil)
            let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
            let navigationController = UINavigationController(rootViewController: formController)
            formController.delegate = PassiveFormController(submissionManager: submissionManager)
            return navigationController
        }

        open class func displayCampaignForm(withFormID formID: String, theme: UsabillaTheme = theme) {
            campaignStore.getCampaignForm(withFormID: formID, theme: theme).then { form in
                campaignManager?.displayCampaignForm(form)
            }
        }

        open class func showCampaignForm(formJson: JSON, campaignID: String = "id") {
            let formModel = FormModel(json: formJson, id: "", screenshot: nil)
            campaignManager?.displayCampaignForm(formModel, campaignID: campaignID)
        }
    #endif

    open class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, theme: UsabillaTheme = theme) {

        formStore.loadForm(id: formID, screenshot: screenshot, theme: theme).then { form in
            UsabillaFeedbackForm.viewForForm(form: form, customeVariables: customVariables, success: true)
        }.catch { _ in
            if let defaulForm = formStore.loadDefaultForm(formID, screenshot: screenshot, theme: theme) {
                UsabillaFeedbackForm.viewForForm(form: defaulForm, customeVariables: customVariables, success: false)
            }
        }
    }

    private static func viewForForm(form: FormModel, customeVariables: [String: Any]? = nil, success: Bool) {
        let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
        let navigationController = UINavigationController(rootViewController: formController)
        formController.delegate = PassiveFormController(submissionManager: submissionManager)
        formController.customVars = customeVariables

        DispatchQueue.main.async {
            if !success {
                UsabillaFeedbackForm.delegate?.formFailedLoading(navigationController)
                return
            }
            UsabillaFeedbackForm.delegate?.formLoadedCorrectly(navigationController, active: true)
        }
    }

    open class func takeScreenshot(_ view: UIView) -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
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

    func formLoadedCorrectly(_ form: UINavigationController, active: Bool)
    func formFailedLoading(_ backupForm: UINavigationController)

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
