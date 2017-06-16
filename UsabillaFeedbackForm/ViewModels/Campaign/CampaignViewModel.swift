//
//  CampaignViewModel.swift
//  UsabillaFeedbackForm
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

    init(form: FormModel, manager: CampaignSubmissionRequestManagerProtocol) {
        self.form = form
        self.formViewModel = UBFormViewModel(formModel: form)
        self.formViewModel.currentPageViewModel = self.formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)!
        self.formViewModel.shouldAddMarginWhenKeyboardIsShown = false
        self.formViewModel.isCampaignForm = true
        self.manager = manager

        // disable giveMoreFeedback for end pages
        form.pages.forEach {
            ($0 as? UBEndPageModel)?.giveMoreFeedback = false
        }

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

    var toastPageViewModel: UBToastPageViewModel? {
        guard let endPageModel = form.pages[formViewModel.currentPageIndex] as? UBEndPageModel else {
            return nil
        }
        return UBToastPageViewModel(model: endPageModel)
    }

    func pageDidTurn(pageIndex: Int, pageModel: PageModel, nextPageType: PageType) {
        manager.savePage(page: pageModel, nextPageType: nextPageType)
    }
}
