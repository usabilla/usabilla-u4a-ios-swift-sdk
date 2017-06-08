//
//  FormViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    var viewModel: UBFormViewModel
    var reachability: Reachability!
    var pageController: PageController!
    var thankYouController: ThankYouController!
    var customVars: [String: Any]?
    var delegate: FormViewControllerDelegate?
    fileprivate var results: [FeedbackResult] = []

    lazy var leftNavItem: UIBarButtonItem = {
        let navLeft = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonPressed(_:)))
        navLeft.accessibilityIdentifier = "Cancel"
        return navLeft
    }()
    lazy var rightNavItem: UIBarButtonItem = {
        let navRight = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonPressed(_:)))
        navRight.accessibilityIdentifier = "Next"
        return navRight
    }()
    var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = 0.0
        progressBar.trackTintColor = UIColor.clear
        progressBar.tintColor = UIColor.clear
        progressBar.backgroundColor = UIColor.clear
        progressBar.contentMode = .scaleToFill
        return progressBar
    }()
    var containerView = UIView()

    init(viewModel: UBFormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: ViewController cycle
    override func loadView() {
        super.loadView()

        SwiftEventBus.onMainThread(self, name: "restoreForm") { _ in
            self.restoreFeedbackFormController()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        customizeView()

        updateProgressBar()
        updateRightButton()
        setUpLeftButton()
    }

    override func viewDidDisappear(_ animated: Bool) {
        deinitForm()
    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageController.deinitPageController()
    }

    // MARK: View setup
    func setUpView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = leftNavItem
        navigationItem.rightBarButtonItem = rightNavItem

        var containerTopAnchor: NSLayoutYAxisAnchor = view.topAnchor

        if !viewModel.shouldHideProgressBar {
            view.addSubview(progressBar)
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            progressBar.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
            progressBar.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
            progressBar.heightAnchor.constraint(equalToConstant: 2.0).activate()
            progressBar.topAnchor.constraint(equalTo: view.topAnchor).activate()
            containerTopAnchor = progressBar.bottomAnchor
        }

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        containerView.topAnchor.constraint(equalTo: containerTopAnchor).activate()

        // Add PageController
        pageController = PageController(viewModel: viewModel.currentPageViewModel)
        addChildViewController(pageController)
        containerView.addSubview(pageController.view)
        pageController.view.frame = containerView.bounds
        pageController.didMove(toParentViewController: self)
    }

    func customizeView() {
        UIApplication.shared.statusBarStyle = viewModel.statusBarColor

        navigationController?.navigationBar.barTintColor = viewModel.headerColor
        navigationController?.navigationBar.tintColor = viewModel.textOnAccentColor

        let fontAttributes = [NSFontAttributeName: viewModel.navBarItemsFont]
        rightNavItem.setTitleTextAttributes(fontAttributes, for: .normal)

        if !viewModel.shouldHideProgressBar {
            progressBar.progressTintColor = viewModel.accentColor
            progressBar.trackTintColor = viewModel.backgrounColor
        }
    }

    func setUpLeftButton() {
        leftNavItem.title = viewModel.cancelButtonTitle
        leftNavItem.isEnabled = viewModel.showCancelButton
    }

    // MARK: Actions
    func updateRightButton() {
        rightNavItem.isEnabled = true
        rightNavItem.title = viewModel.rightBarButtonTitle
    }

    func updateProgressBar() {
        progressBar.setProgress(viewModel.progress, animated: true)
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
