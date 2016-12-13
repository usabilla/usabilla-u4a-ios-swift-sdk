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
    var line: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        textField = UITextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        line = UIView()
        
        line.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(TextInputCellView.textFieldDidChange), for: .editingChanged)
        contentView.addSubview(textField)
        contentView.addSubview(line)
        
        let a  = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)
        a.priority = 750
        a.isActive = true
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -8).isActive = true
        
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 4).isActive = true
        //NSLayoutConstraint(item: line, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -8).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! StringFieldModel
        textField.text = model.fieldValue
        
        if let model2 = model as? TextFieldModel {
            if let placeHolder = model2.placeHolder {
                if let italics = themeConfig.font.withSize(themeConfig.textFontSize).withTraits(.traitItalic) {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: italics])
                } else {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: themeConfig.font.withSize(themeConfig.textFontSize)])
                }
            }
        }
        
    }
    
    override func applyCustomisations() {
        super.applyCustomisations()
        textField.tintColor = model.themeConfig.hintColor
        textField.font = model.themeConfig.font.withSize(themeConfig.textFontSize)
        textField.textColor = model.themeConfig.textColor
        textField.backgroundColor = themeConfig.backgroundColor
        line.backgroundColor = themeConfig.hintColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        model.fieldValue = textField.text
    }
    
    func textFieldDidChange() {
        model.fieldValue = textField.text
    }
    
    //    deinit {
    //        print("Text input cell deinit")
    //    }
    
    
}
