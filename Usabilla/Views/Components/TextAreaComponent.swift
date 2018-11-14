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

    override func build() {
        super.build()

        textView.dataDetectorTypes = .link
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
