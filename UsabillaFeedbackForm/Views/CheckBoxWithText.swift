//
//  CheckBoxWithText.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 06/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import BEMCheckBox

class CheckboxWithText: UIView, BEMCheckBoxDelegate {
    
    var checkBox: BEMCheckBox!
    var delegate: BEMCheckBoxDelegate!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkBox = BEMCheckBox(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        label = UILabel(frame: CGRect(x: 45, y: 5, width: 208, height: 15))
        label.font = UsabillaThemeConfigurator.sharedInstance.customFont.fontWithSize(13)
        
        self.userInteractionEnabled = true
        checkBox.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CheckboxWithText.touchEvent))
        
        self.addGestureRecognizer(gesture)
        
        let color = UsabillaThemeConfigurator.sharedInstance.accentColor
        checkBox.tintColor = color
        checkBox.onTintColor = color
        checkBox.onCheckColor = color
        
        
        self.addSubview(checkBox)
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchEvent() {
        self.checkBox.setOn(!self.checkBox.on, animated: true)
        delegate.didTapCheckBox!(checkBox)
    }
}

