//
//  ParagraphBaseComponent.swift
//  Usabilla
//
//  Created by Anders Liebl on 12/11/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseParagraphComponent<T: StringComponentViewModel>: UBComponent<T>, UITextViewDelegate {

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

        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: -16).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

        // customization
        let theme = viewModel.theme
        textView.font = theme.fonts.font.getDynamicTypeFont()
        textView.textColor = theme.colors.text
        textView.tintColor = .clear
        textView.backgroundColor = .clear
        backgroundColor = .clear
    }
}
