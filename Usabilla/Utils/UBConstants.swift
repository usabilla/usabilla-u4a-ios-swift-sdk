//
//  UBConstants.swift
//  Usabilla
//
//  Created by Anders Liebl on 21/02/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

struct JSONConstant {
    static let data = "data"

    struct Data {
        static let progressBar = "progressBar"
        static let screenShot = "screenshot"
        static let appStoreRedirect = "appStoreRedirect"
        static let version = "version"

        static let appSubmit = "appSubmit"
        static let appTitle = "appTitle"
        static let errorMessage = "errorMessage"
        static let storeIp = "store_ip"
        static let storeLocation = "store_location"
    }
}

struct UBDimensions {
    // UBIntroOutroView
    struct IntroOutroView {
        static let sidesMargin: CGFloat = 16
        static let outsideVerticalMargin: CGFloat = 20
        static let marginBetweenComponentAndTitle: CGFloat = 10
        static let cornerRadius: CGFloat = 8.0
        static let bottomWrapper: CGFloat = 120 // #102,103 *setupWrapper
        static let heightValue: CGFloat = 80 // #184 *setupCustomizations
        static let halfAlpha: CGFloat = 0.5 // #176 *setupCustomizations
    }
    // UBAlertDisplay
    struct AlertDisplay {
        static let widthAnchor: CGFloat = 270
        static let cornerRadius: CGFloat = 14.0
        static let widthAnchorBtnDividerLine: CGFloat = 1.0
        static let heightAnchorHorizontalLine: CGFloat = 1.0
        static let topAnchorHorizontalLine: CGFloat = 0.0
    }
    // UBAlertPresenter
    struct AlertPresenter {
        static let animateDuration: TimeInterval = 0.33
        static let animateDelay: TimeInterval = 0
        static let springDamping: CGFloat = 1
        static let springVelocity: CGFloat = 10
        static let zeroAlpha: CGFloat = 0
        static let fullAlpha: CGFloat = 1
        static let tranformScaleX: CGFloat = 1.2
        static let tranformScaleY: CGFloat = 1.2
    }
    // UBToast
    struct Toast {
        static let opacity: CGFloat = 0.6
        static let margin: CGFloat = 18
        static let duration: Int = 2
        static let labelFont: CGFloat = 18
        static let labelNOL: Int = 0
        static let cornerRadius: CGFloat = 14.0
        static let animateDuration: TimeInterval = 0.33
        static let animateDelay: TimeInterval = 0.5
        static let animateDurationDismiss: TimeInterval = 0.8
        static let widthConstraintWRTMargin: CGFloat = 2
        static let zeroAlpha: CGFloat = 0
        static let fullAlpha: CGFloat = 1
    }
    
    // UBBannerDisplay
    struct BannerDisplay {
        static let topBannerMargin: CGFloat = 10
        static let bannerExtraSpace: CGFloat = 120
        static let topEdgeBtnCancel: CGFloat = 0
        static let leftEdgeBtnCancel: CGFloat = 16
        static let bottomEdgeBtnCancel: CGFloat = 0
        static let rightEdgeBtnCancel: CGFloat = 0
        static let topEdgeBtnContinue: CGFloat = 0
        static let leftEdgeBtnContinue: CGFloat = 16
        static let bottomEdgeBtnContinue: CGFloat = 0
        static let rightEdgeBtnContinue: CGFloat = 16
    
        static let heightAnchorHorizontalLine: CGFloat = 1.0
        static let lineAlpha: CGFloat = 0.1
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.6
        static let shadowColorAlpha: CGFloat = 0.6
        static let widthShadowOffset: CGFloat = 0.0
        static let heightShadowOffset: CGFloat = 1.0
    }
    // UBBannerPresenter
    struct BannerPresenter {
        static let widthTablet: CGFloat = 350.0
        static let widthiPhone: CGFloat = 382
        static let rightOffsetTablet: CGFloat = -25.0
        static let shadowOffset: CGFloat = 5.0
        static let leftConstraint: CGFloat = 16
        static let rightConstraint: CGFloat = 16
        static let animateDurationDismiss: TimeInterval = 0.3
        static let animateDurationDefualt: TimeInterval = 0.7
        static let animateDurationTablet: TimeInterval = 0.5
        static let animateDelay: TimeInterval = 0.0
        static let springDamping: CGFloat = 0.60
        static let springVelocity: CGFloat = 1
    }
}

enum UBToastDuration: Int {
    case short = 1
    case normal = 2
    case long = 4
}
