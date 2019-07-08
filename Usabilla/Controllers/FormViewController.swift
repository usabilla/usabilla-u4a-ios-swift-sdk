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
    var initialRect: CGRect?
    // swiftlint:disable:next weak_delegate
    var delegate: FormViewControllerDelegate?
    fileprivate var results: [FeedbackResult] = []

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UsabillaInternal.supportedOrientations
    }

    override var shouldAutorotate: Bool {
        if UsabillaInternal.supportedOrientations == .all {
            return true
        }
        return false
    }
    lazy var cancelButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonPressed(_:)))
    }()

    lazy var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextButtonPressed(_:)))
    }()

    lazy var submitButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextButtonPressed(_:)))
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

    // set the status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return previousStatusBarColor ?? (viewModel.statusBarColor ?? .lightContent)
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
    }

    deinit {
        deinitForm()
    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageViewController?.deinitPageController()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] (_ : UIViewControllerTransitionCoordinatorContext) in
            self?.pageViewController.tableView.reloadData()
        })
    }

    // MARK: View setup
    func setUpView() {
        title = viewModel.navigationBarTitle
        navigationController?.view?.accessibilityIdentifier = "form-navigation-controller"
        navigationController?.navigationBar.isTranslucent = false
        updateLeftButton()
        updateRightButton()
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
        pageViewController.client = viewModel.model.client
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParentViewController: self)
    }

    func customizeView() {
        if let statusBarColor = viewModel.statusBarColor {
            if #available(iOS 11.0, *) {
                setNeedsStatusBarAppearanceUpdate()
            } else {
                previousStatusBarColor = UIApplication.shared.statusBarStyle
                UIApplication.shared.statusBarStyle = statusBarColor
            }
        }

        let textOnAccentedColor = viewModel.textOnAccentColor
        navigationController?.navigationBar.barTintColor = viewModel.headerColor
        navigationController?.navigationBar.tintColor = textOnAccentedColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: textOnAccentedColor]
        cancelButton.setFont(font: viewModel.navBarItemsFontNormal)
        cancelButton.title = viewModel.cancelText
        nextButton.setFont(font: viewModel.navBarItemsFontBold)
        nextButton.title = viewModel.nextText
        submitButton.setFont(font: viewModel.navBarItemsFontBold)
        submitButton.title = viewModel.submitText

        if !viewModel.shouldHideProgressBar {
            progressBar.progressTintColor = viewModel.accentColor
            progressBar.trackTintColor = viewModel.backgrounColor
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cancelButton.setTextForegroundColor(color: viewModel.textOnAccentColor)
        nextButton.setTextForegroundColor(color: viewModel.textOnAccentColor)
        submitButton.setTextForegroundColor(color: viewModel.textOnAccentColor)
        cancelButton.setFont(font: viewModel.navBarItemsFontNormal)
        nextButton.setFont(font: viewModel.navBarItemsFontBold)
        submitButton.setFont(font: viewModel.navBarItemsFontBold)
//        if initialRect != nil {
//            pageViewController.view.frame = initialRect!
//            UIView.animate(withDuration: 0.5, animations: {
//                self.pageViewController.view.frame = self.containerView.bounds
//            })
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let previousStatusColor = previousStatusBarColor {
            if #available(iOS 11.0, *) {
                setNeedsStatusBarAppearanceUpdate()
            } else {
                UIApplication.shared.statusBarStyle = previousStatusColor
            }

        }
    }

    // MARK: Actions

    func updateLeftButton() {
        navigationItem.leftBarButtonItem = button(forType: viewModel.leftBarButtonType)
    }

    func updateRightButton() {
        navigationItem.rightBarButtonItem = button(forType: viewModel.rightBarButtonType)
    }

    func updateProgressBar() {
        progressBar.setProgress(viewModel.progress, animated: true)
    }

    func showThankYouPage() {
        guard let endPageViewModel = viewModel.endPageViewModel else {
            return
        }
        progressBar.setProgress(1, animated: true)
        updateLeftButton()
        updateRightButton()

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
        updateLeftButton()
        updateRightButton()
        updateProgressBar()
    }

    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.formWillClose(self)
    }

    @objc func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard !viewModel.isItTheEnd else {
            delegate?.formWillClose(self)
            return
        }
        if viewModel.isCurrentPageValid {
            let index = viewModel.nextPageIndex
            let oldPageModel = viewModel.currentPageViewModel.model
            let oldIndex = viewModel.currentPageIndex
            goToPage(atIndex: index)
            delegate?.pageDidTurn(oldPageModel: oldPageModel, oldPageIndex: oldIndex, newPageIndex: index, nextPageType: viewModel.currentPageViewModel.model.type, formViewController: self)
            return
        }
        pageViewController.gotToNextErrorField()
    }

    func swipeToPage(_ pageViewModel: PageViewModel) {
        pageViewController.setupViewModel(pageViewModel)
        viewModel.currentPageViewModel = pageViewModel
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

    func button(forType type: UBFormButtonType?) -> UIBarButtonItem? {
        switch type {
        case .some(.cancel):
            return cancelButton
        case .some(.next):
            return nextButton
        case .some(.submit):
            return submitButton
        case .none:
            return nil
        }
    }
}
