//
//  UBBannerPresenter.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBBannerPresenter: UBIntroOutroPresenter {

    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!

    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?) {
        let style = view.viewModel.displayMode
        view.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor)
        leftConstraint = view.leftAnchor.constraint(equalTo: inView.leftAnchor).activate()
        rightConstraint = view.rightAnchor.constraint(equalTo: inView.rightAnchor).activate()
        inView.layoutIfNeeded()

        offset = view.bounds.height
        topConstraint.constant = -offset
        bottomConstraint.constant = offset - UBBannerDisplay.kBannerExtraSpace

        // activate bottom or top constraint based on banner position
        topConstraint.isActive = style != .bannerBottom
        bottomConstraint.isActive = style == .bannerBottom
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar - 1

        UIView.animate(withDuration: 0.40, delay: 0.0, usingSpringWithDamping: 0.40, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.topConstraint.constant = -UBBannerDisplay.kBannerExtraSpace
            self.bottomConstraint.constant = UBBannerDisplay.kBannerExtraSpace
            inView.layoutIfNeeded()
        })
    }

    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?) {

        UIView.animate(withDuration: 0.15, animations: {
            animations?()
            self.topConstraint.constant = -self.offset
            self.bottomConstraint.constant = self.offset
            inView.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
