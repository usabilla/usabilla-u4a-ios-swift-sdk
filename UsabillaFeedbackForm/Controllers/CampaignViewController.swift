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
    fileprivate let viewModel: CampaignViewModel
    fileprivate weak var delegate: CampaignViewControllerDelegate?

    override func viewDidLoad() {
        if let introPageViewModel = viewModel.introPageViewModel {
            let introOutroView = UBIntroOutroView(viewModel: introPageViewModel)
            introOutroView.delegate = self
            view.addSubview(introOutroView)
            viewModel.introPresenter?.present(view: introOutroView, inView: view)
            // TO DO : display intro
            return
        }
        // TO DO : display modal
    }
    
    override func loadView() {
        self.view = UBCustomTouchableView()
        self.view.frame = UIScreen.main.bounds
    }

    init(campaign: Campaign, delegate: CampaignViewControllerDelegate) {
        self.campaign = campaign
        self.viewModel = CampaignViewModel(campaign: campaign)
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CampaignViewController: UBIntroOutroViewDelegate {
    
    internal func introViewDidCancel(introView: UBIntroOutroView) {
        introView.removeFromSuperview()
        delegate?.campaignDidEnd(success: false)
    }

    internal func introViewDidContinue(introView: UBIntroOutroView) {
        
    }
}

extension CampaignViewController: FormViewControllerDelegate {

    func leftBarButtonTapped(_ formViewController: FormViewController) {
        // TO DO dismiss modal
        delegate?.campaignDidEnd(success: false)
    }

    func rightBarButtonTapped(_ formViewController: FormViewController) {
        // TO DO dismiss modal and show end page
    }
}
