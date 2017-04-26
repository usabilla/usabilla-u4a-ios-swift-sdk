//
//  ParagraphCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ParagraphCellView: BaseTextAreaCellView {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber]
        textView.isScrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? ParagraphFieldModel else {
            return
        }
        let text = item.immutableParagraphValue
        if item.html != nil && item.html! {
            textView.attributedText = attributedStringParse(htmlText: text!, font: themeConfig.font.withSize(themeConfig.textFontSize))
        } else {
            textView.text = text
        }
    }

    func attributedStringParse(htmlText: String, font: UIFont) -> NSAttributedString {
        let modifiedFont = NSString(format:"<span style=\"font-family: '\(font.fontName)'; font-size: \(font.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        // swiftlint:disable force_try
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        return attrStr
    }
    
    override func applyCustomisations() {
        super.applyCustomisations()
        setFeedbackItem(item)
    }
    
}
