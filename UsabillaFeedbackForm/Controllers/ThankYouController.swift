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
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var moreFeedbackButton: UIButton!
    @IBOutlet weak var distanceBetweenButtons: NSLayoutConstraint!
    
    weak var themeConfig: UsabillaThemeConfigurator?
    var redirectEnabled: Bool = false
    
    var redirectToAppStore: String?
    var giveMoreFeedback: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeConfig?.backgroundColor
    }


    func openAppStore() {
        if let appStore = UsabillaFeedbackForm.appStoreId {
            let url = String(format: "itms-apps://itunes.apple.com/us/app/apple-store/id%@", appStore)
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }

    func reloadForm() {
        SwiftEventBus.post("restoreForm")
    }

    func setUpController(_ thresholdMet: Bool, thankTitle: String?, thankMessage: String?) {

        if thresholdMet && redirectEnabled && UsabillaFeedbackForm.appStoreId != nil {
            rateButton.setTitle(redirectToAppStore, for: UIControlState())
            rateButton.addTarget(self, action: #selector(ThankYouController.openAppStore), for: .touchUpInside)
        } else {
            rateButton.isHidden = true
            distanceBetweenButtons.isActive = false
        }
            
        
        if !UsabillaFeedbackForm.hideGiveMoreFeedback {
            moreFeedbackButton.setTitle(giveMoreFeedback, for: UIControlState())
            moreFeedbackButton.addTarget(self, action: #selector(ThankYouController.reloadForm), for: .touchUpInside)
        } else {
            moreFeedbackButton.isHidden = true
        }

        titleLabel.text = thankTitle
        messageLabel.text = thankMessage
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0
        
        if let configuration = themeConfig {
            
            titleLabel.textColor = configuration.titleColor
            titleLabel.font = configuration.font.withSize(configuration.titleFontSize).bold()

            let font = configuration.font.withSize(configuration.textFontSize)
            
            rateButton.setTitleColor(configuration.accentColor, for: UIControlState())
            rateButton.titleLabel?.font = font.bold()
            
            
            moreFeedbackButton.setTitleColor(configuration.accentColor, for: UIControlState())
            moreFeedbackButton.titleLabel?.font = font.bold()
            
            messageLabel.textColor = configuration.textColor
            messageLabel.font = font
        }
    }
}
