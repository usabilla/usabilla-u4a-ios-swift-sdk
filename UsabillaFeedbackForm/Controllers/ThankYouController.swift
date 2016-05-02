//
//  ThankYouController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 12/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit


class ThankYouController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!

    
    func openAppStore() {
        let url = String(format: "itms-apps://itunes.apple.com/us/app/apple-store/id%@", UsabillaFeedbackForm.appStoreId!)
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    
    func reloadForm() {
        SwiftEventBus.post("restoreForm")
    }
    
    func setUpController (thresholdMet: Bool, thankTitle: String?, thankMessage: String?) {
        if thresholdMet && UsabillaFeedbackForm.redirectToAppStore && UsabillaFeedbackForm.appStoreId != nil {
            bottomButton.setTitle(NSLocalizedString("usa_invite_rate_app_store", tableName: UsabillaFeedbackForm.localizedStringFile, bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!, comment: ""), forState: .Normal)
            bottomButton.addTarget(self, action: #selector(ThankYouController.openAppStore), forControlEvents: .TouchUpInside)
        } else {
            bottomButton.setTitle(NSLocalizedString("usa_more_feedback", tableName: UsabillaFeedbackForm.localizedStringFile, bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!, comment: ""), forState: .Normal)
            bottomButton.addTarget(self, action: #selector(ThankYouController.reloadForm), forControlEvents: .TouchUpInside)
        }
        
        titleLabel.text = thankTitle
        messageLabel.text = thankMessage
    }
}
