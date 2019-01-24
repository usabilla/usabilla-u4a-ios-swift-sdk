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
    private var kWidthiPhone: CGFloat = 382
    private var kRightOffsetTablet: CGFloat = -25.0
    private var kShadowOffset: CGFloat = 5.0
    private weak var inView: UIView?
    private weak var introView: UBIntroOutroView?

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?

    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?) {
        let style = view.viewModel.displayMode
        self.inView = inView
        self.introView = view
        view.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor)

        if DeviceInfo.isIPad() {
            view.widthAnchor.constraint(equalToConstant: kWidthTablet).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: kRightOffsetTablet).activate()
        } else {
            setConstraints()
        }
        inView.layoutIfNeeded()

        topConstraint.constant = -offset
        bottomConstraint.constant = offset

        // activate bottom or top constraint based on banner position
        topConstraint.isActive = style != .bannerBottom
        bottomConstraint.isActive = style == .bannerBottom
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar - 1
        // Design requested slower animation on ipad
        let animationTime = (DeviceInfo.isIPad() ? 0.5 : 0.7)
        UIView.animate(withDuration: animationTime, delay: 0.0, usingSpringWithDamping: 0.60, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

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

    func updateConstraints(to size: CGSize, orientation: UIInterfaceOrientation) {
        if size.width > size.height {
            setConstraintsForLandscape(orientation)
            return
        }
        setConstraintsForPortrait()
    }

    private func setConstraints() {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight {
            setConstraintsForLandscape(orientation)
            return
        }
        setConstraintsForPortrait()
    }

    private func setConstraintsForPortrait() {
        guard let superview = inView, let aView = introView else {
            return
        }
        rightConstraint?.isActive = false
        rightConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -16)
        rightConstraint?.isActive = true

        widthConstraint?.isActive  = false

        leftConstraint?.isActive = false
        leftConstraint = aView.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 16)
        leftConstraint?.isActive = true
        superview.updateConstraints()
    }

    private func setConstraintsForLandscape(_ orientation: UIInterfaceOrientation) {
        guard let superview = inView, let aView = introView else {
            return
        }
        rightConstraint?.isActive = false
        leftConstraint?.isActive = false
        var offset: CGFloat = 16
        if orientation == .landscapeLeft {
            offset = DeviceInfo.offsetRightNotch
        }
        rightConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -offset)
        rightConstraint?.isActive = true

        widthConstraint = aView.widthAnchor.constraint(equalToConstant: kWidthiPhone)
        widthConstraint?.isActive  = true
        superview.updateConstraints()
    }
}
