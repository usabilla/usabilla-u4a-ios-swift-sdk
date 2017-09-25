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

    static var customVariables: [String: Any] = [:] {
        didSet {
            submissionManager?.userContext = customVariables
        }
    }
    private static let campaignService = CampaignService()
    private static let campaignStore: UBCampaignStoreProtocol = UBCampaignStore(service: UsabillaFeedbackForm.campaignService)

    private static var appID: String?
    private static var campaignManager: CampaignManager?
    private static var formService: FormService?
    private static var formStore: FormStore?
    private static var submissionManager: SubmissionManager?

    class func sendEvent(event: String) {
        campaignManager?.sendEvent(event: event, customVariables: customVariables)
    }

    class func setCustomVariable(value: Any?, forKey key: String) {
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
    open class func initialize(appID: String?) {
        if let appID = appID {
            guard NSUUID(uuidString: appID) != nil else {
                Swift.debugPrint("UsabillaFeedbackForm: provided appID has wrong format: expected UUID")
                return
            }
            UsabillaFeedbackForm.appID = appID
            campaignManager = CampaignManager(campaignStore: campaignStore, campaignService: campaignService, appID: appID)
        }

        formService = FormService()
        // swiftlint:disable force_unwrapping
        formStore = FormStore(service: formService!)
        submissionManager = SubmissionManager(formService: formService!)
        // swiftlint:enable force_unwrapping
    }

    class func removeCachedForms() {
        UBFormDAO.shared.deleteAll()
    }

    class func resetCampaignData(completion: (() -> Void)?) {
        campaignManager?.resetData(completion: completion)
    }
    #if INTERNAL_USE || DEBUG

        open class func formViewController(forFormJson json: JSON) -> UINavigationController? {
            guard let submissionManager = submissionManager else { return nil}
            let form = FormModel(json: json, id: "", screenshot: nil)
            let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
            let navigationController = UINavigationController(rootViewController: formController)
            formController.delegate = PassiveFormController(submissionManager: submissionManager)
            return navigationController
        }

        open class func displayCampaignForm(withFormID formID: String, theme: UsabillaTheme = Usabilla.theme) {
            campaignStore.getCampaignForm(withFormID: formID, theme: theme).then { form in
                campaignManager?.displayCampaignForm(form)
            }
        }

        open class func showCampaignForm(formJson: JSON, campaignID: String = "id") {
            let formModel = FormModel(json: formJson, id: "", screenshot: nil)
            campaignManager?.displayCampaignForm(formModel, campaignID: campaignID)
        }
    #endif

    class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = Usabilla.theme) {
        guard let formStore = formStore else {
            print("UBError: Usabilla.initialize(appID:String) has not been called. The SDK is not operational.")
            return
        }
        formStore.loadForm(id: formID, screenshot: screenshot, theme: theme).then { form in
            UsabillaFeedbackForm.viewForForm(form: form)
        }.catch { _ in
            DispatchQueue.main.async {
                Usabilla.delegate?.formFailedLoading()
            }
        }
    }

    private static func viewForForm(form: FormModel) {
        guard let submissionManager = submissionManager else { return }
        let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
        let navigationController = UINavigationController(rootViewController: formController)
        formController.delegate = PassiveFormController(submissionManager: submissionManager)
        DispatchQueue.main.async {
            Usabilla.delegate?.formLoadedCorrectly(navigationController)
        }
    }

    class func takeScreenshot(_ view: UIView) -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
