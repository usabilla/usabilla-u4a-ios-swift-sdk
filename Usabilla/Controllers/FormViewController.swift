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
    var previousStatusBarColor: UIStatusBarStyle?
    var reachability: Reachability!
    var pageViewController: PageViewController!
    var thankYouViewController: ThankYouViewController!
    // swiftlint:disable:next weak_delegate
    var delegate: FormViewControllerDelegate?
    fileprivate var results: [FeedbackResult] = []

    lazy var leftNavItem: UIBarButtonItem = {
        let navLeft = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBarButtonPressed(_:)))
        navLeft.accessibilityLabel = "Cancel"
        return navLeft
    }()
    lazy var rightNavItem: UIBarButtonItem = {
        let navRight = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonPressed(_:)))
        navRight.accessibilityLabel = "Next"
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

    deinit {
        deinitForm()
    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageViewController?.deinitPageController()
    }

    // MARK: View setup
    func setUpView() {
        title = viewModel.navigationBarTitle
        navigationController?.view?.accessibilityIdentifier = "form-navigation-controller"
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
        pageViewController = PageViewController(viewModel: viewModel.currentPageViewModel)
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParentViewController: self)
    }

    func customizeView() {
        if let statusBarColor = viewModel.statusBarColor {
            previousStatusBarColor = UIApplication.shared.statusBarStyle
            UIApplication.shared.statusBarStyle = statusBarColor
        }

        let textOnAccentedColor = viewModel.textOnAccentColor
        navigationController?.navigationBar.barTintColor = viewModel.headerColor
        navigationController?.navigationBar.tintColor = textOnAccentedColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: textOnAccentedColor]

        rightNavItem.setFont(font: viewModel.navBarItemsFontBold)
        leftNavItem.setFont(font: viewModel.navBarItemsFontNormal)

        if !viewModel.shouldHideProgressBar {
            progressBar.progressTintColor = viewModel.accentColor
            progressBar.trackTintColor = viewModel.backgrounColor
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        rightNavItem.setTextForegroundColor(color: viewModel.textOnAccentColor)
        leftNavItem.setTextForegroundColor(color: viewModel.textOnAccentColor)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let previousStatusColor = previousStatusBarColor {
            UIApplication.shared.statusBarStyle = previousStatusColor
        }
    }

    func setUpLeftButton() {
        leftNavItem.title = viewModel.cancelButtonTitle
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

        thankYouViewController = ThankYouViewController(viewModel: endPageViewModel)

        pageViewController.willMove(toParentViewController: nil)
        addChildViewController(thankYouViewController)
        thankYouViewController.view.frame = containerView.bounds
        transition(from: pageViewController, to: thankYouViewController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    func restoreFeedbackFormController() {
        viewModel.reset()
        // swiftlint:disable:next force_unwrapping
        swipeToPage(viewModel.firstPageViewModel!)
        thankYouViewController.willMove(toParentViewController: nil)
        addChildViewController(pageViewController)
        pageViewController.view.frame = containerView.bounds
        transition(from: thankYouViewController, to: pageViewController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: { _ in
            self.thankYouViewController = nil
        })
        updateRightButton()
        updateProgressBar()
        setUpLeftButton()
    }

    func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.formWillClose(self)
    }

    func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        if viewModel.isCurrentPageValid {
            let index = viewModel.nextPageIndex
            let oldPageModel = viewModel.currentPageViewModel.model
            let oldIndex = viewModel.currentPageIndex
            goToPage(atIndex: index)
            // swiftlint:disable:next force_unwrapping
            delegate?.pageDidTurn(oldPageModel: oldPageModel, oldPageIndex: oldIndex, newPageIndex: index, nextPageType: viewModel.currentPageViewModel.model.type!, formViewController: self)
            return
        }
        pageViewController.gotToNextErrorField()
    }

    func swipeToPage(_ pageViewModel: PageViewModel) {
        pageViewController.setupViewModel(pageViewModel)
        viewModel.currentPageViewModel = pageViewModel

        updateProgressBar()
        updateRightButton()
    }

    func goToPage(atIndex index: Int) {
        guard viewModel.containsIndex(index: index) else {
            // This guard only happens to avoid the crash if the index passed is not contained in the range
            // If this happens, we show the thank you page/ toast
            viewModel.goToLastPageIndex()
            showThankYouPage()
            return
        }
        viewModel.currentPageViewModel = viewModel.pageViewModel(atIndex: index)
        if viewModel.isItTheEnd {
            if !viewModel.isCampaignForm {
                showThankYouPage()
            }
            return
        }
        pageViewController.setupViewModel(viewModel.currentPageViewModel)
        updateProgressBar()
        updateRightButton()
    }
}
