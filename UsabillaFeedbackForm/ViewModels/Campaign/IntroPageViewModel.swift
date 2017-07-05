//
//  IntroPageViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class IntroPageViewModel {

    let introPage: IntroPageModel
    private let field: BaseFieldModel?
    private let theme: UsabillaTheme

    let componentViewModel: ComponentViewModel?

    var cancelLabelText: String? {
        return introPage.copy!.introCancelButton
    }

    var hasContinueButton: Bool {
        return introPage.hasContinueButton
    }

    var continueLabelText: String? {
        return introPage.copy!.introContinueButton
    }

    var canContinue: Bool {
        return introPage.fields.first?.isValid() ?? false
    }

    var title: String? {
        return field?.fieldTitle
    }

    var displayMode: IntroPageDisplayMode {
        return introPage.displayMode
    }

    var backgroundColor: UIColor {
        return theme.backgroundColor
    }

    var titleColor: UIColor {
        return theme.titleColor
    }

    var hintColor: UIColor {
        return theme.hintColor
    }

    var buttonColor: UIColor {
        return theme.accentColor
    }

    var font: UIFont {
        return theme.font
    }

    var boldFont: UIFont {
        return theme.boldFont
    }

    // TO DO add customization attributes

    init(introPage: IntroPageModel, theme: UsabillaTheme) {
        self.introPage = introPage
        self.theme = theme
        field = introPage.fields.first
        if let field = field {

            // skip component view model creation if it is an header with an empty content
            if let headerContent = (field as? HeaderFieldModel)?.fieldValue, headerContent.isEmpty {
                componentViewModel = nil
                return
            }

            // create component view model
            componentViewModel = ComponentViewModelFactory.component(field: field, theme: theme)
            if displayMode == .alert, var cvm = componentViewModel as? Centerable {
                cvm.isCentered = true
            }
            return
        }
        componentViewModel = nil
    }
}
