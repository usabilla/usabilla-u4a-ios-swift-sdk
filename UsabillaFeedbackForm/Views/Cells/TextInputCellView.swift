//  EmailCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class TextInputCellView: RootCellView, UITextFieldDelegate {
    
    var textField: UITextField
    var model: StringFieldModel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        textField = UITextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textField.font = UsabillaThemeConfigurator.sharedInstance.customFont?.fontWithSize(13)
        textField.textColor = UsabillaThemeConfigurator.sharedInstance.primaryTextColor
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .RoundedRect
        
        textField.tintColor = UsabillaThemeConfigurator.sharedInstance.hintColor
        contentView.addSubview(textField)
        
        textField.addTarget(self, action: #selector(TextInputCellView.textFieldDidChange), forControlEvents: .EditingChanged)
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8).active = true
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0).active = true
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -8).active = true

    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! StringFieldModel
        textField.text = model.fieldValue
        
        if let model2 = model as? TextFieldModel {
            textField.placeholder = model2.placeHolder
        }
    }

    
    func textFieldDidEndEditing(textField: UITextField) {
        model.fieldValue = textField.text
    }
    
    func textFieldDidChange() {
        model.fieldValue = textField.text
    }
    
    
}
