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
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)

        textField.addTarget(self, action: #selector(TextInputCellView.textFieldDidChange), for: .editingChanged)

        let a  = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)
        a.priority = 750
        a.isActive = true

        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 0.9, constant: 0).isActive = true

        NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -8).isActive = true

    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! StringFieldModel
        textField.text = model.fieldValue

        if let model2 = model as? TextFieldModel {
            textField.placeholder = model2.placeHolder
            if let placeHolder = model2.placeHolder {
                if let font = themeConfig.customFont {
                    if let italics = font.withTraits(.traitItalic) {
                        textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: italics])
                    } else {
                        textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: font])
                    }
                } else {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
                }
            }
        }

    }

    override func applyCustomisations() {
        super.applyCustomisations()
        textField.tintColor = model.themeConfig.hintColor
        textField.font = model.themeConfig.customFont?.withSize(13)
        textField.textColor = model.themeConfig.textColor
        textField.backgroundColor = themeConfig.backgroundColor
        textField.layer.borderColor = model.themeConfig.hintColor.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
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
