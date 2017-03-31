//
//  FormViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    var currentPage = 0
    var currentPageModel: PageModel? {
        return currentPage < formModel.pages.count ? formModel.pages[currentPage] : nil
    }
    var formModel: FormModel!
    var reachability: Reachability!
    var pageController: PageController!
    var thankYouController: ThankYouController!
    var customVars: [String: Any]?
    var delegate: FormViewControllerDelegate?

    fileprivate var results: [FeedbackResult] = []

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
        swipeToPage(0)
        if formModel.pages.count == 2 || !formModel.showProgressBar {
            progressBar.isHidden = true
            progressBarHeight.constant = 0
        } else {
            progressBar.progressTintColor = formModel.themeConfig.accentColor
            progressBar.trackTintColor = formModel.themeConfig.backgroundColor
        }
        updateProgressBar()
        updateRightButton()
        UIApplication.shared.statusBarStyle = formModel.themeConfig.statusBarColor

        if let headerColor = formModel.themeConfig.headerColor {
            self.navigationController?.navigationBar.barTintColor = headerColor
        } else {
            self.navigationController?.navigationBar.barTintColor = formModel.themeConfig.accentColor
        }
        self.navigationController?.navigationBar.tintColor = formModel.themeConfig.textOnAccentColor


        setUpLeftButton()
    }



    func setUpLeftButton() {
        leftNavItem.title = formModel.copyModel.cancelButton

        if !UsabillaFeedbackForm.showCancelButton {
            leftNavItem.title = ""
            leftNavItem.isEnabled = false
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageController, segue.identifier == "embedSegue" {
            self.pageController = vc
            swipeToPage(0)
        }
    }

    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {
        if pageController.isCorrectlyFilled() {
            let newPageIndex = selectNewPage()
            if newPageIndex < formModel.pages.count && formModel.pages[newPageIndex].type == .end {
                currentPage = newPageIndex
                showThankYouPage()
            } else {
                swipeToPage(newPageIndex)
                updateProgressBar()
                updateRightButton()
            }
        }
        delegate?.rightBarButtonTapped(self)
    }

    func showThankYouPage() {
        progressBar.setProgress(1, animated: true)
        rightNavItem.title = ""
        rightNavItem.isEnabled = false
        leftNavItem.title = formModel.copyModel.cancelButton
        leftNavItem.isEnabled = true

        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        thankYouController = storyboard.instantiateViewController(withIdentifier: "thankYou") as? ThankYouController
        thankYouController.themeConfig = formModel.themeConfig
        thankYouController.redirectEnabled = formModel.redirectToAppStore
        thankYouController.redirectToAppStore = formModel.copyModel.appStore
        thankYouController.giveMoreFeedback = formModel.copyModel.moreFeedback

        var headerFieldValue: String?
        var thanksFieldValue: String?
        if let lastPage = formModel.pages.last {
            if lastPage.fields.count > 0 {
                if let header: HeaderFieldModel = lastPage.fields[0] as? HeaderFieldModel {
                    headerFieldValue = header.fieldValue
                }
            }
            if lastPage.fields.count > 1 {
                if let thank: StringFieldModel = lastPage.fields[1] as? StringFieldModel {
                    thanksFieldValue = thank.fieldValue
                }
            }
        }

        let moodValue = formModel.pages.first?.fields[0] as? IntFieldModel

        pageController.willMove(toParentViewController: nil)
        addChildViewController(thankYouController)
        thankYouController.view.frame = containerView.bounds


        transition(from: pageController, to: thankYouController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        var rating: Int = 0
        if let moodRating = moodValue?.fieldValue {
            rating = moodRating
        }
        thankYouController.setUpController(rating > 3, thankTitle: headerFieldValue, thankMessage: thanksFieldValue)

    }

    func restoreFeedbackFormController() {
        resetAndRestartForm()
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

    func resetAndRestartForm() {
        currentPage = 0
        formModel = FormModel(json: formModel.formJsonString, id: formModel.appId, themeConfig: formModel.themeConfig, screenshot: nil)
        swipeToPage(0)
    }


    func selectNewPage() -> Int {
        var newPageIndex = -1
        if let pageToJump = pageController.whereShouldIJump() {
            for (index, page) in formModel.pages.enumerated() where page.pageName == pageToJump {
                newPageIndex = index
            }
        }

        if newPageIndex == -1 {
            newPageIndex = currentPage + 1
        }

        return newPageIndex
    }


    func updateRightButton() {
        rightNavItem.isEnabled = true
        if currentPage == formModel.pages.count - 2 {
            rightNavItem.title = formModel.copyModel.navigationSubmit
        } else if currentPage == formModel.pages.count - 1 {
            rightNavItem.title = formModel.copyModel.cancelButton
        } else {
            rightNavItem.title = formModel.copyModel.navigationNext
        }
    }

    func updateProgressBar() {
        let progress = Float(currentPage + 1) / Float(formModel.pages.count)
        progressBar.setProgress(progress, animated: true)
    }

    @IBAction func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        deinitForm()
        delegate?.leftBarButtonTapped(self)
        if thankYouController == nil {
            results.append(formModel.toFeedbackResult(latestPageIndex: currentPage))
        }

        if UsabillaFeedbackForm.dismissAutomatically {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageController.deinitPageController()
    }

    func initWithFormModel(_ formModel: FormModel) {
        self.formModel = formModel
    }

    func swipeToPage(_ page: Int) {
        let pageViewModel = PageViewModel(page: formModel.pages[page])
        pageController.initWithViewModel(pageViewModel)
        currentPage = page
    }

}
