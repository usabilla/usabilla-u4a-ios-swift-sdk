//
//  TextAreaCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class TextAreaCellView: BaseTextAreaCellView {
    var model: TextAreaFieldModel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.dataDetectorTypes = .link
        let a = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
        a.priority = 750
        a.isActive = true
        //textView.layer.borderColor = model.themeConfig.hintColor.CGColor
        //textView.layer.borderWidth = 1.0
        //textView.layer.cornerRadius = 5.0
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        model = item as! TextAreaFieldModel
    }

    override func applyCustomisations() {
        super.applyCustomisations()
        if model.fieldValue != nil {
            textView.text = model.fieldValue
            isPlaceholder = false
        } else {
            isPlaceholder = true
            textView.text = model.placeHolder
        }
        
        setCorrectFont()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if isPlaceholder {
            textView.text = nil
        }
        isPlaceholder = false
        setCorrectFont()
    }

    func textViewDidChange(_ textView: UITextView) {
        model.fieldValue = textView.text
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = model.placeHolder
            model.fieldValue = nil
            isPlaceholder = true
            setCorrectFont()
        }
    }
    
    func setCorrectFont() {
        if !isPlaceholder {
            textView.font = model.themeConfig.font.withSize(16)
            textView.textColor = model.themeConfig.textColor
        } else {
            textView.textColor = model.themeConfig.hintColor
            if let customFont = themeConfig.font.withSize(16).withTraits(.traitItalic) {
                textView.font = customFont
            } else {
                textView.font = UIFont.italicSystemFont(ofSize: 16)
            }
        }
    
    }

//    deinit {
//        print("Text area cell deinit")
//    }
}
