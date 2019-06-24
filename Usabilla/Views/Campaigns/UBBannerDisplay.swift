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
    private static let topBannerMargin: CGFloat = UBDimensions.BannerDisplay.topBannerMargin
    static let kBannerExtraSpace: CGFloat = UBDimensions.BannerDisplay.kBannerExtraSpace

    static func build(view: UBIntroOutroView) {
        view.accessibilityIdentifier = "banner"
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
        view.layer.shadowColor = UIColor.black.withAlphaComponent(UBDimensions.BannerDisplay.shadowColorAlpha).cgColor
        view.layer.shadowOffset = CGSize(width: UBDimensions.BannerDisplay.widthShadowOffset, height: view.viewModel.displayMode == .bannerBottom ? -UBDimensions.BannerDisplay.heightShadowOffset : UBDimensions.BannerDisplay.heightShadowOffset)
        view.layer.shadowOpacity = UBDimensions.BannerDisplay.shadowOpacity
        view.layer.shadowRadius = UBDimensions.BannerDisplay.shadowRadius
    }

    static private func buildHorizontaleLine(_ view: UBIntroOutroView) {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line)
        line.backgroundColor = UIColor.black.withAlphaComponent(UBDimensions.BannerDisplay.lineAlpha)
        line.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        line.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        line.topAnchor.constraint(equalTo: view.buttonsStackView.topAnchor).activate()
        line.heightAnchor.constraint(equalToConstant: UBDimensions.BannerDisplay.heightAnchorHorizontalLine).activate()
    }

    static private func configureWithContinueButton(_ view: UBIntroOutroView) {
        view.cancelButton.contentHorizontalAlignment = .left
        view.cancelButton.contentEdgeInsets = UIEdgeInsets(top: UBDimensions.BannerDisplay.topEdgeBtnCancel, left: UBDimensions.BannerDisplay.leftEdgeBtnCancel, bottom: UBDimensions.BannerDisplay.bottomEdgeBtnCancel, right: UBDimensions.BannerDisplay.rightEdgeBtnCancel)

        view.continueButton?.contentHorizontalAlignment = .right
        view.continueButton?.contentEdgeInsets = UIEdgeInsets(top: UBDimensions.BannerDisplay.topEdgeBtnContinue, left: UBDimensions.BannerDisplay.leftEdgeBtnContinue, bottom: UBDimensions.BannerDisplay.bottomEdgeBtnContinue, right: UBDimensions.BannerDisplay.rightEdgeBtnContinue)
    }
}
