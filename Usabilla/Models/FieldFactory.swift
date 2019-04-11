//
//  FieldFactory.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class FieldFactory {
    
    enum FieldType: String {
        case header
        case paragraph
        case titleParagraph
        case text
        case choice
        case email
        case textArea
        case nps
        case mood
        case rating
        case radio
        case checkbox
    }

    // swiftlint:disable:next cyclomatic_complexity
    class func createField(_ json: JSON, maskModel: MaskModel?) -> BaseFieldModel? {
        let type = json["type"].stringValue

        guard let fieldType = FieldType(rawValue: type) else {
            return nil
        }

        switch fieldType {
        case .header:
            return HeaderFieldModel(json: json)
        case .paragraph, .titleParagraph:
            return ParagraphFieldModel(json: json)
        case .text:
            let model = TextFieldModel(json: json)
            model.masks = maskModel
            return model
        case .choice:
            return PickerFieldModel(json: json)
        case .email:
            return EmailFieldModel(json: json)
        case .textArea:
            let model = TextAreaFieldModel(json: json)
            model.masks = maskModel
            return model
        case .nps:
            return NPSFieldModel(json: json)
        case .mood:
            return MoodFieldModel(json: json)
        case .rating:
            return RatingFieldModel(json: json)
        case .radio:
            return RadioFieldModel(json: json)
        case .checkbox:
            return CheckboxFieldModel(json: json)
        }

    }

}
