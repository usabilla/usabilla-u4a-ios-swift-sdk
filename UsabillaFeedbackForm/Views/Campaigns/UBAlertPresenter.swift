//
//  UBAlertPresenter.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBAlertPresenter : UBIntroOutroPresenter {
    
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    private var offset: CGFloat = 0.0
    
    func present(view: UBIntroOutroView, inView: UIView, animations: (()->Void)?) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        
        topConstraint = view.centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: UIScreen.main.bounds.height / 2).activate()
        leftConstraint = view.centerXAnchor.constraint(equalTo: inView.centerXAnchor).activate()
        inView.layoutIfNeeded()
        
        offset = view.bounds.height / 2 + UIScreen.main.bounds.height / 2
        
        topConstraint.constant = offset
        
        inView.layoutIfNeeded()

        CampaignWindow.shared.windowLevel = UIWindowLevelStatusBar
        
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
            self.topConstraint?.constant = 0
            view.alpha = 1
            animations?()
            inView.layoutIfNeeded()
        })
    }
    
    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (()->Void)?, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.33, animations: {
            self.topConstraint?.constant = self.offset
            view.alpha = 0
            animations?()
            inView.layoutIfNeeded()
        }) { _ in
            completion?()
        }
    }
}
