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

    init(campaign: CampaignModel) {
        self.campaign = campaign

        let introPageModel = campaign.form?.pages.first {
            $0 is IntroPageModel
        }

        if let intro = introPageModel as? IntroPageModel {
            introPageViewModel = IntroPageViewModel(introPage: intro)
            
            if introPageViewModel?.displayMode == .alert {
                introPresenter =  UBAlertPresenter()
            } else {
                introPresenter = UBBannerPresenter()
            }
        }
    }
}
