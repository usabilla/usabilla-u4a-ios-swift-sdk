//
//  FormViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    var viewModel: UBFormViewModel!
    var reachability: Reachability!
    var pageController: PageController!
    var thankYouController: ThankYouController!
    var customVars: [String: Any]?
    var delegate: FormViewControllerDelegate?
    fileprivate var results: [FeedbackResult] = []

    lazy var leftNavItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonPressed(_:)))
    }()
    lazy var rightNavItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonPressed(_:)))
    }()

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint!

    override func loadView() {
        super.loadView()

        SwiftEventBus.onMainThread(self, name: "restoreForm") { _ in
            self.restoreFeedbackFormController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()

        if viewModel.shouldHideProgressBar {
            progressBar.isHidden = true
            progressBarHeight.constant = 0
        } else {
            progressBar.progressTintColor = viewModel.accentColor
            progressBar.trackTintColor = viewModel.backgrounColor
        }

        pageController = PageController(viewModel: viewModel.currentPageViewModel)
        addChildViewController(pageController)
        containerView.addSubview(pageController.view)
        pageController.view.frame = containerView.bounds
        pageController.didMove(toParentViewController: self)

        updateProgressBar()
        updateRightButton()
        setUpLeftButton()

        UIApplication.shared.statusBarStyle = viewModel.statusBarColor
        self.navigationController?.navigationBar.barTintColor = viewModel.headerColor
        self.navigationController?.navigationBar.tintColor = viewModel.textOnAccentColor
    }

    func setUpView() {
        self.navigationItem.leftBarButtonItem = leftNavItem
        self.navigationItem.rightBarButtonItem = rightNavItem
    }

    func setUpLeftButton() {
        leftNavItem.title = viewModel.cancelButtonTitle
        leftNavItem.isEnabled = viewModel.showCancelButton
    }

    func showThankYouPage() {
        guard let endPageViewModel = viewModel.endPageViewModel else {
            return
        }
        progressBar.setProgress(1, animated: true)
        rightNavItem.title = ""
        rightNavItem.isEnabled = false
        leftNavItem.title = viewModel.cancelButtonTitle
        leftNavItem.isEnabled = true

        thankYouController = ThankYouController(viewModel: endPageViewModel)
        pageController.willMove(toParentViewController: nil)
        addChildViewController(thankYouController)
        thankYouController.view.frame = containerView.bounds
        transition(from: pageController, to: thankYouController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    func restoreFeedbackFormController() {
        viewModel.reset()
        swipeToPage(viewModel.firstPageViewModel!)
        thankYouController.willMove(toParentViewController: nil)
        addChildViewController(pageController)
        pageController.view.frame = containerView.bounds
        transition(from: thankYouController, to: pageController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: { _ in
            self.thankYouController = nil
        })
        updateRightButton()
        updateProgressBar()
        setUpLeftButton()
    }

    func updateRightButton() {
        rightNavItem.isEnabled = true
        rightNavItem.title = viewModel.rightBarButtonTitle
    }

    func updateProgressBar() {
        progressBar.setProgress(viewModel.progress, animated: true)
    }

    func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.leftBarButtonTapped(self)
    }

    func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        defer {
            delegate?.rightBarButtonTapped(self)
        }
        if viewModel.isCurrentPageValid {
            goToNextPage()
            return
        }
        pageController.gotToNextErrorField()

    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageController.deinitPageController()
    }

    func swipeToPage(_ pageViewModel: PageViewModel) {
        pageController.setupViewModel(pageViewModel)
        viewModel.currentPageViewModel = pageViewModel

        updateProgressBar()
        updateRightButton()
    }

    func goToNextPage() {
        viewModel.currentPageViewModel = viewModel.nextPageViewModel!
        if viewModel.isItTheEnd {
            showThankYouPage()
            return
        }
        pageController.setupViewModel(viewModel.currentPageViewModel)
        updateProgressBar()
        updateRightButton()
    }
}
