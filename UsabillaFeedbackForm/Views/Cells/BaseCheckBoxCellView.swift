//
//  BaseCheckBoxCellView.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 12/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class BaseCheckboxCellView: RootCellView, SwiftCheckBoxDelegate {
    
    var checkBoxes: [CheckboxWithText] = []
    var model: FieldModelWithOptions!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func updateCheckBoxeslayout(){
        for checkBox in checkBoxes {
            checkBox.height.active =  isCurrentlyDisplayed ? true : false
        }
    }
    
    override func isCurrentlyDisplayedChanged() {
        super.isCurrentlyDisplayedChanged()
        updateCheckBoxeslayout()
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! FieldModelWithOptions
        for checkbox in checkBoxes {
            checkbox.removeFromSuperview()
        }
        checkBoxes = []
        var previousCheckbox: CheckboxWithText?
        
        for (index, option) in model.options.enumerate() {
            
            let checkBox = CheckboxWithText()
            checkBox.delegate = self
            checkBox.checkBox.delegate = self
            //checkBox.checkBox.delegate = self
            
            styleCheckBox(checkBox)
            checkBox.label.text = option.title
            checkBox.label.textColor = UsabillaThemeConfigurator.sharedInstance.primaryTextColor
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            checkBox.userInteractionEnabled = true
            
            if model.fieldValue.contains(option.value ) {
                checkBox.checkBox.on = true
            }
            
            self.contentView.addSubview(checkBox)
            checkBoxes.append(checkBox)
            
            checkBox.height.active = true
            NSLayoutConstraint(item: checkBox, attribute: .Width, relatedBy: .Equal, toItem: self.contentView, attribute: .Width, multiplier: 1, constant: 0).active = true
            
            if index == 0 {
                //First checkbox
                NSLayoutConstraint(item: checkBox, attribute: .Top, relatedBy: .Equal, toItem: dividerLine, attribute: .Bottom, multiplier: 1, constant: 4).active = true
            } else {
                let a = NSLayoutConstraint(item: checkBox, attribute: .Top, relatedBy: .Equal, toItem: previousCheckbox!, attribute: .Bottom, multiplier: 1, constant: 8)
                a.priority = 750
                a.active = true
            }
            
            if index == model.options.count - 1 {
                //Last element
                NSLayoutConstraint(item: checkBox, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -12).active = true
            }
            
            
            previousCheckbox = checkBox
        }
        
    }
    
    func didTapCheckBox(checkBox: SwiftCheckBox) {
        fatalError("didTapCheckBox has not been implemented")
        
    }
    
    func styleCheckBox(checkBox: CheckboxWithText) {
        fatalError("styleCheckBox has not been implemented")
    }
    
    
//    deinit {
//        print("base checkbox  cell deinit")
//    }
}
