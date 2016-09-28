//
//  BaseTextAreaCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseTextAreaCellView: RootCellView, UITextViewDelegate {
    
    var textView: UITextView
    var isPlaceholder: Bool = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textView = UITextView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.dividerLine?.hidden = true
        

        textView.scrollEnabled = true
        self.contentView.addSubview(textView)
        
        NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -18).active = true
        let a = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: self.dividerLine, attribute: .Bottom, multiplier: 1, constant: 12)
        a.priority = 750
        a.active = true
        NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 8).active = true
        NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .Trailing, multiplier: 1, constant: -8).active = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func applyCustomisations() {
        super.applyCustomisations()
        textView.font = item.themeConfig.customFont?.fontWithSize(13)
        textView.textColor = item.themeConfig.primaryTextColor
        textView.tintColor = item.themeConfig.hintColor
        textView.backgroundColor = item.themeConfig.backgroundColor
    }

//    deinit {
//        print("base text cell deinit")
//    }
}
