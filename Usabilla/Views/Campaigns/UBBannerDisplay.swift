//
//  UBBannerDisplay.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol UBIntroOutroDisplay {
    static func build(view: UBIntroOutroView)
}

class UBBannerDisplay: UBIntroOutroDisplay {
    private static let topBannerMargin: CGFloat = 10
    static let kBannerExtraSpace: CGFloat = 120

    static func build(view: UBIntroOutroView) {
        view.buttonsStackView?.axis = .horizontal

        buildShadow(view)
        buildHorizontaleLine(view)
        configureMargins(view)

        guard view.viewModel.hasContinueButton else {
            view.cancelButton.contentHorizontalAlignment = .center
            return
        }
        configureWithContinueButton(view)
    }

    static private func configureMargins(_ view: UBIntroOutroView) {
        if view.viewModel.displayMode == .bannerBottom {
            view.buttonsStackViewBottomContraint?.constant -= kBannerExtraSpace
        } else { // display banner top
            view.titleTopConstraint?.constant += UBBannerDisplay.topBannerMargin + kBannerExtraSpace
        }
    }

    static private func buildShadow(_ view: UBIntroOutroView) {
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: view.viewModel.displayMode == .bannerBottom ? -1.0 : 1.0)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 4
    }

    static private func buildHorizontaleLine(_ view: UBIntroOutroView) {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line)
        line.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        line.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        line.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        line.topAnchor.constraint(equalTo: view.buttonsStackView.topAnchor).activate()
        line.heightAnchor.constraint(equalToConstant: 1.0).activate()
    }

    static private func configureWithContinueButton(_ view: UBIntroOutroView) {
        view.cancelButton.contentHorizontalAlignment = .left
        view.cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        view.continueButton?.contentHorizontalAlignment = .right
        view.continueButton?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
