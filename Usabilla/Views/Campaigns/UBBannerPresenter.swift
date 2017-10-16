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

    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?) {
        let style = view.viewModel.displayMode

        // iOS 11: this sets the barButtonItem text foreground color in the campaigns window
        UIBarButtonItem.setTextForegroundColor(color: view.viewModel.barButtonItemColor)

        view.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor)
        if DeviceInfo.isIPad() {
            view.widthAnchor.constraint(equalToConstant: kWidthTablet).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: kRightOffsetTablet).activate()
        } else {
            view.leftAnchor.constraint(equalTo: inView.leftAnchor).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor).activate()
        }
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

        UIView.animate(withDuration: 0.3, animations: {
            animations?()
            self.topConstraint.constant = -self.offset
            self.bottomConstraint.constant = self.offset
            inView.layoutIfNeeded()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { _ in
            completion?()
        }
    }
}
