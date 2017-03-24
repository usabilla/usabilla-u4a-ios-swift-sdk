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

    var coninueLabelText: String? {
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

    var buttonsColor: UIColor {
        return .blue // TO DO update color
    }

    var cancelButtonFont: UIFont {
        if let custom = introPage.themeConfig.customFont {
            return custom.withSize(17)
        }
        return UIFont.systemFont(ofSize: 17, weight: UIFontWeightRegular)
    }

    var continueButtonFont: UIFont {
        if let custom = introPage.themeConfig.customFontBold {
            return custom.withSize(17)
        }
        return UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
    }

    // TO DO add customization attributes

    init(introPage: IntroPageModel) {
        self.introPage = introPage
        field = introPage.fields.first
        if let field = field {
            componentViewModel = ComponentViewModelFactory.component(field: field)
            if displayMode == .alert, let cvm = componentViewModel as? MoodComponentViewModel {
                cvm.centered = true
            }
            return
        }
        componentViewModel = nil
    }
}
