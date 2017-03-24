//
//  UBAlertDisplay.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBAlertDisplay: UBIntroOutroDisplay {

    static func build(view: UBIntroOutroView) {
        view.widthAnchor.constraint(equalToConstant: 270).activate()
        view.layer.cornerRadius = 14.0
        view.layer.masksToBounds = true

        view.titleLabel?.textAlignment = .center

        let horizontalLine = UIView()
        horizontalLine.translatesAutoresizingMaskIntoConstraints = false
        view.buttonsStackView.addSubview(horizontalLine)
        horizontalLine.backgroundColor = view.viewModel.hintColor
        horizontalLine.widthAnchor.constraint(equalTo: view.buttonsStackView.widthAnchor).isActive = true
        horizontalLine.leftAnchor.constraint(equalTo: view.buttonsStackView.leftAnchor).isActive = true
        horizontalLine.topAnchor.constraint(equalTo: view.buttonsStackView.topAnchor, constant: 0.0).isActive = true
        horizontalLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        view.buttonsStackView?.clipsToBounds = true

        guard view.viewModel.hasContinueButton else {
            return
        }

        let buttonsDividerLine = UIView()
        buttonsDividerLine.translatesAutoresizingMaskIntoConstraints = false
        view.buttonsStackView.addSubview(buttonsDividerLine)
        buttonsDividerLine.backgroundColor = view.viewModel.hintColor
        buttonsDividerLine.heightAnchor.constraint(equalTo: view.buttonsStackView.heightAnchor).isActive = true
        buttonsDividerLine.centerXAnchor.constraint(equalTo: view.buttonsStackView.centerXAnchor).isActive = true
        buttonsDividerLine.topAnchor.constraint(equalTo: view.buttonsStackView.topAnchor).isActive = true
        buttonsDividerLine.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
}
