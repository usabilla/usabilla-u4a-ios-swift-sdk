//
//  UsabillaFeedbackForm.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 02/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


open class UsabillaFeedbackForm {

    //Various init methods with many parameters\
    open static weak var delegate: UsabillaFeedbackFormDelegate? = nil
    open static var appStoreId: String? = nil
    open static var hideGiveMoreFeedback: Bool = true

    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }
    open static var showCancelButton: Bool = false
    static var defaultLocalisationFile = true

    open class func loadFeedbackForm(_ appId: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, themeConfig: UsabillaThemeConfigurator = UsabillaThemeConfigurator()) {
        getFormJsonFromServer(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)
    }


    class func getFormJsonFromServer (_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) {

        NetworkManager.getFormWithFormID(formID: appId).then { (jsonObj: JSON) -> () in
            let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            let base = storyboard.instantiateViewController(withIdentifier: "base") as! UINavigationController
            let formController = base.childViewControllers[0] as! FormViewController

            formController.initWithFormModel(form)
            formController.customVars = customVariables
            Swift.debugPrint("calling success protocol")
            UsabillaFeedbackForm.delegate?.feedbackFormLoadedCorrectly(base, active: true)
            }.catch { _ in
                Swift.debugPrint("calling fail protocol")
                UsabillaFeedbackForm.delegate?.feedbackFormLoadedIncorrectly(UsabillaFeedbackForm.loadDefaultForm(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)!)
        }

    }


    class func loadDefaultForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator) -> UINavigationController? {
        if let path = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.path(forResource: "defaultJson", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)

                let jsonObj: JSON = JSON(data:data)
                if jsonObj != JSON.null {
                    let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)
                    form.isDefault = true
                    let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                    let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController
                    let formController = base?.childViewControllers[0] as? FormViewController

                    formController!.initWithFormModel(form)
                    formController!.customVars = customVariables

                    return base!

                } else {
                    Swift.debugPrint("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
        } else {
            Swift.debugPrint("Invalid filename/path.")
        }
        return nil
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

public protocol UsabillaFeedbackFormDelegate: class {

    func feedbackFormLoadedCorrectly(_ form: UINavigationController, active: Bool)
    func feedbackFormLoadedIncorrectly(_ backupForm: UINavigationController)

}
