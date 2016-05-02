//
//  EmailCelLView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import SwiftValidator

class EmailCellView: TextInputCellView {
    
    var mailModel: EmailFieldModel!
    let validator = Validator()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.keyboardType = .EmailAddress
        validator.registerField(textField, rules: [EmailRule()])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        mailModel = item as! EmailFieldModel
        textField.placeholder = mailModel.placeHolder
        textField.text = mailModel.fieldValue
        
    }
    
    override func textFieldDidEndEditing(textField: UITextField) {
        validator.validateField(textField) { error in
            if error == nil {
                self.textField.tintColor = UsabillaThemeConfigurator.sharedInstance.hintColor
                self.mailModel.fieldValue = textField.text
            } else {
                self.textField.tintColor = UsabillaThemeConfigurator.sharedInstance.errorColor
            }
        }
        
    }
    
}
