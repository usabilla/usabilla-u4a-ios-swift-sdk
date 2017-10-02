//
//  PassiveFormControllerTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 09/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length
import Quick
import Nimble

@testable import Usabilla

class PassiveFormControllerTest: QuickSpec {
    fileprivate var onDidClose: (([FeedbackResult], Bool) -> Void)?
    fileprivate var onWillClose: (([FeedbackResult], Bool) -> Void)?

    override func spec() {
        var viewController: FormViewController!
        var navigationController: UINavigationController!
        var submissionManager: SubmissionManager!

        beforeEach {
            submissionManager = SubmissionManager(formService: UBFormServiceMock())
            let formModel = UBMock.formMock()
            viewController = FormViewController(viewModel: UBFormViewModel(formModel: formModel))
            navigationController = UINavigationController(rootViewController: viewController)
            _ = navigationController // remove xcode warning
            viewController.delegate = PassiveFormController(submissionManager: submissionManager)
            // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
            _ = viewController.view

            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            self.onDidClose = nil
            self.onWillClose = nil
            Usabilla.dismissAutomatically = true
            Usabilla.delegate = self
        }

        context("When canceling the form before the end page") {
            it("should create a feedback result") {
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { feedbackResults, _ in
                        expect(feedbackResults.count).to(equal(1))
                        expect(feedbackResults.first?.sent).to(beFalse())
                        done()

                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                }
            }

            it("should call the willClose delegate method with the right appStoreRedirect Value") {
                let path = Bundle(for: PassiveFormControllerTest.self).path(forResource: "redirectEnabled", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj = JSON(data: (data as Data?)!)
                let formModel = FormModel(json: jsonObj, id: "a", screenshot: nil)


                viewController = FormViewController(viewModel: UBFormViewModel(formModel: formModel))
                navigationController = UINavigationController(rootViewController: viewController)
                _ = navigationController
                viewController.delegate = PassiveFormController(submissionManager: submissionManager)
                _ = viewController.view
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()

                waitUntil(timeout: 5.0) { done in
                    self.onWillClose = { feedbackResults, redirectToAppStore in
                        expect(redirectToAppStore).to(beTrue())
                        done()
                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                }
            }

            it("should call the willClose delegate method") {
                waitUntil(timeout: 5.0) { done in
                    self.onWillClose = { feedbackResults, redirectToAppStore in
                        expect(redirectToAppStore).to(beFalse())
                        done()
                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                }
            }

            it("should call the didClose delegate method when dismissAutomatically is true") {
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { feedbackResults, redirectToAppStore in
                        done()
                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                }
            }

            it("should not call the didClose delegate method when dismissAutomatically is false") {
                Usabilla.dismissAutomatically = false
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { feedbackResults, redirectToAppStore in
                        fail()
                    }
                    self.onWillClose = { feedbackResults, redirectToAppStore in
                        done()
                    }
                    viewController.leftBarButtonPressed(UIBarButtonItem(customView: UIView()))
                }
            }
        }

        context("When canceling the form at the end page") {
            it("should create a feedback result") {

                let vm = viewController.viewModel.currentPageViewModel
                expect(vm.isCorrectlyFilled).to(beFalse())
                let moodVM = vm.cellViewModels.first {
                    $0.componentViewModel is MoodComponentViewModel
                }?.componentViewModel as? MoodComponentViewModel

                moodVM?.value = 2

                let npsVM = vm.cellViewModels.first {
                    $0.componentViewModel is NPSComponentViewModel
                }?.componentViewModel as? NPSComponentViewModel

                npsVM?.value = 2
                expect(viewController.viewModel.currentPageIndex).to(equal(0))
                expect(viewController.viewModel.isCurrentPageValid).to(beTrue())
                viewController.rightBarButtonPressed(UIBarButtonItem(customView: UIView()))
                expect(viewController.viewModel.currentPageIndex).to(equal(1))
                expect(viewController.viewModel.isCurrentPageValid).to(beTrue())
                viewController.rightBarButtonPressed(UIBarButtonItem(customView: UIView()))
                expect(viewController.viewModel.currentPageIndex).to(equal(2))
                expect(viewController.viewModel.isCurrentPageValid).to(beTrue())
                viewController.rightBarButtonPressed(UIBarButtonItem(customView: UIView()))
                expect(viewController.viewModel.currentPageIndex).to(equal(3))
                expect(viewController.thankYouViewController).toNot(beNil())

                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { feedbackResults, redirectToAppStore in
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

extension PassiveFormControllerTest: UsabillaDelegate {
    func formDidLoad(form: UINavigationController) {

    }

    func formDidFailLoading(error: UBError) {
        
    }

    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        onWillClose?(results, isRedirectToAppStoreEnabled)
    }

    func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        onDidClose?(results, isRedirectToAppStoreEnabled)
    }
}
