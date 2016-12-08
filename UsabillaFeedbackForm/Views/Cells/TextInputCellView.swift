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
        
        contentView.addSubview(textField)

        textField.addTarget(self, action: #selector(TextInputCellView.textFieldDidChange), for: .editingChanged)

        let a  = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)
        a.priority = 750
        a.isActive = true

        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -8).isActive = true
        
        NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: textField, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: -8).isActive = true

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
                    if let italics = themeConfig.font.withSize(16).withTraits(.traitItalic) {
                        textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: italics])
                    } else {
                        textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: themeConfig.font.withSize(16)])
                    }
                }
        }

    }

    override func applyCustomisations() {
        super.applyCustomisations()
        textField.tintColor = model.themeConfig.hintColor
        textField.font = model.themeConfig.font.withSize(16)
        textField.textColor = model.themeConfig.textColor
        textField.backgroundColor = themeConfig.backgroundColor
//        textField.layer.borderColor = model.themeConfig.hintColor.cgColor
//        textField.layer.borderWidth = 1.0
//        textField.layer.cornerRadius = 5
//        textField.layer.masksToBounds = true
        
        let border = CALayer()
        border.borderColor = themeConfig.hintColor.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - 1  , width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = CGFloat(1.0)
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
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
