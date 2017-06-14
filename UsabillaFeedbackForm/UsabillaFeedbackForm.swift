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

    //Various init methods with many parameters\
    open static weak var delegate: UsabillaFeedbackFormDelegate?
    open static var appStoreId: String?
    open static var hideGiveMoreFeedback: Bool = true
    open static var showCancelButton: Bool = false
    open static var dismissAutomatically: Bool = true
    open static var theme: UsabillaTheme = UsabillaTheme()
    open static var canDisplayCampaigns: Bool = true

    static var appIdentifier: String?
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
        campaignManager?.sendEvent(event: event)
    }

    /**
    Initialize the **Usabilla SDK**
     
    This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.
     
    The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
    It also allows to fetch the campaigns associated to the **appId**.
     
    - parameter appId: The app identifier (eg: **0D5424BE-41AD-4434-A081-32C393A998A3**)
    */
    open class func load(appId: String) {
        guard NSUUID(uuidString: appId) != nil else {
            Swift.debugPrint("UsabillaFeedbackForm: provided appID has wrong format: expected UUID")
            return
        }
        appIdentifier = appId
        campaignManager = CampaignManager(campaignStore: campaignStore, appId: appId)
        formStore = FormStore(service: FormService())
    }

    open class func removeCachedForms() {
        UBFormDAO.shared.deleteAll()
    }

    open class func loadFeedbackForm(_ appId: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, theme: UsabillaTheme = UsabillaTheme()) {

        formStore.loadForm(id: appId, screenshot: screenshot, theme: theme).then { form in
            UsabillaFeedbackForm.viewForForm(form: form, customeVariables: customVariables)
        }.catch { _ in
            if let defaulForm = formStore.loadDefaultForm(appId, screenshot: screenshot, theme: theme) {

                UsabillaFeedbackForm.viewForForm(form: defaulForm, customeVariables: customVariables)
            }
        }
    }

    open class func displayCampaignForm(withFormId formId: String, theme: UsabillaTheme = UsabillaTheme()) {
        guard let campaignManager = campaignManager else {
            let error = NSError(domain: "SDK not initialized", code: 0, userInfo: nil)
            delegate?.campaignFormDidDisplay(formId: formId, error: error)
            return
        }
        campaignStore.getCampaignForm(withFormId: formId, theme: theme).then { form in
            if campaignManager.displayCampaignForm(form) {
                delegate?.campaignFormDidDisplay(formId: formId, error: nil)
                return
            }
            let error = NSError(domain: "A campaign form is already displayed", code: 0, userInfo: nil)
            delegate?.campaignFormDidDisplay(formId: formId, error: error)
        }.catch { error in
            delegate?.campaignFormDidDisplay(formId: formId, error: error)
        }
    }

    private static func viewForForm(form: FormModel, customeVariables: [String: Any]? = nil) {
        let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
        let navigationController = UINavigationController(rootViewController: formController)
        formController.delegate = PassiveFormController(submissionManager: submissionManager)
        formController.customVars = customeVariables

        DispatchQueue.main.async {
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

    open class func showCampaignForm(formJson: JSON, campaignId: String = "id") {
        let formModel = FormModel(json: formJson, id: "", screenshot: nil)
        campaignManager?.displayCampaignForm(formModel, campaignId: campaignId)
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
     
        If UsabillaFeedbackForm.**hideGiveMoreFeedback** is set to **false**, the **feedbackResults** array will always contains only one value.
        Otherwise the feedbackResults can contains between 1 and n FeedbackResult
     
        This method should be used to dismiss the form if the UsabillaFeedbackForm.**dismissAutomatically** attribute is set to **false**
    */
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult])

    /**
     This method will be called after calling **displayCampaignForm** and allows to know if the form has been displayed or not
     - Parameter formId: String representing the identifier of the form
     - Parameter error: optional error when fetching or displaying the form

     The form has been successfully displayed if the **error** is nil
     */
    func campaignFormDidDisplay(formId: String, error: Error?)
}

public extension UsabillaFeedbackFormDelegate {
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) { }
    func campaignFormDidDisplay(formId: String, error: Error?) { }
}
