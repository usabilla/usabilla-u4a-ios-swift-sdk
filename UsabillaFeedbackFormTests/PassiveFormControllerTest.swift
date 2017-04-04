//
//  PassiveFormControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 09/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class PassiveFormControllerTest: QuickSpec {
    fileprivate var closed: (([FeedbackResult]) -> Void)?

    override func spec() {
        var viewController: FormViewController!

        beforeEach {
            let path = Bundle(for: PassiveFormControllerTest.self).path(forResource: "test", ofType: "json")!
            let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
            let jsonObj: JSON = JSON(data: (data as Data?)!)
            let formModel = FormModel(json: jsonObj, id: "a", screenshot: nil)

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            if let base = storyboard.instantiateViewController(withIdentifier: "base") as? UINavigationController,
                let vc = base.childViewControllers[0] as? FormViewController {
                    viewController = vc
                    viewController.initWithFormModel(formModel)
                    viewController.delegate = PassiveFormController()
                    // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
                    _ = viewController.view

                    // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
                    viewController.beginAppearanceTransition(true, animated: false)
                    viewController.endAppearanceTransition()
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

extension PassiveFormControllerTest: UsabillaFeedbackFormDelegate {
    func formFailedLoading(_ backupForm: UINavigationController) {

    }

    func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {

    }

    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
        closed!(feedbackResults)
    }
}
