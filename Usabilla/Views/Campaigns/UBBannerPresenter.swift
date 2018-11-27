//
//  UBBannerPresenter.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBBannerPresenter: UBIntroOutroPresenter {

    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!

    private var kWidthTablet: CGFloat = 350.0
    private var kRightOffsetTablet: CGFloat = -25.0
    private var kShadowOffset: CGFloat = 5.0
    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?) {
        let style = view.viewModel.displayMode

        view.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor)

        if DeviceInfo.isIPad() {
            view.widthAnchor.constraint(equalToConstant: kWidthTablet).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: kRightOffsetTablet).activate()
        } else {
            view.leftAnchor.constraint(equalTo: inView.leftAnchor, constant: 16).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: -16).activate()
        }
        inView.layoutIfNeeded()

        offset = view.bounds.height

        topConstraint.constant = -offset
        bottomConstraint.constant = offset

        // activate bottom or top constraint based on banner position
        topConstraint.isActive = style != .bannerBottom
        bottomConstraint.isActive = style == .bannerBottom
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar - 1
        UIView.animate(withDuration: 0.40, delay: 0.0, usingSpringWithDamping: 0.60, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            self.topConstraint.constant = (style == .bannerTop ? DeviceInfo.topMargin : self.topConstraint.constant)
            self.bottomConstraint.constant = (style == .bannerTop ? self.bottomConstraint.constant : -DeviceInfo.bottomMargin)
            inView.layoutIfNeeded()
        })
    }

    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?) {

        UIView.animate(withDuration: 0.3, animations: {
            animations?()
            self.topConstraint.constant = -self.offset - self.kShadowOffset
            self.bottomConstraint.constant = self.offset + self.kShadowOffset

            inView.layoutIfNeeded()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { _ in
            completion?()
        }
    }
}
