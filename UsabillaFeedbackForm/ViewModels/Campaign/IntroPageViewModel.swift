//
//  IntroPageViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class IntroPageViewModel {

    private let introPage: IntroPageModel
    private let field: BaseFieldModel?

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

    var title: String? {
        return field?.fieldTitle
    }

    var displayMode: IntroPageDisplayMode {
        return introPage.displayMode
    }

    var backgroundColor: UIColor {
        return introPage.themeConfig.backgroundColor
    }

    var titleColor: UIColor {
        return introPage.themeConfig.titleColor
    }

    var hintColor: UIColor {
        return introPage.themeConfig.hintColor
    }

    var accentColor: UIColor {
        return introPage.themeConfig.accentColor
    }

    var font: UIFont {
        return introPage.themeConfig.font
    }

    var boldFont: UIFont {
        return introPage.themeConfig.boldFont
    }

    // TO DO add customization attributes

    init(introPage: IntroPageModel) {
        self.introPage = introPage
        field = introPage.fields.first
        if let field = field {

            // skip component view model creation if it is an header with an empty content
            if let headerContent = (field as? HeaderFieldModel)?.fieldValue, headerContent.isEmpty {
                componentViewModel = nil
                return
            }

            // create component view model
            componentViewModel = ComponentViewModelFactory.component(field: field)
            if displayMode == .alert, var cvm = componentViewModel as? Centerable {
                cvm.isCentered = true
            }
            return
        }
        componentViewModel = nil
    }
}
