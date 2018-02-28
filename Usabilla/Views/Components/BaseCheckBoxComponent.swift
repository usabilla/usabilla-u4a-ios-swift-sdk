//
//  BaseCheckBoxComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 26/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseCheckBoxComponent<T: OptionsComponentViewModel>: UBComponent<T>, SwiftCheckBoxDelegate {

    var checkBoxes: [CheckboxWithText] = []
    var stackView: UIStackView!

    override func build() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).activate()
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        stackView.leftAnchor.constraint(equalTo: leftAnchor).activate()
        stackView.rightAnchor.constraint(equalTo: rightAnchor).activate()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        configure()
    }

    func configure() {
        for c in checkBoxes {
            stackView.removeArrangedSubview(c)
            c.removeFromSuperview()
        }

        checkBoxes = []
        for (index, option) in viewModel.options.enumerated() {
            let checkBox = CheckboxWithText()
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.theme = viewModel.theme
            checkBox.delegate = self
            checkBox.checkBox.delegate = self
            checkBox.label.text = option.title
            checkBox.accessibilityLabel = "option \(index + 1), \(option.title)"
            checkBox.isUserInteractionEnabled = true

            if let val = viewModel.value, val.contains(option.value) {
                checkBox.checkBox.on = true
                checkBox.accessibilityValue = LocalisationHandler.getLocalisedStringForKey("usa_selected")
            } else {
                checkBox.accessibilityValue = LocalisationHandler.getLocalisedStringForKey("usa_unselected")
            }
            checkBoxes.append(checkBox)
            stackView.addArrangedSubview(checkBox)
        }
        stackView.setNeedsLayout()
    }

    func didTapCheckBox(_ checkBox: SwiftCheckBox) {

    }
}