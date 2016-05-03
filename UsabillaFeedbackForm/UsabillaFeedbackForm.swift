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
import SwiftyJSON


public class UsabillaFeedbackForm {
    
    //Various init methods with many parameters\
    public static var delegate: UsabillaFeedbackFormDelegate? = nil
    public static var appStoreId: String? = nil
    public static var redirectToAppStore = false
    public static var localizedStringFile: String = "usa_localizable"
    public static var showCancelButton: Bool = false
    
    public class func initSDKWithScreenshot(appId: String, screenshot: UIImage?, customVariables: [String: AnyObject]?) {
        getFormJsonFromServer(appId, screenshot: screenshot, customVariables: customVariables)
    }
    
    
    class func getFormJsonFromServer (appId: String, screenshot: UIImage?, customVariables: [String: AnyObject]?) {
        
        NetworkManager.getFromFromID(appId).then { (jsonObj: JSON) -> () in
            let form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: appId, screenshot: screenshot)
            
            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            let base = storyboard.instantiateViewControllerWithIdentifier("base") as! UINavigationController
            let formController = base.childViewControllers[0] as! FormViewController
            
            formController.initWithFormModel(form)
            formController.customVars = customVariables
            print("calling success protocol")
            UsabillaFeedbackForm.delegate?.feedbackFromLoadedCorreclty(base, active: true)
            }.error { _ in
                print("calling fail protocol")
                UsabillaFeedbackForm.delegate?.feedbackFromLoadedIncorreclty(UsabillaFeedbackForm.loadDefaultForm()!)
        }
        
    }
    
    
    class func loadDefaultForm() -> UINavigationController? {
        if let path = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.pathForResource("formJson", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj: JSON = JSON(data:data)
                if jsonObj != JSON.null {
                    var form: FormModel = JSONFormParser.parseFormJson(jsonObj, appId: "2", screenshot: nil)
                    form.isDefault = true
                    let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                    let base = storyboard.instantiateViewControllerWithIdentifier("base") as? UINavigationController
                    let formController = base?.childViewControllers[0] as? FormViewController
                    
                    formController!.initWithFormModel(form)
                    print("parsed")
                    return base!
                    
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return nil
    }
    
    public class func takeScreenshot(view: UIView) -> UIImage {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

public protocol UsabillaFeedbackFormDelegate {
    
    func feedbackFromLoadedCorreclty(form: UINavigationController, active: Bool)
    func feedbackFromLoadedIncorreclty(backupForm: UINavigationController)
    
}
