//
//  EmailCelLView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 15/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class EmailCellView: TextInputCellView {
    
    var mailModel: EmailFieldModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.keyboardType = .EmailAddress
        //validator.registerField(textField, rules: [EmailRule()])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        mailModel = item as! EmailFieldModel
        if let placeHolder = mailModel.placeHolder {
            if let font = themeConfig.customFont {
                if let italics = font.withTraits(.TraitItalic) {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: italics])
                } else {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: font])
                }
            } else {
                textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: UIFont.italicSystemFontOfSize(UIFont.systemFontSize())])
            }
        }
        textField.text = mailModel.fieldValue
    }
    
    
    
    //    deinit {
    //        print("mail cell deinit")
    //    }
    
}
