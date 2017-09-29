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
    class func createField(_ json: JSON, pagemodel: PageModel) -> BaseFieldModel? {
        let type = json["type"].stringValue

        guard let fieldType = FieldType(rawValue: type) else {
            return nil
        }

        switch fieldType {
        case .header:
            return HeaderFieldModel(json: json, pageModel: pagemodel)
        case .paragraph, .titleParagraph:
            return ParagraphFieldModel(json: json, pageModel: pagemodel)
        case .text:
            return TextFieldModel(json: json, pageModel: pagemodel)
        case .choice:
            return ChoiceFieldModel(json: json, pageModel: pagemodel)
        case .email:
            return EmailFieldModel(json: json, pageModel: pagemodel)
        case .textArea:
            return TextAreaFieldModel(json: json, pageModel: pagemodel)
        case .nps:
            return NPSFieldModel(json: json, pageModel: pagemodel)
        case .mood:
            return MoodFieldModel(json: json, pageModel: pagemodel)
        case .rating:
            return RatingFieldModel(json: json, pageModel: pagemodel)
        case .radio:
            return RadioFieldModel(json: json, pageModel: pagemodel)
        case .checkbox:
            return CheckboxFieldModel(json: json, pageModel: pagemodel)
        }

    }

}