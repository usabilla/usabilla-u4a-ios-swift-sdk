//
//  ParagraphComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ParagraphComponent: BaseTextAreaComponent<ParagraphComponentViewModel> {

    override func build() {
        super.build()

        textView.isEditable = false
        textView.dataDetectorTypes = [.link, .phoneNumber]
        textView.isScrollEnabled = false
        textView.text = viewModel.value
    }
}
