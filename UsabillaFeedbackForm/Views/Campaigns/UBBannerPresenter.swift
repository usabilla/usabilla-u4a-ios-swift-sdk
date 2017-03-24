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

    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroView, inView: UIView) {
        let style = view.viewModel.displayMode
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor)
        leftConstraint = view.leftAnchor.constraint(equalTo: inView.leftAnchor).activate()
        rightConstraint = view.rightAnchor.constraint(equalTo: inView.rightAnchor).activate()
        inView.layoutIfNeeded()

        offset = view.bounds.height
        topConstraint?.constant = -offset
        bottomConstraint?.constant = offset

        // activate bottom or top constraint based on banner position
        topConstraint?.isActive = style != .bannerBottom
        bottomConstraint?.isActive = style == .bannerBottom
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar - 1

        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.topConstraint?.constant = 0
            self.bottomConstraint?.constant = 0
            view.alpha = 1
            inView.layoutIfNeeded()
        })
    }

    func dismiss(view: UBIntroOutroView, inView: UIView, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.topConstraint?.constant = -self.offset
            self.bottomConstraint?.constant = self.offset
            view.alpha = 0
            inView.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
