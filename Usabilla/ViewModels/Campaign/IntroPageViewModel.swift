//
//  IntroPageViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class IntroPageViewModel {

    let introPage: IntroPageModel
    private let field: BaseFieldModel?
    private let theme: UsabillaTheme

    var componentViewModel: ComponentViewModel?
    var cancelLabelText: String? {
        // swiftlint:disable:next force_unwrapping
        return introPage.copy!.introCancelButton
    }
    var hasContinueButton: Bool {
        return introPage.hasContinueButton
    }
    var continueLabelText: String? {
        // swiftlint:disable:next force_unwrapping
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
        return theme.colors.cardColor
    }
    var titleColor: UIColor {
        return theme.colors.title
    }
    var hintColor: UIColor {
        return theme.colors.hint
    }
    var buttonColor: UIColor {
        return theme.colors.accent
    }
    var cancelButtonColor: UIColor {
        return theme.colors.text
    }

    var barButtonItemColor: UIColor {
        return theme.colors.textOnAccent
    }
    var font: UIFont {
        return theme.fonts.font
    }
    var boldFont: UIFont {
        return theme.fonts.boldFont
    }

    // TO DO add customization attributes

    init(introPage: IntroPageModel, theme: UsabillaTheme) {
        self.introPage = introPage
        self.theme = theme
        field = introPage.fields.first
        if let field = field {

            // skip component view model creation if it is a paragraph with an empty content
            if let paragraph = (field as? ParagraphFieldModel)?.fieldValue, paragraph.isEmpty {
                componentViewModel = nil
                return
            }

            // create component view model
            guard let copy = introPage.copy else {
                componentViewModel = nil
                return
            }
            componentViewModel = ComponentViewModelFactory.component(field: field, theme: theme, copy: copy)
            componentViewModel?.delegate = self
            if displayMode == .alert, var cvm = componentViewModel as? Centerable {
                cvm.isCentered = true
            }
            return
        }
        componentViewModel = nil
    }
}

extension IntroPageViewModel: ComponentViewModelDelegate {
    func valueDidChange() {
        guard let model = introPage.fields.first else {
            return
        }
        guard let value = model.serialiazedValue else {
            self.introPage.fieldValuesCollection.removeValue(forKey: model.fieldID)
            return
        }
        self.introPage.fieldValuesCollection[model.fieldID] = value
    }
}
