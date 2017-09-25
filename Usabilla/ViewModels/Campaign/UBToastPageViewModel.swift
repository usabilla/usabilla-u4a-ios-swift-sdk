//
//  UBToastPageViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBToastPageViewModel {
    private var model: UBEndPageModel

    var text: String?

    init(model: UBEndPageModel) {
        self.model = model
        if model.fields.count > 0 {
            if let paragraph: ParagraphFieldModel = model.fields[0] as? ParagraphFieldModel {
                text = paragraph.fieldValue
            }
        }
    }
}
