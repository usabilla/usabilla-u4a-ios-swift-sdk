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


public class UsabillaFeedbackForm {

    //Various init methods with many parameters\
    public static weak var delegate: UsabillaFeedbackFormDelegate? = nil
    public static var appStoreId: String? = nil
    public static var hideGiveMoreFeedback: Bool = true

    public static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
    }
    public static var showCancelButton: Bool = false
    static var defaultLocalisationFile = true

    public class func loadFeedbackForm(appId: String, screenshot: UIImage? = nil, customVariables: [String: AnyObject]? = nil, themeConfig: UsabillaThemeConfigurator = UsabillaThemeConfigurator()) {
        getFormJsonFromServer(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)
    }


    class func getFormJsonFromServer (appId: String, screenshot: UIImage?, customVariables: [String: AnyObject]?, themeConfig: UsabillaThemeConfigurator) {

        NetworkManager.getFormWithFormID(appId).then { (jsonObj: JSON) -> () in
            let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            let base = storyboard.instantiateViewControllerWithIdentifier("base") as! UINavigationController
            let formController = base.childViewControllers[0] as! FormViewController

            formController.initWithFormModel(form)
            formController.customVars = customVariables
            Swift.debugPrint("calling success protocol")
            UsabillaFeedbackForm.delegate?.feedbackFormLoadedCorrectly(base, active: true)
            }.error { _ in
                Swift.debugPrint("calling fail protocol")
                UsabillaFeedbackForm.delegate?.feedbackFormLoadedIncorrectly(UsabillaFeedbackForm.loadDefaultForm(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)!)
        }

    }


    class func loadDefaultForm(appId: String, screenshot: UIImage?, customVariables: [String: AnyObject]?, themeConfig: UsabillaThemeConfigurator) -> UINavigationController? {
        if let path = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.pathForResource("defaultJson", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)

                let jsonObj: JSON = JSON(data:data)
                if jsonObj != JSON.null {
                    let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot, themeConfig: themeConfig)
                    form.isDefault = true
                    let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                    let base = storyboard.instantiateViewControllerWithIdentifier("base") as? UINavigationController
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

    public class func takeScreenshot(view: UIView) -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

public protocol UsabillaFeedbackFormDelegate: class {

    func feedbackFormLoadedCorrectly(form: UINavigationController, active: Bool)
    func feedbackFormLoadedIncorrectly(backupForm: UINavigationController)

}
