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

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var leftNavItem: UIBarButtonItem!
    @IBOutlet weak var rightNavItem: UIBarButtonItem!
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
        // Do any additional setup after loading the view.
        if viewModel.shouldHideProgressBar {
            progressBar.isHidden = true
            progressBarHeight.constant = 0
        } else {
            progressBar.progressTintColor = viewModel.accentColor
            progressBar.trackTintColor = viewModel.backgrounColor
        }

        updateProgressBar()
        updateRightButton()
        setUpLeftButton()

        UIApplication.shared.statusBarStyle = viewModel.statusBarColor
        self.navigationController?.navigationBar.barTintColor = viewModel.headerColor
        self.navigationController?.navigationBar.tintColor = viewModel.textOnAccentColor
    }

    func setUpLeftButton() {
        leftNavItem.title = viewModel.cancelButtonTitle
        leftNavItem.isEnabled = viewModel.showCancelButton
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageController, segue.identifier == "embedSegue" {
            self.pageController = vc
            swipeToPage(viewModel.firstPageViewModel!)
        }
    }

    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        defer {
            delegate?.rightBarButtonTapped(self)
        }
        if viewModel.isCurrentPageValid {
            goToNextPage()
            return
        }
        pageController.gotToNextErrorField()

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

        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        thankYouController = storyboard.instantiateViewController(withIdentifier: "thankYou") as? ThankYouController
        thankYouController.viewModel = endPageViewModel
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

    @IBAction func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.leftBarButtonTapped(self)
    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageController.deinitPageController()
    }

    func swipeToPage(_ pageViewModel: PageViewModel) {
        pageController.initWithViewModel(pageViewModel)
        viewModel.currenPageViewModel = pageViewModel

        updateProgressBar()
        updateRightButton()
    }

    func goToNextPage() {
        viewModel.currenPageViewModel = viewModel.nextPageViewModel!
        if viewModel.isItTheEnd {
            showThankYouPage()
            return
        }
        pageController.initWithViewModel(viewModel.currenPageViewModel)
        updateProgressBar()
        updateRightButton()
    }

}
