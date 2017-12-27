//
//  TextAreaComponent.swift
//  Usabilla
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

        labelPlaceHolder.lineBreakMode = .byWordWrapping
        labelPlaceHolder.numberOfLines = 0
        labelPlaceHolder.sizeToFit()

        // configuration
        if viewModel.value != nil {
            textView.text = viewModel.value
        } else {
            labelPlaceHolder.isHidden = false
            labelPlaceHolder.text = viewModel.placeHolder
        }

        line.backgroundColor = viewModel.theme.colors.hint
    }

    // MARK: TextField delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !labelPlaceHolder.isHidden {
            textView.text = nil
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        viewModel.value = textView.text
        labelPlaceHolder.isHidden = !textView.text.isEmpty
        valueChanged()
        SwiftEventBus.postToMainThread("updateMySize")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            viewModel.value = nil
            labelPlaceHolder.isHidden = false
            valueChanged()
        }
    }
}
