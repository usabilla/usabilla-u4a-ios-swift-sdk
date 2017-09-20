//
//  ParagraphComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseTextAreaComponent<T: StringComponentViewModel>: UBComponent<T>, UITextViewDelegate {

    var textView: UITextView!

    override func build() {
        textView = UITextView()
        textView.text = viewModel.value
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero

        addSubview(textView)

        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customization
        let theme = viewModel.theme
        textView.font = theme.fonts.font
        textView.textColor = theme.colors.text
        textView.tintColor = theme.colors.hint
        textView.backgroundColor = theme.colors.background
    }
}
