//
//  TextAreaComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class TextAreaComponent: BaseTextAreaComponent<TextAreaComponentViewModel> {
    // TODO manage placeholder
    func textViewDidChange(_ textView: UITextView) {
        viewModel.value = textView.text
    }
}
