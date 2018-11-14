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

    var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var textView: UITextView!
    var labelPlaceHolder: UILabel!
    override func build() {

        addSubview(borderView)
        textView = UITextView()
        textView.text = viewModel.value
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        borderView.addSubview(textView)

        labelPlaceHolder = UILabel()
        labelPlaceHolder.isHidden = true // by default it's always hidden
        textView.addSubview(labelPlaceHolder)

        labelPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        labelPlaceHolder.leftAnchor.constraint(equalTo: textView.leftAnchor).isActive = true
        labelPlaceHolder.rightAnchor.constraint(equalTo: textView.rightAnchor).isActive = true
        labelPlaceHolder.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        labelPlaceHolder.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true

        borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        borderView.topAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        textView.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5).isActive = true
        textView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5).isActive = true

        // customization
        let theme = viewModel.theme
        borderView.layer.borderColor = theme.colors.hint.cgColor
        textView.font = theme.fonts.font.getDynamicTypeFont()
        textView.textColor = theme.colors.text
        textView.tintColor = theme.colors.hint
        textView.backgroundColor = .clear

        labelPlaceHolder.font = theme.fonts.font.getDynamicTypeFont()
        labelPlaceHolder.textColor = theme.colors.hint
        labelPlaceHolder.backgroundColor = .clear
    }
}
