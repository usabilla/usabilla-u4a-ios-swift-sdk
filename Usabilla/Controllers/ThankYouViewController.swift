//
//  ThankYouViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 12/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    var viewModel: UBEndPageViewModel!
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        customizeView()
    }

    init(viewModel: UBEndPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalMargin).isActive = true

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalMargin).isActive = true
    }

    func customizeView() {
        if let configuration = viewModel?.theme {
            view.backgroundColor = configuration.colors.background
            titleLabel.textColor = configuration.colors.title
            titleLabel.font = configuration.fonts.boldFont

            let font = configuration.fonts.font
            messageLabel.textColor = configuration.colors.text
            messageLabel.font = font
        }
    }

    func reloadForm() {
        SwiftEventBus.post("restoreForm")
    }
}