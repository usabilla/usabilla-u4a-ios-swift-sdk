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
    open static weak var delegate: UsabillaFeedbackFormDelegate? = nil
    open static var appStoreId: String? = nil
    open static var hideGiveMoreFeedback: Bool = true
    open static var showCancelButton: Bool = false
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

    open class func loadFeedbackForm(_ appId: String, screenshot: UIImage? = nil, customVariables: [String: Any]? = nil, themeConfig: UsabillaThemeConfigurator = UsabillaThemeConfigurator()) {
        NetworkManager.getFormJsonFromServer(appId, screenshot: screenshot, customVariables: customVariables, themeConfig: themeConfig)
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
    let formId: String
    let mood: Int?
    let abandonedPageIndex: Int?
    
    var sent : Bool {
        return mood != nil
    }
}

public protocol UsabillaFeedbackFormDelegate: class {

    func formLoadedCorrectly(_ form: UINavigationController, active: Bool)
    func formFailedLoading(_ backupForm: UINavigationController)
    
    /**
        This method is called once the user has submitted the form
        - Parameter mood: Int between 1 and 5 (included) matching the value set by the user on the mood control
    */
    func formDidClose(with feedbackResults:[FeedbackResult])

}

public extension UsabillaFeedbackFormDelegate {
    func formDidClose(with feedbackResults:[FeedbackResult]) {
        
    }
}
