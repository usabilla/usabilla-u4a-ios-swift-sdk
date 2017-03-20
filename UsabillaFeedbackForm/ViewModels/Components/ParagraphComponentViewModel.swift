//
//  ParagraphComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ParagraphComponentViewModel: BaseStringComponentViewModel<ParagraphFieldModel> {
    override var value: String? {
        get {
            guard let text = model.immutableParagraphValue else {
                return nil
            }
            if model.html != nil && model.html == true {
                return text.htmlToString
            }
            return text
        }
        set {}
    }
}
