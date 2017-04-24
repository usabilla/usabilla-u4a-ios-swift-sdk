//
//  FormControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//
import Quick
import Nimble

@testable import UsabillaFeedbackForm

class FormControllerTest: QuickSpec {

    fileprivate var closed: (([FeedbackResult]) -> Void)?

    override func spec() {
        var viewController: FormViewController!
        var formModel: FormModel!

        describe("FormControllerTest ") {


            beforeEach {
                let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data! as Data)
                formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())


                let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
                if let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
                    let vc = base.childViewControllers[0] as? FormViewController {
                        viewController = vc
                        viewController.initWithFormModel(formModel)

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
                        expect(viewController.pageController.pageModel.pageName).to(equal(formModel.pages[newPageIndex].pageName))
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
            
            
            describe("if cancel during form it should return one empty feedbackresult") {
                it("cancel the form should dismiss it") {
                    UsabillaFeedbackForm.delegate = self
                    waitUntil(timeout: 5.0) { done in
                        self.closed = { feedbackResults in
                            expect(feedbackResults.count).to(equal(1))
                            expect(feedbackResults.first?.sent).to(beFalse())
                            done()
                        }
                        viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                    }
                }
            }
            
            describe("if cancel after submission it should return a success feedbackresult") {
                it("cancel the form should dismiss it") {
                    
                    
                    viewController.rightBarButtonPressed(UIBarButtonItem(customView: UIView()))
                    viewController.rightBarButtonPressed(UIBarButtonItem(customView: UIView()))
                    expect(viewController.thankYouController).toNot(beNil())
                    
                    UsabillaFeedbackForm.delegate = self
                    waitUntil(timeout: 5.0) { done in
                        self.closed = { feedbackResults in
                            expect(feedbackResults.count).to(equal(1))
                            expect(feedbackResults.first?.sent).to(beTrue())
                            done()
                        }
                        viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                    }
                }
            }

        }
    }



}

extension FormControllerTest: UsabillaFeedbackFormDelegate {
    func formFailedLoading(_ backupForm: UINavigationController) {

    }

    func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {

    }

    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
        closed!(feedbackResults)
    }

}
