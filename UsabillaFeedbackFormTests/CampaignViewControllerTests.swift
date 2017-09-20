//
//  CampaignViewControllerTests.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 10/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class CampaignViewControllerTests: QuickSpec {

    fileprivate var onDidClose: ((FeedbackResult, Bool) -> Void)?

    override func spec() {
        var viewController: CampaignViewController!
        var submissionManager: CampaignSubmissionRequestManagerProtocol!

        beforeEach {
            submissionManager = CampaignSubmissionRequestManagerMock()
            let formModel = UBMock.formMock()
            let viewModel = CampaignViewModel(form: formModel, manager: submissionManager)
            viewController = CampaignViewController(viewModel: viewModel, delegate: self)
            // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
            _ = viewController.view

            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            self.onDidClose = nil

            UsabillaFeedbackForm.delegate = self
        }

        context("When canceling the campaign immediately") {
            it("should create a valid feedback result") {
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { (feedbackResults, redirect) in
                        expect(feedbackResults.rating).to(beNil())
                        expect(feedbackResults.sent).to(beFalse())
                        expect(feedbackResults.abandonedPageIndex).to(equal(0))
                        done()
                    }
                    viewController.closeCampaign(atPageIndex: 0)
                }
            }
        }

        context("When canceling the campaign after a few pages") {
            it("should create a valid feedback result") {
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { (feedbackResults, redirect) in
                        expect(feedbackResults.rating).to(equal(1))
                        expect(feedbackResults.sent).to(beFalse())
                        expect(feedbackResults.abandonedPageIndex).to(equal(2))
                        done()
                    }

                    let ratignModel = viewController.viewModel.formViewModel.model.pages.first?.fields.first as! MoodFieldModel
                    ratignModel.fieldValue = 1
                    viewController.closeCampaign(atPageIndex: 2)
                }
            }
        }

        context("When completing the campaign") {
            it("should create a valid feedback result") {
                waitUntil(timeout: 5.0) { done in
                    self.onDidClose = { (feedbackResults, redirect) in
                        expect(feedbackResults.rating).to(equal(5))
                        expect(feedbackResults.sent).to(beTrue())
                        expect(feedbackResults.abandonedPageIndex).to(beNil())
                        expect(redirect).to(beFalse())
                        done()
                    }

                    let ratignModel = viewController.viewModel.formViewModel.model.pages.first?.fields.first as! MoodFieldModel
                    ratignModel.fieldValue = 5
                    viewController.closeCampaign()
                }
            }
        }
    }
}

extension CampaignViewControllerTests: UsabillaFeedbackFormDelegate {
    func formLoadedCorrectly(_ form: UINavigationController) {
    }

    func formFailedLoading() {
    }

    func campaignDidClose(_ campaign: UIViewController, with feedbackResult: FeedbackResult, isRedirectToAppStoreEnabled: Bool) {
        onDidClose?(feedbackResult, isRedirectToAppStoreEnabled)
    }
}

extension CampaignViewControllerTests: CampaignViewControllerDelegate {
    func campaignDidEnd(){}
}
