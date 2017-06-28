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
    open static var hideGiveMoreFeedback: Bool = true
    open static var showCancelButton: Bool = false
    open static var dismissAutomatically: Bool = true

    static var defaultLocalisationFile = true
    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }

    /**
       Initialize the **Usabilla SDK**
     
       This method should be called once, inside the AppDelegate **didFinishLaunchingWithOptions** method.
     
       The initialization allows to send previous persisted feedbacks if it was not possible to send them because of an internet connection issue for example.
    */
    open class func load() {
        _ = SubmissionManager.shared // init the singleton to send persisted feedback
    }
    
    open class func removeCachedForms() {
        CacheManager.shared.removeAllCachedForms()
    }

    /**
     Preloads a list of form to make them available to the user even without network connectivity.
     */
    open class func preloadForms(withIds ids: [String]) {
        for id in ids {
            _ = FormStore.loadForm(id: id, screenshot: nil, customVariables: nil, themeConfig: UsabillaThemeConfigurator())
        }
    }

    open class func loadFeedbackForm(_ appId: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, themeConfig: UsabillaThemeConfigurator = UsabillaThemeConfigurator()) {
        
        FormStore.loadForm(id: appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig).then { form in
                UsabillaFeedbackForm.viewForForm(form: form, customeVariables: customVariables, success: true)
            }.catch {_ in
                if let defaulForm = FormStore.loadDefaultForm(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig) {
                UsabillaFeedbackForm.viewForForm(form: defaulForm, customeVariables: customVariables, success: false)
            }
        }
    }
    
    private static func viewForForm(form: FormModel, customeVariables: [String: Any]? = nil, success: Bool) {
        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        guard let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
            let formController = base.childViewControllers[0] as? FormViewController else {
                return
        }
        
        formController.initWithFormModel(form)
        formController.customVars = customeVariables
        
        DispatchQueue.main.async {
            if !success {
                UsabillaFeedbackForm.delegate?.formFailedLoading(base)
                return
            }
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
    */
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult])

    /**
     This method is called before the form is closed

     - Parameter form: UINavigationcontroller which is being dismissed
     - Parameter formID: String representing the ID of the form

     This method should be used to dismiss the form if the UsabillaFeedbackForm.**dismissAutomatically** attribute is set to **false**
     */
    func formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult])
}

public extension UsabillaFeedbackFormDelegate {
    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
    }
    func formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
    }
}
