//
//  TextAreaComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class TextAreaComponent: BaseTextAreaComponent<TextAreaComponentViewModel> {

    var line: UIView!

    override func build() {
        super.build()
        line = UIView()

        textView.dataDetectorTypes = .link
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)

        // positioning
        line.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).activate()
        line.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).activate()
        line.heightAnchor.constraint(equalToConstant: 1).activate()
        line.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 2).activate()

        // configuration
        if viewModel.value != nil {
            textView.text = viewModel.value
            viewModel.isPlaceHolder = false
        } else {
            viewModel.isPlaceHolder = true
            textView.text = viewModel.placeHolder
        }

        // customization
        setCorrectFont()
        line.backgroundColor = viewModel.theme.hintColor
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if viewModel.isPlaceHolder {
            textView.text = nil
        }
        viewModel.isPlaceHolder = false
        setCorrectFont()
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.value = textView.text
        valueChanged()
        SwiftEventBus.postToMainThread("updateMySize")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = viewModel.placeHolder
            viewModel.value = nil
            viewModel.isPlaceHolder = true
            setCorrectFont()
            valueChanged()
        }
    }

    func setCorrectFont() {
        let theme = viewModel.theme
        textView.font = theme.font

        if !viewModel.isPlaceHolder {
            textView.textColor = theme.textColor
        } else {
            textView.textColor = theme.hintColor
        }

    }
}
