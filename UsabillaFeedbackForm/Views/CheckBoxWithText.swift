//
//  CheckBoxWithText.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 06/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class CheckboxWithText: UIView, SwiftCheckBoxDelegate {

    var checkBox: SwiftCheckBox!
    weak var delegate: SwiftCheckBoxDelegate?
    var label: UILabel!
    var height: NSLayoutConstraint!
    var themeConfig: UsabillaThemeConfigurator? {
        didSet {
            applyCustomisation()
        }
    }

    override init(frame: CGRect) {

        super.init(frame: frame)
        checkBox = SwiftCheckBox(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        self.isUserInteractionEnabled = true
        checkBox.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CheckboxWithText.touchEvent))

        self.addGestureRecognizer(gesture)

        height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)
        height.identifier = "CheckBox Height"


        self.addSubview(checkBox)
        self.addSubview(label)
        
        NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: checkBox, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: checkBox, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: checkBox, attribute: .centerY, multiplier: 1, constant: 0).isActive = true


    }

    func applyCustomisation() {

        let color = themeConfig!.accentColor
        checkBox.tintColor = color
        checkBox.onTintColor = color
        checkBox.onCheckColor = color
        label.font = themeConfig?.font.withSize(themeConfig!.textFontSize)
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
