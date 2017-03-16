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
            let text = model.immutableParagraphValue
            if model.html != nil && model.html == true {
                return text?.htmlToString ?? text
            }
            return text
        }
        set {
            
        }
    }
}
