//
//  FormControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class FormControllerTest: QuickSpec {

    fileprivate var doneRight: (() -> Void)?
    fileprivate var doneLeft: (() -> Void)?

    override func spec() {
        var viewController: FormViewController!
        var formModel: FormModel!

        describe("FormControllerTest ") {
            beforeEach {
                let path = Bundle(for: FormControllerTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as Data?)!)
                formModel = FormModel(json: jsonObj, id: "a", themeConfig: UsabillaThemeConfigurator(), screenshot: nil)

                let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                if let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
                    let vc = base.childViewControllers[0] as? FormViewController {
                        viewController = vc
                        viewController.initWithFormModel(formModel)
                        viewController.delegate = self

                        // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
                        _ = viewController.view

                        // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
                        viewController.beginAppearanceTransition(true, animated: false)
                        viewController.endAppearanceTransition()
                }
            }
            describe("basics") {
                describe("viewDidLoad") {

                    it("sets the progress bar") {
                        // Since the label is only initialized when the view is loaded, this
                        // would fail if we didn't access the view in the `beforeEach` above.
                        expect(viewController.progressBar.progress).to(equal(0.25))
                    }

                    it("sets the navigation buttons") {
                        expect(viewController.rightNavItem.title).to(equal("Next"))
                        expect(viewController.leftNavItem.title).to(equal(""))
                        expect(viewController.leftNavItem.isEnabled).to(equal(false))
                    }
                }

                describe("turn the first page") {
                    it("turns the page, expext right updates") {
                        var newPageIndex = viewController.selectNewPage()
                        expect(newPageIndex).to(equal(2))

                        viewController.swipeToPage(newPageIndex)
                        viewController.updateRightButton()
                        viewController.updateProgressBar()

                        expect(viewController.currentPage).to(equal(newPageIndex))
                        expect(viewController.pageController.pageViewModel.name).to(equal(formModel.pages[newPageIndex].pageName))
                        expect(viewController.rightNavItem.title).to(equal("TestSubmit"))
                        expect(viewController.progressBar.progress).to(equal(0.75))

                        newPageIndex = viewController.selectNewPage()
                        expect(newPageIndex).to(equal(3))

                        //viewController.swipeToPage(newPageIndex)
                        viewController.showThankYouPage()

                        expect(viewController.currentPage).to(equal(2))
                        expect(viewController.rightNavItem.title).to(equal(""))
                        expect(viewController.rightNavItem.isEnabled).to(equal(false))
                        expect(viewController.progressBar.progress).to(equal(1))

                    }
                }

                describe(".viewWillDisappear()") {
                    beforeEach {
                        // Method #3: Directly call the lifecycle event.
                        viewController.viewWillDisappear(false)
                    }

                }
            }
        }

        describe("delegate methods test") {
            it("tap on right button should notify delegate") {
                waitUntil(timeout: 5.0) { done in
                    self.doneRight = {
                        done()
                    }
                    viewController.rightBarButtonPressed(UIBarButtonItem())
                }
            }

            it("tap on left button should notify delegate") {
                waitUntil(timeout: 5.0) { done in
                    self.doneLeft = {
                        done()
                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem())
                }
            }
        }
    }

}

extension FormControllerTest: FormViewControllerDelegate {
    func rightBarButtonTapped(_ formViewController: FormViewController) {
        doneRight?()
    }

    func leftBarButtonTapped(_ formViewController: FormViewController) {
        doneLeft?()
    }
}
