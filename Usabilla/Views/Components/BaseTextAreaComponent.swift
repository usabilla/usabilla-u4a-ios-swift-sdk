//
//  ParagraphComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseTextAreaComponent<T: StringComponentViewModel>: UBComponent<T>, UITextViewDelegate {

    var textView: UITextView!
    var labelPlaceHolder: UILabel!

    override func build() {
        textView = UITextView()
        textView.text = viewModel.value
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        addSubview(textView)

        labelPlaceHolder = UILabel()
        labelPlaceHolder.isHidden = true // by default it's always hidden
        textView.addSubview(labelPlaceHolder)

        labelPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        labelPlaceHolder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelPlaceHolder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelPlaceHolder.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelPlaceHolder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        textView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customization
        let theme = viewModel.theme
        textView.font = theme.fonts.font.getDynamicTypeFont()
        textView.textColor = theme.colors.text
        textView.tintColor = theme.colors.hint
        textView.backgroundColor = theme.colors.background

        labelPlaceHolder.font = theme.fonts.font.getDynamicTypeFont()
        labelPlaceHolder.textColor = theme.colors.hint
        labelPlaceHolder.backgroundColor = .clear
    }
}
