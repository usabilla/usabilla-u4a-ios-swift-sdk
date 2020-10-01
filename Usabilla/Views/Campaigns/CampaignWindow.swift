//
//  UBWindow.swift
//  Usabilla
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//
import Foundation
import UIKit

// with iOS 13, and scenes we add another window, that requries a pass-through of hits. We use both UIWindow and UIView to make it work properly
class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self  ? nil : view
    }
}

class CampaignWindow {
    fileprivate var currentCampaignViewModel: CampaignViewModel?

    var showing = false
    static let shared = CampaignWindow()
    private var  window: UIWindow?
    private var campaingController: CampaignViewController?
    private init() { }

    @discardableResult func showCampaign(_ campaignViewModel: CampaignViewModel) -> Bool {
        if showing {
            return false
        }
        var popupWindow: UIWindow?
        #if XCODE1100 || XCODE1200
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first
            if let windowScene = windowScene as? UIWindowScene {
                popupWindow = PassthroughWindow(windowScene: windowScene)
            }
        } else {
            popupWindow = PassthroughWindow(frame: UIScreen.main.bounds)
        }
        #else
            popupWindow = PassthroughWindow(frame: UIScreen.main.bounds)
        #endif
        let viewcontroller = UIViewController()
        viewcontroller.view = UBCustomTouchableView()
        viewcontroller.view.backgroundColor = .clear
        viewcontroller.modalPresentationStyle = .overFullScreen
        viewcontroller.view.alpha = 1
        viewcontroller.view.frame = UIScreen.main.bounds
        viewcontroller.view.translatesAutoresizingMaskIntoConstraints = true

        popupWindow?.frame = UIScreen.main.bounds
        popupWindow?.backgroundColor = .clear
        popupWindow?.windowLevel = UIWindowLevelStatusBar + 1
        popupWindow?.rootViewController = viewcontroller
        popupWindow?.makeKeyAndVisible()
        showing = true
        let campaignVC = CampaignViewController(viewModel: campaignViewModel, delegate: self)
        campaignVC.view.translatesAutoresizingMaskIntoConstraints = true
        campaignVC.view.backgroundColor = .clear
        campaignVC.modalPresentationStyle = .overFullScreen
        popupWindow?.rootViewController?.present(campaignVC, animated: false, completion: nil)
        campaingController = campaignVC
        window = popupWindow
        return true
    }

    func removeCampaign() -> Bool {
        if showing {
            return campaingController?.forceCloseCampaing() ?? false
        }
        return false
    }

    func setWindowLevel(_ level: UIWindowLevel) {
        window?.windowLevel = level
    }
}

extension CampaignWindow: CampaignViewControllerDelegate {
    func campaignDidEnd() {
        currentCampaignViewModel = nil
        window?.rootViewController?.dismiss(animated: true, completion: {})
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
        window?.isHidden = true

        if #available(iOS 13, *) {
            window?.windowScene = nil
        }
        showing = false
    }
}
