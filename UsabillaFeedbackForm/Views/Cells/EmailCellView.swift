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
        textField.keyboardType = .emailAddress
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        mailModel = item as! EmailFieldModel
        if let placeHolder = mailModel.placeHolder {
        
                if let italics = themeConfig.font.withSize(themeConfig.textFontSize).withTraits(.traitItalic) {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: italics])
                } else {
                    textField.attributedPlaceholder = NSAttributedString(string:placeHolder, attributes: [NSForegroundColorAttributeName: themeConfig.hintColor, NSFontAttributeName: themeConfig.font.withSize(themeConfig.textFontSize)])
                }
            
        }
        textField.text = mailModel.fieldValue
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if let email = textField.text {
            mailModel.fieldValue = email
            updateBorderColor(email: email)
        }
    }
    
    func updateBorderColor(email: String?){
        if let toTest = email{
            if isValidEmail(testStr: toTest) {
                textField.layer.borderColor = mailModel.themeConfig.hintColor.cgColor
            } else {
                textField.layer.borderColor = mailModel.themeConfig.errorColor.cgColor
            }
        }
    }
    
    override func textFieldDidChange() {
        mailModel.fieldValue = textField.text
    }
    
    override func applyCustomisations() {
        super.applyCustomisations()
        updateBorderColor(email: mailModel.fieldValue)
    }
    
    
    
    //    deinit {
    //        print("mail cell deinit")
    //    }
    
}
