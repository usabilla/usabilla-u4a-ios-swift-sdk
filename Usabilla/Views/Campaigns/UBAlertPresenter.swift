//
//  UBAlertPresenter.swift
//  Usabilla
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBAlertPresenter: UBIntroOutroPresenter {

    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = UBAlpha.zeroAlpha.rawValue

        view.centerYAnchor.constraint(equalTo: inView.centerYAnchor).activate()
        view.centerXAnchor.constraint(equalTo: inView.centerXAnchor).activate()
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar

        view.transform = CGAffineTransform(scaleX: UBDimensions.AlertPresenter.tranformScaleX, y: UBDimensions.AlertPresenter.tranformScaleY)

        UIView.animate(withDuration: UBDimensions.AlertPresenter.animateDuration, delay: UBDimensions.AlertPresenter.animateDelay, usingSpringWithDamping: UBDimensions.AlertPresenter.springDamping, initialSpringVelocity: UBDimensions.AlertPresenter.springVelocity, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform.identity
            view.alpha = UBAlpha.fullAlpha.rawValue
            animations?()
            inView.layoutIfNeeded()
        })
    }

    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?) {
        UIView.animate(withDuration: UBDimensions.AlertPresenter.animateDuration, animations: {
            view.alpha = UBAlpha.zeroAlpha.rawValue
            animations?()
            inView.layoutIfNeeded()
            // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) { _ in
            completion?()
        }
    }
    // protocol requirement
    func updateConstraints(to size: CGSize, orientation: UIInterfaceOrientation) {}
}
