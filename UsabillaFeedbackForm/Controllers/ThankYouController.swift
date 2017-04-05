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

    var viewModel: UBEndPageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = viewModel?.theme.backgroundColor

        if viewModel.canRedirectToAppStore {
            rateButton.setTitle(viewModel.appStoreRedirectText, for: UIControlState())
            rateButton.addTarget(self, action: #selector(ThankYouController.openAppStore), for: .touchUpInside)
        } else {
            distanceBetweenButtons.constant = 0
            rateButton.clipsToBounds = true
            rateButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        if viewModel.canGiveMoreFeedback {
            moreFeedbackButton.setTitle(viewModel.moreFeedbackText, for: UIControlState())
            moreFeedbackButton.addTarget(self, action: #selector(ThankYouController.reloadForm), for: .touchUpInside)
        } else {
            moreFeedbackButton.isHidden = true
        }

        titleLabel.text = viewModel.headerText
        messageLabel.text = viewModel.thankyouText
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 0

        if let configuration = viewModel?.theme {

            titleLabel.textColor = configuration.titleColor
            titleLabel.font = configuration.font.withSize(configuration.titleFontSize).bold()

            let font = configuration.font.withSize(configuration.textFontSize)

            rateButton.setTitleColor(configuration.accentColor, for: UIControlState())
            rateButton.titleLabel?.font = font

            moreFeedbackButton.setTitleColor(configuration.accentColor, for: UIControlState())
            moreFeedbackButton.titleLabel?.font = font

            messageLabel.textColor = configuration.textColor
            messageLabel.font = font
        }
    }

    func openAppStore() {
        if let appStore = UsabillaFeedbackForm.appStoreId {
            let url = String(format: "http://itunes.apple.com/app/id%@", appStore)
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }

    func reloadForm() {
        SwiftEventBus.post("restoreForm")
    }
}
