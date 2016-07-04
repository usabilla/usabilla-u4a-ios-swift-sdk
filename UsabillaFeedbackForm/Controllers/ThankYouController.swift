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
            bottomButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_invite_rate_app_store"), forState: .Normal)
            bottomButton.addTarget(self, action: #selector(ThankYouController.openAppStore), forControlEvents: .TouchUpInside)
        } else {
            bottomButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_more_feedback"), forState: .Normal)
            bottomButton.addTarget(self, action: #selector(ThankYouController.reloadForm), forControlEvents: .TouchUpInside)
        }
        
        titleLabel.text = thankTitle
        messageLabel.text = thankMessage
    }
}
