//
//  CampaignViewController.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol CampaignViewControllerDelegate: class {
    func campaignDidEnd(success: Bool)
}

class CampaignViewController: UIViewController {

    fileprivate let campaign: Campaign
    fileprivate weak var delegate: CampaignViewControllerDelegate?

    override func viewDidLoad() {

    }

    init(campaign: Campaign, delegate: CampaignViewControllerDelegate) {
        self.campaign = campaign
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CampaignViewController : FormViewControllerDelegate {
    
    func leftBarButtonTapped(_ formViewController: FormViewController) {
        // TO DO dismiss modal
        delegate?.campaignDidEnd(success: false)
    }
    
    func rightBarButtonTapped(_ formViewController: FormViewController) {
        // TO DO dismiss modal and show end page
    }
}
