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
        textView.isScrollEnabled = false
        
        self.rootCellContainerView.addSubview(textView)
//
//        NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .bottom, multiplier: 1, constant: -18).isActive = true
//        let a = NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .bottom, multiplier: 1, constant: 12)
//        a.priority = 750
//        a.isActive = true
//        
//        NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
//        NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .trailing, multiplier: 1, constant: -8).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func applyCustomisations() {
        super.applyCustomisations()
        textView.font = item.themeConfig.font.withSize(themeConfig.textFontSize)
        textView.textColor = item.themeConfig.textColor
        textView.tintColor = item.themeConfig.hintColor
        textView.backgroundColor = item.themeConfig.backgroundColor
        

    }

//    deinit {
//        print("base text cell deinit")
//    }
}
