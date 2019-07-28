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
        static let bottomWrapper: CGFloat = 120
        static let heightValue: CGFloat = 80
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
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.6
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
    // UBCameraViewController
    struct UBCameraView {
        static let bottomMarginBtnCamera: CGFloat = -29
        static let bottomMarginPreviewCamera: CGFloat = -29
        static let cameraBtnImageName: String = "camerabtn"
        static let bottomMarginBtnImageLibrary: CGFloat = -38
        static let leftMarginBtnImageLibrary: CGFloat = 16
        static let widthBtnImageLibrary: CGFloat = 48
        static let heightBtnImageLibrary: CGFloat = 48
        static let leftBarBtnText: String = "usa_camera_navbar_left_button"
        static let cornerRadiusBtnImageLibrary: CGFloat = 1

        static let errroViewMargin: CGFloat = 10
        static let errroViewContentMargin: CGFloat = 30
        static let errroViewContentHeight: CGFloat = 20
        static let errroViewDescribtionMaxWidth: CGFloat = UBImagePickerView.errroViewDescribtionMaxWidth
    }

    struct UBEditImageMainView {
        static let imageLeftSideMargin: CGFloat = 7
        static let imageRightSideMargin: CGFloat = -7
        static let imageTopMargin: CGFloat = 8
        static let imageBottomMargin: CGFloat = -84

        static let buttonHeight: CGFloat = 21
        static let buttonWidth: CGFloat = 60

        static let leftButtonLeftMargin: CGFloat = 16
        static let leftButtonBottomMargin: CGFloat = -6

        static let rightButtonRightMargin: CGFloat = -16
        static let rightButtonBottomMargin: CGFloat = -6

        static let doneButtonSpace: CGFloat = 16

        static let titleLabelTopMargin: CGFloat = 24

        static let rightButtonAlpha: CGFloat = UBAlpha.halfAlpha.rawValue
        static let leftButtonAlpha: CGFloat = UBAlpha.halfAlpha.rawValue

        static let leftButtonText: String = "usa_retake_button_title"
        static let rightButtonText: String = "usa_add_button_title"
        static let backButtonText: String = "usa_back_button_title"
        static let addButtonText: String = "usa_add_button_title"
        static let doneButtonText: String = "usa_done_button_title"
        
        static let toolbarHeight: CGFloat = 48
        static let toolbarWidth: CGFloat = 32
        static let toolbarTopMarginHeigth: CGFloat = 30
        static let toolbarBottomMarginHeigth: CGFloat = 7
    }

    struct UBSAEditImageMasterView {
        static let editButtonName: String = "ic_check"
        static let undoButtonName: String = "ic_undo"

        static let bottomMenuHeight: CGFloat = 62.0
        static let bottomMenuAnimationTime: TimeInterval = 0.3
    }
    
    struct PluginViewController {
        static let buttonWidth: CGFloat = 32.0
        static let buttonHeight: CGFloat = 32.0
    }
    struct UBImagePickerView {
        static let imageBorder: CGFloat = 1

        static let numberOfImagesPrRow: CGFloat = 4
        
        static let fallBackNavBarHeigth: CGFloat = 44
        
        static let imageLeftSideMargin: CGFloat = 7
        static let imageRightSideMargin: CGFloat = -7
        static let imageTopMargin: CGFloat = 8
        static let imageBottomMargin: CGFloat = -7

        static let buttonHeight: CGFloat = 21
        static let buttonWidth: CGFloat = 60

        static let leftButtonLeftMargin: CGFloat = 16
        static let leftButtonBottomMargin: CGFloat = -6

        static let rightButtonRightMargin: CGFloat = -16
        static let rightButtonTopMargin: CGFloat = 16

        static let titleLabelTopMargin: CGFloat = 24

        static let collectionLeftSideMargin: CGFloat = 0
        static let collectionRightSideMargin: CGFloat = 1
        static let collectionTopMargin: CGFloat = 8
        static let collectionBottomMargin: CGFloat = 0

        static let headerViewHeight: CGFloat = 50

        static let errroViewMargin: CGFloat = 10
        static let errroViewContentMargin: CGFloat = 30
        static let errroViewContentHeight: CGFloat = 20
        static let errroViewDescribtionMaxWidth: CGFloat = 300
    }

    struct GridHeaderCell {
        static let titleLeftSideMargin: CGFloat = 16
        static let titleRightSideMargin: CGFloat = -8
        static let titleBottomMargin: CGFloat = -8
        static let titleHeigth: CGFloat = 20
    }

    struct GridCell {
        static let imageLeftSideMargin: CGFloat = 0
        static let imageRightSideMargin: CGFloat = -UBImagePickerView.imageBorder
        static let imageBottomMargin: CGFloat = -UBImagePickerView.imageBorder
        static let imageTopMargin: CGFloat = 0
    }

    struct UBSAContainerView {
        static let trashViewTrailingMargin: CGFloat = -20
        static let trashViewBottomMargin: CGFloat = -20
        static let trashViewHeight: CGFloat = 75
        static let trashViewWidth: CGFloat = 44
        static let cornerRadius: CGFloat = 44
    }
}

enum UBAlpha: CGFloat {
    case zeroAlpha = 0.0
    case fullAlpha = 1.0
    case lineAlpha = 0.1
    case shadowColorAlpha = 0.6
    case halfAlpha = 0.5
}
enum UBToastDuration: Int {
    case short = 1
    case normal = 2
    case long = 4
}
