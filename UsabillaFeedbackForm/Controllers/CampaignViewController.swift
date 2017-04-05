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

    let sideMargin: CGFloat = 16
    let topMargin: CGFloat = 20 + 16

    fileprivate let viewModel: CampaignViewModel

    fileprivate weak var delegate: CampaignViewControllerDelegate?

    var backgroundLayer: UIView?
    var introView: UBIntroOutroView?

    override func viewDidLoad() {
        if let introPageViewModel = viewModel.introPageViewModel {
            introView = UBIntroOutroView(viewModel: introPageViewModel)
            introView!.delegate = self

            var animations: (() -> Void)?

            if viewModel.introPageViewModel?.displayMode == .alert {
                createBackgroundLayer()
                animations = {
                    self.backgroundLayer!.alpha = 1
                }
            }
            view.addSubview(introView!)
            viewModel.introPresenter?.present(view: introView!, inView: view, animations: animations)
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
        guard backgroundLayer == nil else {
            return
        }
        backgroundLayer = UIView()
        backgroundLayer!.alpha = 0.0
        backgroundLayer!.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundLayer!.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundLayer!, at: 0)
        backgroundLayer!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundLayer!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundLayer!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundLayer!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showModalForm() {

        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        guard let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
            let formController = base.childViewControllers[0] as? FormViewController else {
                return
        }
        formController.delegate = self
        formController.viewModel = viewModel.formViewModel

        addChildViewController(base)
        view.addSubview(base.view)
        base.view.alpha = 0
        base.view.layer.cornerRadius = 14
        base.view.layer.masksToBounds = true

        base.view.translatesAutoresizingMaskIntoConstraints = false
        base.view.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin).activate()
        base.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin).activate()
        base.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin).activate()
        base.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -topMargin).activate()

        createBackgroundLayer()
        
        UIView.animate(withDuration: 0.33, animations: {
            base.view.alpha = 1
            self.backgroundLayer?.alpha = 1
            self.introView?.alpha = 0
        }) { _ in
            self.introView?.removeFromSuperview()
        }
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
        showModalForm()
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
