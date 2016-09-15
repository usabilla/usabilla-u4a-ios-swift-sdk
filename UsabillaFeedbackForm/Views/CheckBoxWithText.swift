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
    var delegate: SwiftCheckBoxDelegate!
    var label: UILabel!
    var height: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        checkBox = SwiftCheckBox(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        label = UILabel(frame: CGRect(x: 45, y: 5, width: 208, height: 20))
        label.font = UsabillaThemeConfigurator.sharedInstance.customFont?.fontWithSize(13)
        
        self.userInteractionEnabled = true
        checkBox.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CheckboxWithText.touchEvent))
        
        self.addGestureRecognizer(gesture)
        
        let color = UsabillaThemeConfigurator.sharedInstance.accentColor
        checkBox.tintColor = color
        checkBox.onTintColor = color
        checkBox.onCheckColor = color
        height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 25)
        height.identifier = "CheckBox Height"

        
        self.addSubview(checkBox)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCheckBox(checkBox: SwiftCheckBox) {
        delegate.didTapCheckBox(checkBox)
    }

    
    func touchEvent() {
        self.checkBox.setOn(!self.checkBox.on, animated: true)
        delegate.didTapCheckBox(checkBox)
    }
}
