//
//  FieldFactory.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class FieldFactory {

    class func createField(_ json: JSON, pagemodel: PageModel) -> BaseFieldModel? {

        let type = json["type"].stringValue

        switch type {
        case "header":
            return HeaderFieldModel(json: json, pageModel: pagemodel)
        case"paragraph":
            return ParagraphFieldModel(json: json, pageModel: pagemodel)
        case"text":
            return  TextFieldModel(json: json, pageModel: pagemodel)
        case"choice":
            return  ChoiceFieldModel(json: json, pageModel: pagemodel)
        case"email":
            return  EmailFieldModel(json: json, pageModel: pagemodel)
        case"textArea":
            return  TextAreaFieldModel(json: json, pageModel: pagemodel)
        case"comment":
            return  CommentFieldModel(json: json, pageModel: pagemodel)
        case"nps":
            if json["mode"].exists() && json["mode"].stringValue == "slider"{
                return  RatingFieldModel(json: json, pageModel: pagemodel, isNPS: true)
            } else {
                return  NPSFieldModel(json: json, pageModel: pagemodel)
            }
        case"mood":
            if json["mode"].exists() && json["mode"].stringValue == "star"{
                return  StarFieldModel(json: json, pageModel: pagemodel)
            } else {
                return  MoodFieldModel(json: json, pageModel: pagemodel)
            }
        case"rating":
            return  RatingFieldModel(json: json, pageModel: pagemodel, isNPS: false)
        case"radio":
            return  RadioFieldModel(json: json, pageModel: pagemodel)
        case"checkbox":
            return  CheckboxFieldModel(json: json, pageModel: pagemodel)
        default:
            return nil

        }

    }

}
