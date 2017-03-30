//
//  UBWindow.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignWindow: UIWindow {
    static let shared = CampaignWindow()

    private var currentCampaign: CampaignModel?

    private init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        windowLevel = UIWindowLevelStatusBar - 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Display a campaign if no other campaigns are displaying

     - parameter campaign: Campaign to display
     */
    @discardableResult func showCampaign(_ campaign: CampaignModel) -> Bool {
        guard currentCampaign != nil else {
            return false
        }
        currentCampaign = campaign
        rootViewController = CampaignViewController(campaign: campaign, delegate: self)
        isHidden = false
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
    func campaignDidEnd(success: Bool) {
        isHidden = true
        rootViewController = nil
    }
}
