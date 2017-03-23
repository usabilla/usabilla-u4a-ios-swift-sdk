//
//  UBBannerPresenter.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBBannerPresenter: UBIntroOutroPresenter {

    var topConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?

    func present(view: IntroOutroView, inView: UIView) {

        let style = view.viewModel.displayMode

        let bannerView = view
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.alpha = 0
        topConstraint = bannerView.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = bannerView.bottomAnchor.constraint(equalTo: inView.bottomAnchor)
        leftConstraint = bannerView.leftAnchor.constraint(equalTo: inView.leftAnchor).activate()
        rightConstraint = bannerView.rightAnchor.constraint(equalTo: inView.rightAnchor).activate()
        bannerView.layoutIfNeeded()

        let offset = bannerView.bounds.height
        topConstraint?.constant = -offset
        bottomConstraint?.constant = offset

        topConstraint?.isActive = style != .bannerBottom
        bottomConstraint?.isActive = style == .bannerBottom
        bannerView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar - 1

        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.topConstraint?.constant = 0
            self.bottomConstraint?.constant = 0
            bannerView.alpha = 1
            view.layoutIfNeeded()
        }) { _ in
        }
    }
}
