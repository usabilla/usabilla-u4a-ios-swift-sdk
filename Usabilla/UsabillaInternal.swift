//
//  Usabilla.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 02/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UsabillaInternal {

    static var customVariables: [String: Any] = [:] {
        didSet {
            submissionManager?.userContext = customVariables
        }
    }
    static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }
    static var hideGiveMoreFeedback: Bool = true
    static var dismissAutomatically: Bool = true
    static var canDisplayCampaigns: Bool = true
    static var debugEnabled: Bool = false
    static weak var delegate: UsabillaDelegate?
    static var theme: UsabillaTheme = UsabillaTheme()
    static var defaultLocalisationFile = true
    private static let campaignService = CampaignService()
    private static let campaignStore: UBCampaignStoreProtocol = UBCampaignStore(service: campaignService)
    private (set) static var appID: String?
    private static var campaignManager: CampaignManager?
    private static var formService: FormService?
    private static var formStore: FormStore?
    private static var submissionManager: SubmissionManager?
    private static let errorSDKNotInitialized = "UBError: Usabilla.initialize(appID:String) has not been called. The SDK is not operational."

    class func sendEvent(event: String) {
        campaignManager?.sendEvent(event: event, customVariables: customVariables)
    }

    class func setCustomVariable(value: Any?, forKey key: String) {
        customVariables[key] = value
        PLog(customVariables)
    }

    class func initialize(appID: String?) {
        if let appID = appID {
            guard NSUUID(uuidString: appID) != nil else {
                Swift.debugPrint("Usabilla: provided appID has wrong format: expected UUID")
                return
            }
            UsabillaInternal.appID = appID
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

    class func preloadForms(withFormIDs formIDs: [String]) {
        guard let formStore = formStore else {
            print(errorSDKNotInitialized)
            return
        }

        for formID in formIDs {
            _ = formStore.loadForm(id: formID, screenshot: nil, theme: theme)
        }
    }
    #if INTERNAL_USE || DEBUG

        class func formViewController(forFormData data: Data) -> UINavigationController? {
            let json = JSON.init(data: data)
            let form = FormModel(json: json, id: "", screenshot: nil)
            return viewForForm(form: form)
        }

        class func displayCampaignForm(withID formID: String, completion: ((UBCampaignFormDisplayError?) -> Void)? = nil) {
            guard let campaignManager = campaignManager else {
                completion?(.sdkNotInitialized)
                return
            }
            campaignService.getCampaignForm(withID: formID).then { form in
                form.updateTheme()
                let displayed = campaignManager.displayCampaignForm(form)
                completion?(displayed ? nil : .campaignAlreadyBeingPresented)
            }.catch { _ in
                completion?(.formFetchFailed)
            }
        }

        class func displayCampaignForm(withData data: Data) {
            let json = JSON.init(data: data)
            guard json != JSON.null,
                let campaignManager = campaignManager else {
                return
            }
            let formModel = FormModel(json: json, id: "", screenshot: nil)
            campaignManager.displayCampaignForm(formModel)
        }
    #endif

    class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
        guard let formStore = formStore else {
            print(errorSDKNotInitialized)
            return
        }
        formStore.loadForm(id: formID, screenshot: screenshot, theme: theme).then { form in
            guard let navigationController = viewForForm(form: form) else {
                DispatchQueue.main.async {
                    delegate?.formDidFailLoading(error: UBError(description: errorSDKNotInitialized))
                }
                return
            }
            DispatchQueue.main.async {
                delegate?.formDidLoad(form: navigationController)
            }

        }.catch { _ in
            DispatchQueue.main.async {
                delegate?.formDidFailLoading(error: UBError(description: "Unable to load the form"))
            }
        }
    }

    private static func viewForForm(form: FormModel) -> UINavigationController? {
        guard let submissionManager = submissionManager else {
            print(errorSDKNotInitialized)
            return nil
        }
        let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
        let navigationController = UINavigationController(rootViewController: formController)
        if DeviceInfo.isIPad() {
            navigationController.modalPresentationStyle = .formSheet
        }
        formController.delegate = PassiveFormController(submissionManager: submissionManager)
        return navigationController
    }

    class func takeScreenshot(_ view: UIView) -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        // swiftlint:disable:next force_unwrapping
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
