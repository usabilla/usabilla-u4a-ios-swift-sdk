//
//  UBFormViewModel.swift
//  UsabillaFeedbackForm
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

    var shouldAddMarginWhenKeyboardIsShown: Bool = true

    var id: String {
        return model.appId
    }

    var shouldHideProgressBar: Bool {
        return model.pages.count == 2 || !model.showProgressBar
    }

    var progress: Float {
        return Float(currentPageIndex + 1) / Float(model.pages.count)
    }

    var accentColor: UIColor {
        return model.theme.accentColor
    }

    var backgrounColor: UIColor {
        return model.theme.backgroundColor
    }

    var statusBarColor: UIStatusBarStyle {
        return model.theme.statusBarColor
    }

    var headerColor: UIColor {
        if let headerColor = model.theme.headerColor {
            return headerColor
        }

        return model.theme.accentColor
    }

    var textOnAccentColor: UIColor {
        return model.theme.textOnAccentColor
    }

    var cancelButtonTitle: String? {
        return showCancelButton ? model.copyModel.cancelButton : nil
    }

    var navBarItemsFont: UIFont {
        return model.theme.boldFont
    }

    var showCancelButton: Bool {
        return UsabillaFeedbackForm.showCancelButton // TO DO inject
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
        endPageModel.redirectToAppStore = model.redirectToAppStore
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

    func pageViewModel(atIndex: Int) -> PageViewModel {
        return pageViewModels[atIndex]
    }

    var isItTheEnd: Bool {
        let pageType = model.pages[currentPageIndex].type
        return pageType == .end || pageType == .toast
    }

    init(formModel: FormModel) {
        self.model = formModel
        self.currentPageIndex = 0
        self.pageViewModels = []

        model.pages.forEach {
            let vm = PageViewModel(page: $0, theme: model.theme)
            self.pageViewModels.append(vm)
        }
    }

    func reset() {
        let theme = model.theme
        self.model = FormModel(json: model.formJsonString, id: model.appId, screenshot: nil)
        self.model.theme = theme
        self.model.updateTheme()
        self.currentPageIndex = 0
        self.pageViewModels = []

        model.pages.forEach {
            let vm = PageViewModel(page: $0, theme: model.theme)
            self.pageViewModels.append(vm)
        }
    }
}
