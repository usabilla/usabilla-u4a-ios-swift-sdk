//
//  CampaignViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignViewModel {
    var form: FormModel
    var introPageViewModel: IntroPageViewModel?
    var introPresenter: UBIntroOutroPresenter?
    let manager: CampaignSubmissionRequestManagerProtocol
    var formViewModel: UBFormViewModel

    init(form: FormModel, displayMode: IntroPageDisplayMode = .bannerBottom, manager: CampaignSubmissionRequestManagerProtocol) {
        self.form = form
        let shouldAddMargins: Bool = DeviceInfo.isIPad() ? true : false
        self.formViewModel = UBFormViewModel(formModel: form, shouldAddMarginWhenKeyboardIsShown: shouldAddMargins)
        self.formViewModel.currentPageViewModel = self.formViewModel.pageViewModel(atIndex: 0)
        self.formViewModel.isCampaignForm = true
        self.manager = manager

        // instanciate the intro pageViewModel
        let introPageModel = form.pages.first {
            $0 is IntroPageModel
        }

        if let intro = introPageModel as? IntroPageModel {
            introPageViewModel = IntroPageViewModel(introPage: intro, theme: form.theme)

            if introPageViewModel?.displayMode == .alert {
                introPresenter = UBAlertPresenter()
            } else {
                introPresenter = UBBannerPresenter()
            }
        }
    }

    var currentPageType: PageType? {
        return formViewModel.currentPageViewModel.model.type
    }

    var toastPageViewModel: UBToastPageViewModel? {
        guard let endPageModel = form.pages[formViewModel.currentPageIndex] as? UBEndPageModel else {
            return nil
        }
        return UBToastPageViewModel(model: endPageModel)
    }

    var ratingValueForReview: Int? {
        let fields = form.pages.flatMap { $0.fields }
        let rating = fields.first {
            type(of: $0) == MoodFieldModel.self
            } as? IntFieldModel
        return rating?.fieldValue
    }

    func introViewDidContinue() {
        let nextIndex = formViewModel.nextPageIndex
        let nextPageViewModel = pageViewModel(atIndex: nextIndex)
        formViewModel.currentPageViewModel = nextPageViewModel
        // swiftlint:disable:next force_unwrapping
        pageDidTurn(pageIndex: 0, pageModel: introPageViewModel!.introPage, nextPageType: nextPageViewModel.model.type)
    }

    func pageDidTurn(pageIndex: Int, pageModel: PageModel, nextPageType: PageType) {
        manager.savePage(page: pageModel, nextPageType: nextPageType)
    }

    func pageViewModel(atIndex index: Int) -> PageViewModel {
        return formViewModel.pageViewModel(atIndex: index)
    }
}
