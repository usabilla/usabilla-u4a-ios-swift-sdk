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

    var centerXConstraint: NSLayoutConstraint!
    var centerYConstraint: NSLayoutConstraint!

    private var kWidthTablet = UBDimensions.BannerPresenter.widthTablet
    private var kWidthiPhone = UBDimensions.BannerPresenter.widthiPhone
    private var kRightOffsetTablet = UBDimensions.BannerPresenter.rightOffsetTablet
    private var kShadowOffset = UBDimensions.BannerPresenter.shadowOffset
    private weak var inView: UIView?
    private weak var introView: UBIntroOutroViewProtocol?

    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?

    var offset: CGFloat = 0.0

    func present(view: UBIntroOutroViewProtocol?, inView: UIView?, animations: (() -> Void)?) {
        guard let view = view, let inView = inView else {return}
        let style = view.viewModel.displayMode
        self.inView = inView
        self.introView = view
        view.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = view.topAnchor.constraint(equalTo: inView.topAnchor).activate()
        bottomConstraint = view.bottomAnchor.constraint(equalTo: inView.bottomAnchor).activate()

        if view.nativeBanner {
        rightConstraint = view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: -UBDimensions.BannerPresenter.rightConstraint).activate()
        leftConstraint = view.leftAnchor.constraint(equalTo: inView.leftAnchor, constant: UBDimensions.BannerPresenter.leftConstraint).activate()
        } else {
            rightConstraint = view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: 0).activate()
            leftConstraint = view.leftAnchor.constraint(equalTo: inView.leftAnchor, constant: 0).activate()

        }
        /*if DeviceInfo.isIPad() {
            view.widthAnchor.constraint(equalToConstant: kWidthTablet).activate()
            view.rightAnchor.constraint(equalTo: inView.rightAnchor, constant: kRightOffsetTablet).activate()
        } else {
            setConstraints()
        }
         */
        inView.layoutIfNeeded()

        if view.nativeBanner {
            topConstraint.constant = -offset
            bottomConstraint.constant = offset
            topConstraint.isActive = style != .bannerBottom
            bottomConstraint.isActive = style == .bannerBottom
        }
        inView.layoutIfNeeded()

        CampaignWindow.shared.setWindowLevel(UIWindowLevelStatusBar - 1)
        // Design requested slower animation on ipad
        let animationTime = (DeviceInfo.isIPad() ? UBDimensions.BannerPresenter.animateDurationTablet : UBDimensions.BannerPresenter.animateDurationDefualt)
        UIView.animate(withDuration: animationTime, delay: UBDimensions.BannerPresenter.animateDelay, usingSpringWithDamping: UBDimensions.BannerPresenter.springDamping, initialSpringVelocity: UBDimensions.BannerPresenter.springVelocity, options: .curveEaseOut, animations: { [weak self] in
            if view.nativeBanner {
                self?.topConstraint.constant = (style == .bannerTop ? DeviceInfo.topMargin : (self?.topConstraint.constant ?? 0.0))
                self?.bottomConstraint.constant = (style == .bannerTop ? (self?.bottomConstraint.constant ?? 0.0) : -DeviceInfo.bottomMargin)
            }
            inView.layoutIfNeeded()
        })
       // setFixedConstraints()

    }

    func dismiss(view: UBIntroOutroViewProtocol?, inView: UIView?, animations: (() -> Void)?, completion: (() -> Void)?) {
        let bannerViewHeigth = (view?.frame.size.height ?? 0.0)
        UIView.animate(withDuration: UBDimensions.BannerPresenter.animateDurationDismiss, animations: { [weak self] in
            animations?()
            self?.topConstraint.constant =  -(bannerViewHeigth  + (self?.offset ?? 0.0) + (self?.kShadowOffset ?? 0.0))
            self?.bottomConstraint.constant = bannerViewHeigth + (self?.offset ?? 0.0) + (self?.kShadowOffset ?? 0.0)

            inView?.layoutIfNeeded()
        }, completion: { _ in
            completion?()
        })
    }

    private func setFixedConstraints() {
        if UsabillaInternal.supportedOrientations == .landscapeLeft {
            setConstraintsForLandscape(.landscapeLeft)
            return
        }
        if UsabillaInternal.supportedOrientations == .landscapeRight {
            setConstraintsForLandscape(.landscapeRight)
            return
        }
        if UsabillaInternal.supportedOrientations == .portrait ||
            UsabillaInternal.supportedOrientations == .portraitUpsideDown {
            setConstraintsForPortrait()
            return
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
        widthConstraint?.isActive  = false
        leftConstraint?.isActive = false

        if aView.nativeBanner {
            leftConstraint = aView.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: UBDimensions.BannerPresenter.leftConstraint)
            rightConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -UBDimensions.BannerPresenter.rightConstraint)
        } else {
            leftConstraint = aView.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 0)
            rightConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: 0)
        }

        rightConstraint?.isActive = true
        leftConstraint?.isActive = true
        superview.updateConstraints()
    }

    private func setConstraintsForLandscape(_ orientation: UIInterfaceOrientation) {
        guard let superview = inView, let aView = introView else {
            return
        }
        rightConstraint?.isActive = false
        leftConstraint?.isActive = false
        widthConstraint?.isActive  = false
        if aView.nativeBanner {
            var offset: CGFloat = 16
            if orientation == .landscapeLeft {
                offset = DeviceInfo.offsetRightNotch
            }
            let theConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -offset)
            rightConstraint? = theConstraint
            widthConstraint = aView.widthAnchor.constraint(equalToConstant: kWidthiPhone)
        } else {
            leftConstraint = aView.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 0)
            rightConstraint = aView.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: 0)
            leftConstraint?.isActive = true
        }
        widthConstraint?.isActive  = true
        rightConstraint?.isActive = true

        superview.updateConstraints()
    }
}
