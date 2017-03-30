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

    fileprivate let viewModel: CampaignViewModel

    fileprivate weak var delegate: CampaignViewControllerDelegate?

    var backgroundLayer: UIView?

    override func viewDidLoad() {
        if let introPageViewModel = viewModel.introPageViewModel {
            let introOutroView = UBIntroOutroView(viewModel: introPageViewModel)
            introOutroView.delegate = self

            var animations: (() -> Void)?

            if viewModel.introPageViewModel?.displayMode == .alert {
                createBackgroundLayer()
                animations = {
                    self.backgroundLayer!.alpha = 1
                }
            }
            view.addSubview(introOutroView)
            viewModel.introPresenter?.present(view: introOutroView, inView: view, animations: animations)

            
            // TO DO : display intro
            return
        }
        // TO DO : display modal
    }

    override func loadView() {
        self.view = UBCustomTouchableView()
        self.view.frame = UIScreen.main.bounds
    }

    init(viewModel: CampaignViewModel, delegate: CampaignViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    func createBackgroundLayer() {
        backgroundLayer = UIView()
        backgroundLayer!.alpha = 0.0
        backgroundLayer!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundLayer!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundLayer!)
        backgroundLayer!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLayer!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundLayer!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundLayer!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CampaignViewController: UBIntroOutroViewDelegate {

    internal func introViewDidCancel(introView: UBIntroOutroView) {
        var animations: (() -> Void)?
        if viewModel.introPageViewModel?.displayMode == .alert {
            animations = {
                self.backgroundLayer!.alpha = 0.0
            }
        }

        viewModel.introPresenter?.dismiss(view: introView, inView: self.view, animations: animations) {
            self.backgroundLayer?.removeFromSuperview()
            introView.removeFromSuperview()
            self.delegate?.campaignDidEnd(success: false)
        }
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
