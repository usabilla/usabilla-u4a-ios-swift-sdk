//
//  ParagraphComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseTextAreaComponent<T: StringComponentViewModel>: UBComponent<T>, UITextViewDelegate {

    var textView: UITextView!

    override func build() {
        textView = UITextView()
        textView.text = viewModel.value
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false

        addSubview(textView)

        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customization
        let theme = viewModel.theme
        textView.font = theme.font
        textView.textColor = theme.textColor
        textView.tintColor = theme.hintColor
        textView.backgroundColor = theme.backgroundColor
    }
}
