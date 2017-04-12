//
//  CampaignViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignViewModel {

    private var campaign: CampaignModel
    var introPageViewModel: IntroPageViewModel?
    var introPresenter: UBIntroOutroPresenter?

    var formViewModel: UBFormViewModel? {
        guard let formModel = campaign.form else {
            return nil
        }

        let formViewModel = UBFormViewModel(formModel: formModel)
        formViewModel.currentPageViewModel = formViewModel.nextPageViewModel!
        formViewModel.shouldAddMarginWhenKeyboardIsShown = false

        return formViewModel
    }

    init(campaign: CampaignModel) {
        self.campaign = campaign

        // disable giveMoreFeedback for end pages
        campaign.form?.pages.forEach {
            ($0 as? UBEndPageModel)?.giveMoreFeedback = false
        }

        // instanciate the intro pageViewModel
        let introPageModel = campaign.form?.pages.first {
            $0 is IntroPageModel
        }

        if let intro = introPageModel as? IntroPageModel {
            introPageViewModel = IntroPageViewModel(introPage: intro, theme: campaign.form!.theme)

            if introPageViewModel?.displayMode == .alert {
                introPresenter = UBAlertPresenter()
            } else {
                introPresenter = UBBannerPresenter()
            }
        }
    }
}
