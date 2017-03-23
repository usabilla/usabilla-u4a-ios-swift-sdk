//
//  UBBannerDisplay.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


protocol UBIntroOutroDisplay {
    static func build(view: IntroOutroView)
    static func update(view: IntroOutroView)
}

class UBBannerDisplay: UBIntroOutroDisplay {
    private static let topBannerMargin: CGFloat = 10
    
    static func build(view: IntroOutroView) {
        view.buttonsStackView?.axis = .horizontal

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        view.buttonsStackView?.addSubview(line)
        line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        line.rightAnchor.constraint(equalTo: view.buttonsStackView.rightAnchor).activate()
        line.leftAnchor.constraint(equalTo: view.buttonsStackView.leftAnchor).activate()
        line.topAnchor.constraint(equalTo: view.buttonsStackView.topAnchor, constant: 0.0).activate()
        line.heightAnchor.constraint(equalToConstant: 1.0).activate()
        view.buttonsStackView?.clipsToBounds = true
        
        guard view.viewModel.hasContinueButton else {
            view.cancelButton.contentHorizontalAlignment = .center
            return
        }
        view.cancelButton.contentHorizontalAlignment = .left
        view.cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        view.continueButton!.contentHorizontalAlignment = .right
        view.continueButton!.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        if view.viewModel.displayMode != .bannerBottom {
            view.titleTopConstraint?.constant += UBBannerDisplay.topBannerMargin
        }


    }

    static func update(view: IntroOutroView) {
        let path = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowPath = path.cgPath
        view.layer.shadowRadius = 4
    }
}
