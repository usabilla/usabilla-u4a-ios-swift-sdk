//
//  UBConstants.swift
//  Usabilla
//
//  Created by Anders Liebl on 21/02/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

internal let chunkSize:Int = 40

enum FormType: String {
    case active
    case passive
}

struct PoweredByLogo {
    let formType: FormType
    init(formType: FormType) {
        self.formType = formType
    }
    var url: String {
        return "https://www.getfeedback.com/digital/?utm_medium=powered-link&utm_source=apps_\(String(describing: formType.rawValue))"
    }
}

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

struct TelemetryConstants {
    static let noCampaingFound = "No campaign found"
    static let campaingAlraedyTriggered = "Campaign already triggered"
    static let campaingAlreadyShowing = "A campaign is already displayed"
    static let filename = "debug.data"
    static let filepath = "UBSDK"

    static let errorCodeServer = 500
    static let errorCodeClient = 400

    static let takeScreenshot = "takeScreenshot"

    static let loadFeedbackForm = "loadFeedbackForm"
    static let initialize = "initialize"
    static let sendEvent =  "sendEvent"

    static let resetCampaignData = "resetCampaignData"
    static let removeCachedForms =  "removeCachedForms"
    static let setDataMasking =  "setDataMasking"
    static let dismiss = "dismiss"
    static let debugEnabled = "debugEnabled"
    static let setFooterLogoClickable = "setFooterLogoClickable"
    static let unknown = "unknown"

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
        static let scrollContentMargin: CGFloat = -20
        static let buttonStackViewHeight: CGFloat = 44
        static let textTitleLines: Int = 5
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
        static let cancelButtonBottomMargin: CGFloat = -6

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
        static let cancelButtonText: String = "usa_cancel_button_title"
        static let addButtonText: String = "usa_add_button_title"
        static let doneButtonText: String = "usa_done_button_title"
        static let editTitleText: String = "usa_edit_title"
        static let backButtonLibraryText: String = "usa_back_button_library_title"

        static let toolbarHeight: CGFloat = 32
        static let toolbarWidth: CGFloat = 32
        static let toolbarTopMarginHeight: CGFloat = 30
        static let toolbarBottomMarginHeight: CGFloat = -14
    }

    struct UBSAEditImageMasterView {
        static let editButtonName: String = "ic_check"
        static let undoButtonName: String = "ic_undo"

        static let bottomMenuHeight: CGFloat = 62.0
        static let bottomMenuAnimationTime: TimeInterval = 0.3

        static let doneButtoniconsInsect: CGFloat = 20
        static let undoButtoniconsInsect: CGFloat = 20
        static let addButtonInsectTop: CGFloat = 5.0
        static let addButtonInsectBottom: CGFloat = 5.0
        static let addButtonInsectleft: CGFloat = 25.0
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

        static let titleLabelTopMargin: CGFloat = 13

        static let collectionLeftSideMargin: CGFloat = 0
        static let collectionRightSideMargin: CGFloat = 1
        static let collectionTopMargin: CGFloat = 8
        static let collectionBottomMargin: CGFloat = 0

        static let headerViewHeight: CGFloat = 50

        static let errroViewMargin: CGFloat = 10
        static let errroViewContentMargin: CGFloat = 30
        static let errroViewContentHeight: CGFloat = 20
        static let errroViewDescribtionMaxWidth: CGFloat = 300

        static let backButtonText: String = "usa_back_button_title"
        static let libraryTitleText: String = "usa_library_title"
        static let libraryCancelText: String = "usa_cancel_button_title"
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

struct UBStyle {
    struct LightTheme {
        static let text = UIColor.init(rgba: "#555B6E")
        static let textOnAccent = UIColor.init(rgba: "#FFFFFF")
        static let accent = UIColor.init(rgba: "#258060")
        static let title = UIColor.init(rgba: "#0F1013")
        static let error = UIColor.init(rgba: "#C43E3E")
        static let background = UIColor.init(rgba: "#F3F3F5")
        static let cardColor = UIColor.init(rgba: "#FFFFFF")
    }
    struct DarkTheme {
        static let text = UIColor.init(rgba: "#F3F3F5")
        static let textOnAccent = UIColor.init(rgba: "#0F1013")
        static let accent = UIColor.init(rgba: "#C7E0D6")
        static let title = UIColor.init(rgba: "#FFFFFF")
        static let error = UIColor.init(rgba: "#EB7D7D")
        static let background = UIColor.init(rgba: "#303A42")
        static let cardColor = UIColor.init(rgba: "#555B6E")
    }
}

struct DefaultEventConstants {
    static let noResultFound = "No default survey found"
    static let noSurveyToShow = "No survey found to show"
    static let displayNotAllowed = "Survey not allowed to display"
    static let failedToDisplay = "Failed to display survery"
    static let errorInFormat = "Survey has error in format"
    static let undefinded = "Survey not presented due to an undefinded error"
    static let inactiveCampaign = "Inactive campaign found"
}
