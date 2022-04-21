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
    static let defaultDataMasks: [String] = ["[0-9]{4,}", "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"]
    private (set) static var maskModel: MaskModel?
    static var customVariables: [String: String] = [:] {
        didSet {
            for (key, _) in customVariables {
                if key.contains(".") || key.contains("$") {
                    DLogError("Custom variable name / key should not contain '.' or '$'")
                }
                if key.isEmpty {
                    DLogError("Custom variable name / key should not be empty string")
                }
            }
            appEventNotifier?.setCustomVariables(customVariables)
            submissionManager?.userContext = customVariables
        }
    }
    static let defaultLocalizedStringFile = "usa_localizable"
    static var localizedStringFile: String = defaultLocalizedStringFile {
        didSet {
            defaultLocalisationFile = false
        }
    }
    static var dismissAutomatically: Bool = true
    static var canDisplayCampaigns: Bool = true

    private static var internalSubmitTelemetryData: Bool = true
    static var submitTelemetryData: Bool {
        get {
            return internalSubmitTelemetryData
        }
        set {
            internalSubmitTelemetryData = newValue
            telemetric.submitTelemetryData = internalSubmitTelemetryData
        }
    }
    private static var internalDebugEnabled: Bool = false
    static var debugEnabled: Bool {
        get {
            return internalDebugEnabled
        }
        set {
            let logid = telemetric.logStart(method: UBTelemetricDebug(), logLevel: .properties )
            telemetric.alterData(for: logid, keyPath: \UBTelemetricDebug.debug, value: newValue, logLevel: .properties)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricDebug.dur)
            // This is setting the internal properties
            internalDebugEnabled = newValue
        }
    }

    private static var internalSetFooterLogoClickable: Bool = true
    static var setFooterLogoClickable: Bool {
        get {
            return internalSetFooterLogoClickable
        }
        set {
            let logid = telemetric.logStart(method: UBTelemetricSetFooterLogoClickable(), logLevel: .properties )
            telemetric.alterData(for: logid, keyPath: \UBTelemetricSetFooterLogoClickable.footerClickable, value: newValue, logLevel: .properties)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricSetFooterLogoClickable.dur)
            // This is setting the internal properties
            internalSetFooterLogoClickable = newValue
        }
    }

    static weak var delegate: UsabillaDelegate?
    static var theme: UsabillaTheme = UsabillaTheme()
    static var defaultLocalisationFile = true
    static var supportedOrientations: UIInterfaceOrientationMask = .all
    private static let campaignService = CampaignService()

    private static let campaignStore: UBCampaignStoreProtocol = UBCampaignStore(service: campaignService)
    private (set) static var appID: String?
    private static var campaignManager: CampaignManager?
    private static var formService: FormService?
    private static var formStore: FormStore?
    private static weak var formNavigationController: UINavigationController?
    private static var  window: UIWindow?
    private static var submissionManager: SubmissionManager?
    private static let errorSDKNotInitialized = "UBError: Usabilla.initialize(appID:String) has not been called. The SDK is not operational."
    static var bannerConfiguration: BannerConfiguration?
    private static let errorCamapingShowing = "UBError: A Campaing is showing. Form can't be displayed."
    private static let errorFormShowing = "UBError: A Form is showing. Campaing can't be displayed."
    private static let initMessage = "GetFeedback | Usabilla : SDK finished initializing"
    private static let sdkVersionMessage = "GetFeedback | Usabilla : Local SDK version -> "
    private static let featurebillaService = FeaturebillaService()
    private static let featurebillaStore: FeaturebillaStoreProtocol = FeaturebillaStore(service: featurebillaService)
    private static var featurebillaManager = UBFeaturebillaManager(featurebillaStore: featurebillaStore, featurebillaService: featurebillaService)

    private static let telemetric = UBTelemetrics(manager: featurebillaManager)

    private static var appEventNotifier: AppEventNotifier?

    class func sendEvent(event: String) {
        campaignManager?.telemetric = telemetric
        let logid = telemetric.logStart(method: UBTelemetricSendEvent(), logLevel: .methods )
        telemetric.alterData(for: logid, keyPath: \UBTelemetricSendEvent.event, value: event, logLevel: .methods)
        if formNavigationController != nil {
            telemetric.alterData(for: logid, keyPath: \UBTelemetricSendEvent.errC,
                                 value: TelemetryConstants.errorCodeClient,
                                 logLevel: .methods)
            telemetric.alterData(for: logid, keyPath: \UBTelemetricSendEvent.errM, value: errorFormShowing, logLevel: .methods)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricSendEvent.dur)
            telemetric.submitLogData()
            return
        }
        campaignManager?.bannerConfig = bannerConfiguration
        campaignManager?.sendEvent(event: event, customVariables: customVariables, logId: logid)
    }

    class func dismiss() -> Bool {
        if formNavigationController != nil {
            return dismissForm()
        }
        return dismissCampaing()
    }

    private class func dismissCampaing() -> Bool {
        guard let manager = campaignManager else {return false}
        return manager.closeCampaign()
    }
    private class func dismissForm() -> Bool {
        guard let controller = formNavigationController else {return false}
        controller.dismiss(animated: true, completion: nil)
        return true
    }

    class func setCustomVariable(value: String, forKey key: String) {
        customVariables[key] = value
        appEventNotifier?.setCustomVariables(customVariables)
        PLog(customVariables)
    }

    class func initialize(appID: String?, completion: (() -> Void)? = nil) {
        Swift.debugPrint(sdkVersionMessage+Bundle.sdkVersion)
        let logid = telemetric.logStart(method: UBTelemetricInitMethod(), logLevel: .methods )

        if let appID = appID {
            guard NSUUID(uuidString: appID) != nil else {
                Swift.debugPrint("Usabilla: The appId \(appID) has wrong format (expected UUID)")
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.errC, value: TelemetryConstants.errorCodeClient, logLevel: .methods)
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.errM, value: "appId has wrong format", logLevel: .methods)
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.appId, value: appID, logLevel: .methods)
                telemetric.logEnd(for: logid, keyPath: \UBTelemetricInitMethod.dur)
                telemetric.submitLogData()
                return
            }
            UsabillaInternal.appID = appID
            appEventNotifier = AppEventNotifier(customVariables: customVariables)
            campaignService.telemetric =  telemetric
            campaignManager = CampaignManager(campaignStore: campaignStore, campaignService: campaignService, appID: appID, completion: { [logid] in
                if let manager = campaignManager {
                    appEventNotifier?.setCampaignManager(manager)
                }
                let numberOfCampaings = campaignManager?.eventEngine.campaigns.count ?? 0
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.appId, value: appID, logLevel: .methods)
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.errC, value: 0, logLevel: .methods)
                telemetric.alterData(for: logid, keyPath: \UBTelemetricInitMethod.numberCampaigns, value: numberOfCampaings, logLevel: .methods)
                telemetric.logEnd(for: logid, keyPath: \UBTelemetricInitMethod.dur)
                telemetric.submitLogData()
                completion?()
            })
        }
        formService = FormService()
        formService?.telemetric = telemetric
        // swiftlint:disable force_unwrapping
        formStore = FormStore(service: formService!)
        submissionManager = SubmissionManager(formService: formService!)
        // swiftlint:enable force_unwrapping

        // preload the poweredby icon, to increase responsivenes....
        _ = Icons.imageOfPoweredBy(color: theme.colors.hint)
        Swift.debugPrint(initMessage)
    }

    class func removeCachedForms() {
        let logid = telemetric.logStart(method: UBTelemetricRemoveCache(), logLevel: .methods )
        UBFormDAO.shared.deleteAll(completion: {[logid] in
            telemetric.alterData(for: logid, keyPath: \UBTelemetricRemoveCache.errC, value: 0, logLevel: .methods)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricRemoveCache.dur)})
    }

    class func resetCampaignData(completion: (() -> Void)?) {
        let logid = telemetric.logStart(method: UBTelemetricReset(), logLevel: .methods )
        telemetric.alterData(for: logid, keyPath: \UBTelemetricReset.callback, value: (completion != nil), logLevel: .methods)
        campaignManager?.resetData(completion: { [logid] in
            telemetric.alterData(for: logid, keyPath: \UBTelemetricReset.errC, value: 0, logLevel: .methods)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricReset.dur)
            completion?()
        })
    }

    class func preloadFeedbackForms(withFormIDs formIDs: [String]) {
        guard let formStore = formStore else {
            print(errorSDKNotInitialized)
            return
        }

        for formID in formIDs {
            _ = formStore.loadForm(id: formID,
                                   screenshot: nil,
                                   theme: theme,
                                   maskModel: UsabillaInternal.maskModel)
        }
    }
    #if INTERNAL_USE || DEBUG

    class func formViewController(forFormData data: Data, screenshot: UIImage? = nil) -> UINavigationController? {
        let json = JSON.init(data: data)
        // swiftlint:disable:next force_unwrapping
        let form = FormModel(json: json, id: "", screenshot: screenshot, maskModel: UsabillaInternal.maskModel, client: ClientModel())!
        return viewForForm(form: form)
    }

    class func displayCampaignForm(withID formID: String, completion: ((UBCampaignFormDisplayError?) -> Void)? = nil) {
        guard let campaignManager = campaignManager else {
            completion?(.sdkNotInitialized)
            return
        }
        campaignService.getCampaignForm(withID: formID, maskModel: UsabillaInternal.maskModel).then { form in
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
        let formModel = FormModel(json: json, id: "", screenshot: nil, maskModel: UsabillaInternal.maskModel)
        // swiftlint:disable:next force_unwrapping
        campaignManager.displayCampaignForm(formModel!)
    }
    #endif

    class func loadFeedbackForm(_ formID: String, screenshot: UIImage? = nil, theme: UsabillaTheme = theme) {
        let logid = telemetric.logStart(method: UBTelemetricLoadForm(), logLevel: .methods )
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.formId, value: formID, logLevel: .methods)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.theme, value: theme != self.theme, logLevel: .methods)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.screenshot, value: screenshot != nil, logLevel: .methods)
        if CampaignWindow.shared.showing {
            DispatchQueue.main.async {
                delegate?.formDidFailLoading(error: UBError(description: errorCamapingShowing))
                telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeClient, logLevel: .methods)
                self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorCamapingShowing, logLevel: .methods)
                self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                self.telemetric.submitLogData()
            }
            return
        }

        guard let formStore = formStore else {
            print(errorSDKNotInitialized)
            telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeClient, logLevel: .methods)
            telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorSDKNotInitialized, logLevel: .methods)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
            telemetric.submitLogData()
            return
        }
        formStore.loadForm(id: formID, screenshot: screenshot, theme: theme, maskModel: UsabillaInternal.maskModel).then { form in
            guard let navigationController = viewForForm(form: form) else {
                DispatchQueue.main.async {
                    delegate?.formDidFailLoading(error: UBError(description: errorSDKNotInitialized))
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorSDKNotInitialized, logLevel: .methods)
                    self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                    self.telemetric.submitLogData()
                }
                return
            }
            DispatchQueue.main.async {
                formNavigationController = navigationController
                delegate?.formDidLoad(form: navigationController)
                self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: 0, logLevel: .methods)
                self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                self.telemetric.submitLogData()
            }

            }.catch { _ in
                DispatchQueue.main.async {
                    delegate?.formDidFailLoading(error: UBError(description: "Unable to load the form"))
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: "Unable to load the form", logLevel: .methods)
                    self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                    self.telemetric.submitLogData()

                }
        }
    }

    class func showFeedbackForm(_ formID: String) {
        let logid = telemetric.logStart(method: UBTelemetricLoadForm(), logLevel: .methods )
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.formId, value: formID, logLevel: .methods)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.theme, value: false, logLevel: .methods)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.screenshot, value: false, logLevel: .methods)
        if CampaignWindow.shared.showing {
            DispatchQueue.main.async {
                delegate?.formDidFailLoading(error: UBError(description: errorCamapingShowing))
                telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeClient, logLevel: .methods)
                self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorCamapingShowing, logLevel: .methods)
                self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                self.telemetric.submitLogData()
            }
            return
        }

        guard let formStore = formStore else {
            print(errorSDKNotInitialized)
            telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeClient, logLevel: .methods)
            telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorSDKNotInitialized, logLevel: .methods)
            telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
            telemetric.submitLogData()
            return
        }
        formStore.loadForm(id: formID, screenshot: nil, theme: theme, maskModel: UsabillaInternal.maskModel).then { form in
            guard let navigationController = viewForForm(form: form) else {
                DispatchQueue.main.async {
                    delegate?.formDidFailLoading(error: UBError(description: errorSDKNotInitialized))
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: errorSDKNotInitialized, logLevel: .methods)
                    self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                    self.telemetric.submitLogData()
                }
                return
            }
            DispatchQueue.main.async {
                formNavigationController = navigationController
                showFormViewController()
                // delegate?.formDidLoad(form: navigationController)
                self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: 0, logLevel: .methods)
                self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                self.telemetric.submitLogData()
            }

            }.catch { _ in
                DispatchQueue.main.async {
                    delegate?.formDidFailLoading(error: UBError(description: "Unable to load the form"))
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errC, value: TelemetryConstants.errorCodeServer, logLevel: .methods)
                    self.telemetric.alterData(for: logid, keyPath: \UBTelemetricLoadForm.errM, value: "Unable to load the form", logLevel: .methods)
                    self.telemetric.logEnd(for: logid, keyPath: \UBTelemetricLoadForm.dur)
                    self.telemetric.submitLogData()

                }
        }
    }

    private static func showFormViewController() {
        guard let navController = formNavigationController else {
            return
        }
        var popupWindow: UIWindow?
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first
            if let windowScene = windowScene as? UIWindowScene {
                popupWindow = PassthroughWindow(windowScene: windowScene)
            }
        } else {
            popupWindow = PassthroughWindow(frame: UIScreen.main.bounds)
        }
        let viewcontroller = UIViewController()
        viewcontroller.view = UBCustomTouchableView()
        viewcontroller.view.backgroundColor = .clear
        viewcontroller.modalPresentationStyle = .overFullScreen
        viewcontroller.view.alpha = 1
        viewcontroller.view.frame = UIScreen.main.bounds
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = true

        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.backgroundColor = .clear
        popupWindow?.windowLevel = UIWindowLevelStatusBar + 1
        popupWindow?.rootViewController = viewcontroller
        popupWindow?.makeKeyAndVisible()

        popupWindow?.rootViewController?.present(navController, animated: true, completion: nil)
        window = popupWindow
    }

    private static func viewForForm(form: FormModel) -> UINavigationController? {
        guard let submissionManager = submissionManager else {
            print(errorSDKNotInitialized)
            return nil
        }
        let formController = FormViewController(viewModel: UBFormViewModel(formModel: form))
        let navigationController = UBNavigationController(rootViewController: formController)
        navigationController.modalPresentationStyle = .fullScreen
        if DeviceInfo.isIPad() {
            #if XCODE1100 || XCODE1200 || XCODE1300
            if #available(iOS 13.0, *) {
                navigationController.isModalInPresentation = true
            }
            #endif
            navigationController.modalPresentationStyle = .formSheet
            navigationController.preferredContentSize = DeviceInfo.preferedFormSize()
            navigationController.presentationController?.delegate = formController
        }
        formController.delegate = PassiveFormController(submissionManager: submissionManager)
        return navigationController
    }

    class func takeScreenshot(_ view: UIView) -> UIImage? {
        // Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        // swiftlint:disable:next force_unwrapping
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func setDataMasking(masks: [String],
                              maskCharacter: Character) {
        let logid = telemetric.logStart(method: UBTelemetricSetDataMasking(), logLevel: .methods )
        let mask = MaskModel(maskCharacter: maskCharacter,
                             masks: masks)
        UsabillaInternal.maskModel = mask
        campaignManager?.maskModel = mask
        let char = String(describing: maskCharacter)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricSetDataMasking.masks, value: masks, logLevel: .methods)
        telemetric.alterData(for: logid, keyPath: \UBTelemetricSetDataMasking.maskCharacter, value: char, logLevel: .methods)
        telemetric.logEnd(for: logid, keyPath: \UBTelemetricSetDataMasking.dur)
    }

}
