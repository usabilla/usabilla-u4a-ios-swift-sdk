//
//  ComponentViewModelFactory.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

class ComponentViewModelFactory {

    class func component(field: FieldModelProtocol, theme: UsabillaTheme) -> ComponentViewModel? {

        switch field {

        case is CheckboxFieldModel:
            let m = (field as? CheckboxFieldModel)!
            return CheckBoxComponentViewModel(model: m, theme: theme)
        case is ChoiceFieldModel:
            let m = (field as? ChoiceFieldModel)!
            return ChoiceComponentViewModel(model: m, theme: theme)
        case is EmailFieldModel:
            let m = (field as? EmailFieldModel)!
            return EmailComponentViewModel(model: m, theme: theme)
        case is HeaderFieldModel:
            let m = (field as? HeaderFieldModel)!
            return HeaderComponentViewModel(model: m, theme: theme)
        case is MoodFieldModel:
            let m = (field as? MoodFieldModel)!
            return MoodComponentViewModel(model: m, theme: theme)
        case is ParagraphFieldModel:
            let m = (field as? ParagraphFieldModel)!
            return ParagraphComponentViewModel(model: m, theme: theme)
        case is RadioFieldModel:
            let m = (field as? RadioFieldModel)!
            return RadioComponentViewModel(model: m, theme: theme)
        case is RatingFieldModel:
            let m = (field as? RatingFieldModel)!
            return SliderComponentViewModel(model: m, theme: theme)
        case is ScreenshotModel:
            let m = (field as? ScreenshotModel)!
            return ScreenshotComponentViewModel(model: m, theme: theme)
        case is TextAreaFieldModel:
            let m = (field as? TextAreaFieldModel)!
            return TextAreaComponentViewModel(model: m, theme: theme)
        case is TextFieldModel:
            let m = (field as? TextFieldModel)!
            return TextFieldComponentViewModel(model: m, theme: theme)

        default:
            break
        }
        return nil
    }
}
