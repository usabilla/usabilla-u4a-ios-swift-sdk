//
//  CheckBoxWithText.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 06/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class CheckboxWithText: UIView, SwiftCheckBoxDelegate {

    var checkBox: SwiftCheckBox!
    weak var delegate: SwiftCheckBoxDelegate?
    var label: UILabel!
    var labelTopConstraint: NSLayoutConstraint!
    let checkboxSize: CGFloat = 25
    var theme: UsabillaTheme? {
        didSet {
            applyCustomisation()
        }
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        checkBox = SwiftCheckBox()
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.widthAnchor.constraint(equalToConstant: checkboxSize).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: checkboxSize).isActive = true
        self.isUserInteractionEnabled = true
        checkBox.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CheckboxWithText.touchEvent))

        self.addGestureRecognizer(gesture)
        self.addSubview(checkBox)
        self.addSubview(label)

        checkBox.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        checkBox.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        labelTopConstraint = label.topAnchor.constraint(equalTo: checkBox.topAnchor)
        labelTopConstraint.isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }

    func applyCustomisation() {
        guard let theme = theme else {
            return
        }
        let color = theme.accentColor
        checkBox.tintColor = color
        checkBox.onTintColor = color
        checkBox.onCheckColor = color
        label.font = theme.font.withSize(theme.textFontSize)
        label.textColor = theme.textColor
        let spaceAvailable = (checkboxSize - label.font.lineHeight)
        labelTopConstraint.constant = spaceAvailable / 2

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didTapCheckBox(_ checkBox: SwiftCheckBox) {
        delegate?.didTapCheckBox(checkBox)
    }

    func touchEvent() {
        self.checkBox.setOn(!self.checkBox.on, animated: true)
        delegate?.didTapCheckBox(checkBox)
    }
}
