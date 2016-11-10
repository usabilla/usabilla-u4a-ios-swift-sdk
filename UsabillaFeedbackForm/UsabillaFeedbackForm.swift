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
    open static var showCancelButton: Bool = false
    static var defaultLocalisationFile = true
    open static var localizedStringFile: String = "usa_localizable" {
        didSet {
            defaultLocalisationFile = false
        }
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

public protocol UsabillaFeedbackFormDelegate: class {
    
    func formLoadedCorrectly(_ form: UINavigationController, active: Bool)
    func formFailedLoading(_ backupForm: UINavigationController)
    
}
