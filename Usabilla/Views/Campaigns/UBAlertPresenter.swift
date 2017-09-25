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
        view.alpha = 0

        view.centerYAnchor.constraint(equalTo: inView.centerYAnchor).activate()
        view.centerXAnchor.constraint(equalTo: inView.centerXAnchor).activate()
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar

        view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            view.transform = CGAffineTransform.identity
            view.alpha = 1
            animations?()
            inView.layoutIfNeeded()
        })
    }

    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.33, animations: {
            view.alpha = 0
            animations?()
            inView.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
