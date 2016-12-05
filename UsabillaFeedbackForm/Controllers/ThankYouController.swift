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
    weak var themeConfig: UsabillaThemeConfigurator?
    var redirectEnabled: Bool = false
    
    var redirectToAppStore: String?
    var giveMoreFeedback: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = themeConfig?.backgroundColor
    }


    func openAppStore() {
        let url = String(format: "itms-apps://itunes.apple.com/us/app/apple-store/id%@", UsabillaFeedbackForm.appStoreId!)
        UIApplication.shared.openURL(URL(string: url)!)
    }

    func reloadForm() {
        SwiftEventBus.post("restoreForm")
    }

    func setUpController (_ thresholdMet: Bool, thankTitle: String?, thankMessage: String?) {

        if thresholdMet && redirectEnabled && UsabillaFeedbackForm.appStoreId != nil {
            bottomButton.setTitle(redirectToAppStore, for: UIControlState())
            bottomButton.addTarget(self, action: #selector(ThankYouController.openAppStore), for: .touchUpInside)
        } else if !UsabillaFeedbackForm.hideGiveMoreFeedback {
            bottomButton.setTitle(giveMoreFeedback, for: UIControlState())
            bottomButton.addTarget(self, action: #selector(ThankYouController.reloadForm), for: .touchUpInside)
        } else {
            bottomButton.isHidden = true
        }

        bottomButton.titleLabel?.font = themeConfig?.font.withSize(15)
        bottomButton.setTitleColor(themeConfig?.accentColor, for: UIControlState())

        titleLabel.text = thankTitle
        titleLabel.font = themeConfig?.font.withSize(17.0)
        titleLabel.textColor = themeConfig?.titleColor

        messageLabel.text = thankMessage
        messageLabel.font = themeConfig?.font.withSize(13)
        messageLabel.textColor = themeConfig?.textColor
        messageLabel.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        messageLabel.numberOfLines = 0
        //messageLabel.layoutIfNeeded()
    }

//    deinit {
//        print("bye and thank you")
//    }
}
