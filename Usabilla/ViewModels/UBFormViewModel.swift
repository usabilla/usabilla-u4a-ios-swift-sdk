//
//  UBFormViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 03/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBFormViewModel {

    private(set) var model: FormModel
    private(set) var currentPageIndex: Int
    private var pageViewModels: [PageViewModel]
    var isCampaignForm: Bool = false

    let shouldAddMarginWhenKeyboardIsShown: Bool
    var id: String {
        return model.identifier
    }
    var shouldHideProgressBar: Bool {
        return model.pages.count == 2 || !model.showProgressBar
    }
    var progress: Float {
        return Float(currentPageIndex + 1) / Float(model.pages.count)
    }
    var accentColor: UIColor {
        return model.theme.colors.accent
    }
    var backgrounColor: UIColor {
        return model.theme.colors.background
    }
    var statusBarColor: UIStatusBarStyle {
        return model.theme.statusBarStyle
    }
    var headerColor: UIColor {
        if let headerColor = model.theme.colors.header {
            return headerColor
        }

        return model.theme.colors.accent
    }
    var textOnAccentColor: UIColor {
        return model.theme.colors.textOnAccent
    }
    var navigationBarTitle: String? {
        return model.copyModel.appTitle
    }
    var cancelButtonTitle: String? {
        return model.copyModel.cancelButton
    }
    var navBarItemsFont: UIFont {
        return model.theme.fonts.boldFont
    }
    var isCurrentPageValid: Bool {
        return pageViewModels[currentPageIndex].isCorrectlyFilled
    }
    var firstPageViewModel: PageViewModel? {
        return pageViewModels.first
    }
    var rightBarButtonTitle: String? {
        if currentPageIndex == model.pages.count - 2 {
            return model.copyModel.navigationSubmit
        } else if currentPageIndex == model.pages.count - 1 {
            return nil
        }

        return model.copyModel.navigationNext
    }
    var currentPageViewModel: PageViewModel {
        get {
            return pageViewModels[currentPageIndex]
        }

        set {
            currentPageIndex = pageViewModels.index(where: {
                $0.name == newValue.name
            })!
        }
    }
    var endPageViewModel: UBEndPageViewModel? {
        guard let endPageModel = model.pages[currentPageIndex] as? UBEndPageModel else {
            return nil
        }
        let moodValue = model.pages.first?.fields[0] as? IntFieldModel

        let endPageViewModel = UBEndPageViewModel(model: endPageModel, theme: model.theme)
        var rating: Int = 0
        if let moodRating = moodValue?.fieldValue {
            rating = moodRating
        }
        endPageViewModel.formRating = rating

        return endPageViewModel
    }
    var nextPageIndex: Int {
        var newPageIndex = -1
        if let pageToJump = pageViewModels[currentPageIndex].nextPageName() {
            for (index, page) in model.pages.enumerated() where page.pageName == pageToJump {
                newPageIndex = index
            }
        }
        if newPageIndex == -1 {
            newPageIndex = currentPageIndex + 1
        }

        return newPageIndex
    }
    var isItTheEnd: Bool {
        let pageType = model.pages[currentPageIndex].type
        return pageType == .end || pageType == .toast
    }

    init(formModel: FormModel, shouldAddMarginWhenKeyboardIsShown: Bool = true) {
        self.model = formModel
        self.currentPageIndex = 0
        self.pageViewModels = []
        self.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
        model.pages.forEach {
            let vm = PageViewModel(page: $0, theme: model.theme)
            vm.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
            self.pageViewModels.append(vm)
        }
    }

    func pageViewModel(atIndex: Int) -> PageViewModel {
        return pageViewModels[atIndex]
    }

    func reset() {
        let theme = model.theme
        self.model = FormModel(json: model.formJsonString, id: model.identifier, screenshot: nil)
        self.model.theme = theme
        self.model.updateTheme()
        self.currentPageIndex = 0
        self.pageViewModels = []

        model.pages.forEach {
            let vm = PageViewModel(page: $0, theme: model.theme)
            vm.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
            self.pageViewModels.append(vm)
        }
    }

    func containsIndex(index: Int) -> Bool {
        return index >= 0 && index < model.pages.count
    }

    func goToLastPageIndex() {
        currentPageIndex = model.pages.count - 1
    }
}
