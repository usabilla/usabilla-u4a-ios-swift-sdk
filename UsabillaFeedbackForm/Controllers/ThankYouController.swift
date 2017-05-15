//
//  ThankYouController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 12/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class ThankYouController: UIViewController {

    let sideMargin: CGFloat = 16.0
    let verticalMargin: CGFloat = 20.0

    var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    var messageLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    var rateButton: UIButton = {
        let bt = UIButton()
        return bt
    }()

    var moreFeedBackButton: UIButton = {
        let bt = UIButton()
        return bt
    }()

    var viewModel: UBEndPageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        customizeView()
    }

    func setUpView() {
        // labels
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)

        titleLabel.text = viewModel.headerText
        messageLabel.text = viewModel.thankyouText

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalMargin).isActive = true

        // buttons
        var topConstraint: NSLayoutYAxisAnchor!
        if viewModel.canRedirectToAppStore {
            view.addSubview(rateButton)
            rateButton.translatesAutoresizingMaskIntoConstraints = false
            rateButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
            rateButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
            rateButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: verticalMargin).isActive = true
            rateButton.setTitle(viewModel.appStoreRedirectText, for: UIControlState())
            rateButton.addTarget(self, action: #selector(openAppStore), for: .touchUpInside)
            topConstraint = rateButton.bottomAnchor
        } else {
            topConstraint = messageLabel.bottomAnchor
        }

        if viewModel.canGiveMoreFeedback {
            view.addSubview(moreFeedBackButton)
            moreFeedBackButton.translatesAutoresizingMaskIntoConstraints = false
            moreFeedBackButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
            moreFeedBackButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
            moreFeedBackButton.topAnchor.constraint(equalTo: topConstraint, constant: verticalMargin).isActive = true
            moreFeedBackButton.setTitle(viewModel.moreFeedbackText, for: UIControlState())
            moreFeedBackButton.addTarget(self, action: #selector(reloadForm), for: .touchUpInside)
        }
    }
    
    func customizeView() {
        if let configuration = viewModel?.theme {
            
            view.backgroundColor = viewModel?.theme.backgroundColor
            
            titleLabel.textColor = configuration.titleColor
            titleLabel.font = configuration.boldFont
            
            let font = configuration.font
            
            rateButton.setTitleColor(configuration.accentColor, for: UIControlState())
            rateButton.titleLabel?.font = font
            
            moreFeedBackButton.setTitleColor(configuration.accentColor, for: UIControlState())
            moreFeedBackButton.titleLabel?.font = font
            
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
