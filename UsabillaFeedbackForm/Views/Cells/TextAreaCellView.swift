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
    var line: UIView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        line = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.dataDetectorTypes = .link
        line.translatesAutoresizingMaskIntoConstraints = false
        rootCellContainerView.addSubview(line)

        
        NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true
        NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        
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
        line.backgroundColor = themeConfig.hintColor
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
        SwiftEventBus.postToMainThread("updateMySize")
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
            textView.font = model.themeConfig.font.withSize(themeConfig.textFontSize)
            textView.textColor = model.themeConfig.textColor
        } else {
            textView.textColor = model.themeConfig.hintColor
            if let customFont = themeConfig.font.withSize(themeConfig.textFontSize).withTraits(.traitItalic) {
                textView.font = customFont
            } else {
                textView.font = UIFont.italicSystemFont(ofSize: themeConfig.textFontSize)
            }
        }
    
    }

//    deinit {
//        print("Text area cell deinit")
//    }
}
