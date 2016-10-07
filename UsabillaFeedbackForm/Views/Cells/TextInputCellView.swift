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
        
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .RoundedRect
        contentView.addSubview(textField)
        
        textField.addTarget(self, action: #selector(TextInputCellView.textFieldDidChange), forControlEvents: .EditingChanged)
        
        let a  = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        a.priority = 750
        a.active = true

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
        
        textField.tintColor = model.themeConfig.hintColor
        textField.font = model.themeConfig.customFont?.fontWithSize(13)
        textField.textColor = model.themeConfig.textColor
        textField.backgroundColor = themeConfig.backgroundColor
        textField.layer.borderColor = model.themeConfig.hintColor.CGColor
        applyCustomisations()
    }

    
    func textFieldDidEndEditing(textField: UITextField) {
        model.fieldValue = textField.text
    }
    
    func textFieldDidChange() {
        model.fieldValue = textField.text
    }
    
//    deinit {
//        print("Text input cell deinit")
//    }
    
    
}
