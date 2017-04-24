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

    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }

    // services
    private static var campaignManager: CampaignManager?

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
        _ = SubmissionManager.shared // init the singleton to send persisted feedback
        guard NSUUID(uuidString: appId) != nil else {
            Swift.debugPrint("UsabillaFeedbackForm: provided appID has wrong format: expected UUID")
            return
        }
        appIdentifier = appId
        campaignManager = CampaignManager(campaignStore: UBCampaignStore(), appId: appId)
    }

    open class func removeCachedForms() {
        UBFormDAO.shared.deleteAll()
    }

    open class func loadFeedbackForm(_ appId: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, theme: UsabillaTheme = UsabillaTheme()) {

        FormStore.loadForm(id: appId, screenshot: screenshot, customVariables: customVariables, theme: theme).then { form in
            UsabillaFeedbackForm.viewForForm(form: form, customeVariables: customVariables)
        }.catch { _ in
            if let defaulForm = FormStore.loadDefaultForm(appId, screenshot: screenshot, customVariables: customVariables, theme: theme) {
                UsabillaFeedbackForm.viewForForm(form: defaulForm, customeVariables: customVariables)
            }
        }
    }

    private static func viewForForm(form: FormModel, customeVariables: [String: Any]? = nil) {
        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        guard let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
            let formController = base.childViewControllers[0] as? FormViewController else {
                return
        }
        formController.delegate = PassiveFormController()
        formController.viewModel = UBFormViewModel(formModel: form)
        formController.customVars = customeVariables

        DispatchQueue.main.async {
            UsabillaFeedbackForm.delegate?.formLoadedCorrectly(base, active: true)
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

    open class func showCampaign(formJson: JSON) {
        let campaign = CampaignModel(id: "", json: JSON.parse(""))
        let formModel = FormModel(json: formJson, id: "", screenshot: nil)
        campaign.form = formModel
        CampaignWindow.shared.showCampaign(campaign)
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

}

public extension UsabillaFeedbackFormDelegate {
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
    }
}
