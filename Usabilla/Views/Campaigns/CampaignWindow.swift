//
//  UBWindow.swift
//  Usabilla
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class CampaignWindow: UIWindow {

    static let shared = CampaignWindow()
    fileprivate var currentCampaignViewModel: CampaignViewModel?

    private init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        windowLevel = UIWindowLevelStatusBar - 1
        accessibilityViewIsModal = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Display a campaign if no other campaigns are displaying

     - parameter campaign: Campaign to display
     */
    @discardableResult func showCampaign(_ campaignViewModel: CampaignViewModel) -> Bool {
        guard currentCampaignViewModel == nil else {
            return false
        }
        // Under iOS 13 the UIWindow has been moved out of UIApplication and into UIWindowScene
        // So for the UIWindow to know where to display itself, the windowScene must be set
        #if XCODE1100
        if #available(iOS 13, *) {
            if let currentWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                self.windowScene = currentWindowScene
            }
        }
        #endif
        isHidden = false
        currentCampaignViewModel = campaignViewModel
        rootViewController = CampaignViewController(viewModel: campaignViewModel, delegate: self)
        rootViewController?.view.translatesAutoresizingMaskIntoConstraints = false
        rootViewController?.view.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        rootViewController?.view.topAnchor.constraint(equalTo: topAnchor).activate()
        rootViewController?.view.leftAnchor.constraint(equalTo: leftAnchor).activate()
        rootViewController?.view.rightAnchor.constraint(equalTo: rightAnchor).activate()
        return true
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subView in subviews {
            if subView.hitTest(convert(point, to: subView), with: event) != nil {
                return true
            }
        }

        return false
    }
}

extension CampaignWindow: CampaignViewControllerDelegate {
    func campaignDidEnd() {
        isHidden = true
        rootViewController = nil
        currentCampaignViewModel = nil
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
    }
}
