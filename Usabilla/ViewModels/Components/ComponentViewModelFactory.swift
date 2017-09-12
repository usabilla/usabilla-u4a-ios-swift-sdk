//
//  ComponentViewModelFactory.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable force_unwrapping

import Foundation

class ComponentViewModelFactory {

    class func component(field: FieldModelProtocol, theme: UsabillaTheme) -> ComponentViewModel? {

        switch field {

        case is CheckboxFieldModel:
            let model = (field as? CheckboxFieldModel)!
            return CheckBoxComponentViewModel(model: model, theme: theme)
        case is ChoiceFieldModel:
            let model = (field as? ChoiceFieldModel)!
            return ChoiceComponentViewModel(model: model, theme: theme)
        case is EmailFieldModel:
            let model = (field as? EmailFieldModel)!
            return EmailComponentViewModel(model: model, theme: theme)
        case is HeaderFieldModel:
            let model = (field as? HeaderFieldModel)!
            return HeaderComponentViewModel(model: model, theme: theme)
        case is MoodFieldModel:
            let model = (field as? MoodFieldModel)!
            return MoodComponentViewModel(model: model, theme: theme)
        case is ParagraphFieldModel:
            let model = (field as? ParagraphFieldModel)!
            return ParagraphComponentViewModel(model: model, theme: theme)
        case is RadioFieldModel:
            let model = (field as? RadioFieldModel)!
            return RadioComponentViewModel(model: model, theme: theme)
        case is RatingFieldModel:
            let model = (field as? RatingFieldModel)!
            return SliderComponentViewModel(model: model, theme: theme)
        case is ScreenshotModel:
            let model = (field as? ScreenshotModel)!
            return ScreenshotComponentViewModel(model: model, theme: theme)
        case is TextAreaFieldModel:
            let model = (field as? TextAreaFieldModel)!
            return TextAreaComponentViewModel(model: model, theme: theme)
        case is TextFieldModel:
            let model = (field as? TextFieldModel)!
            return TextFieldComponentViewModel(model: model, theme: theme)
        case is NPSFieldModel:
            let model = (field as? NPSFieldModel)!
            return NPSComponentViewModel(model: model, theme: theme)

        default:
            break
        }
        return nil
    }
}
