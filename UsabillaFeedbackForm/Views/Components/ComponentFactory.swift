//
//  ComponentWrapper.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

class ComponentFactory {

    class func component(viewModel: ComponentViewModel) -> UIControl {

        switch viewModel {
        case is ChoiceComponentViewModel:
            return ChoiceComponent(viewModel: (viewModel as? ChoiceComponentViewModel)!)
        case is RadioComponentViewModel:
            return RadioComponent(viewModel: (viewModel as? RadioComponentViewModel)!)
        case is CheckBoxComponentViewModel:
            return CheckBoxComponent(viewModel: (viewModel as? CheckBoxComponentViewModel)!)
        case is EmailComponentViewModel:
            return EmailComponent(viewModel: (viewModel as? EmailComponentViewModel)!)
        case is HeaderComponentViewModel:
            return HeaderComponent(viewModel: (viewModel as? HeaderComponentViewModel)!)
        case is TextAreaComponentViewModel:
            return TextAreaComponent(viewModel: (viewModel as? TextAreaComponentViewModel)!)
        case is TextFieldComponentViewModel:
            return BaseTextFieldComponent(viewModel: (viewModel as? TextFieldComponentViewModel)!)
        case is MoodComponentViewModel:
            return MoodComponent(viewModel: (viewModel as? MoodComponentViewModel)!)
        case is ParagraphComponentViewModel:
            return ParagraphComponent(viewModel: (viewModel as? ParagraphComponentViewModel)!)
        case is ScreenshotComponentViewModel:
            return ScreenshotComponent(viewModel: (viewModel as? ScreenshotComponentViewModel)!)
        case is SliderComponentViewModel:
            return SliderComponent(viewModel: (viewModel as? SliderComponentViewModel)!)
        default:
            break
        }

        return UIControl()
    }
}
