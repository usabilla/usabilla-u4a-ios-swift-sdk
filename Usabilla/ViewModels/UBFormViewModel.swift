//
//  UBFormViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 03/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

enum UBFormButtonType {
    case cancel
    case next
    case submit
}

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
        // for campaigns startpage is second page; index 1,
        // for forms startpage is first index 0, hence add 1
        let calculatedStartPage = Float(currentPageIndex + (isCampaignForm ? 0 : 1) )
        // for campaings number of pages are 2 lees than count (no banner & end page)
        // for forms number of pages are 1 less than count (no end page)
        let calculatedNumberOfPages = Float((model.pages.count-(isCampaignForm ? 2 : 1)))
        return  calculatedStartPage / calculatedNumberOfPages
    }
    var accentColor: UIColor {
        return model.theme.colors.accent
    }
    var backgrounColor: UIColor {
        return model.theme.colors.background
    }
    var statusBarColor: UIStatusBarStyle? {
        return isCampaignForm ? nil : model.theme.statusBarStyle
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
    var navBarItemsFontBold: UIFont {
        return model.theme.fonts.boldFont
    }
    var navBarItemsFontNormal: UIFont {
        return model.theme.fonts.font
    }
    var isCurrentPageValid: Bool {
        return pageViewModels[currentPageIndex].isCorrectlyFilled
    }
    var firstPageViewModel: PageViewModel? {
        return pageViewModels.first
    }
    var submitText: String? {
        return model.copyModel.navigationSubmit
    }
    var nextText: String? {
        return model.copyModel.navigationNext
    }
    var cancelText: String? {
        return model.copyModel.cancelButton
    }
    var leftBarButtonType: UBFormButtonType? {
        return self.isItTheEnd ? nil : .cancel
    }
    var rightBarButtonType: UBFormButtonType {
        if isItTheEnd {
            return .cancel
        }
        if isNextPageAnEndPage {
            return .submit
        }
        return .next
    }
    private var isNextPageAnEndPage: Bool {
        let index = currentPageIndex + 1
        guard index >= 0 && index < model.pages.count else {
            return false
        }
        return model.pages[index].type.final
    }
    var currentPageViewModel: PageViewModel {
        get {
            return pageViewModels[currentPageIndex]
        }

        set {
            currentPageIndex = pageViewModels.index(where: {
                $0.name == newValue.name
                // swiftlint:disable:next force_unwrapping
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
        return model.pages[currentPageIndex].type.final
    }

    init(formModel: FormModel, shouldAddMarginWhenKeyboardIsShown: Bool = true) {
        self.model = formModel
        self.currentPageIndex = 0
        self.pageViewModels = []
        self.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
        model.pages.forEach {
            let pageViewModel = PageViewModel(page: $0, theme: model.theme)
            pageViewModel.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
            self.pageViewModels.append(pageViewModel)
        }
    }

    func pageViewModel(atIndex: Int) -> PageViewModel {
        return pageViewModels[atIndex]
    }

    func reset() {
        let theme = model.theme
        // swiftlint:disable:next force_unwrapping
        self.model = FormModel(json: model.formJsonString, id: model.identifier, screenshot: nil, maskModel: nil)!
        self.model.theme = theme
        self.model.updateTheme()
        self.currentPageIndex = 0
        self.pageViewModels = []

        model.pages.forEach {
            let pageViewModel = PageViewModel(page: $0, theme: model.theme)
            pageViewModel.shouldAddMarginWhenKeyboardIsShown = shouldAddMarginWhenKeyboardIsShown
            self.pageViewModels.append(pageViewModel)
        }
    }

    func containsIndex(index: Int) -> Bool {
        return index >= 0 && index < model.pages.count
    }

    func goToLastPageIndex() {
        currentPageIndex = model.pages.count - 1
    }
}
