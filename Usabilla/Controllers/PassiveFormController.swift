//
//  PassiveFormController.swift
//  Usabilla
//
//  Created by Benjamin Grima on 09/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PassiveFormController: FormViewControllerDelegate {

    private var results: [FeedbackResult] = []
    private var submissionManager: SubmissionManager

    init(submissionManager: SubmissionManager) {
        self.submissionManager = submissionManager
    }

    func formWillClose(_ formViewController: FormViewController) {
        if !formViewController.viewModel.isItTheEnd {
            results.append(formViewController.viewModel.model.toFeedbackResult(latestPageIndex: formViewController.viewModel.currentPageIndex))
        }
        try? UsabillaInternal.delegate?.feedbackResultSubmited(userResponse: formViewController.viewModel.model.toJson())
        // swiftlint:disable:next force_unwrapping
        UsabillaInternal.delegate?.formWillClose(form: formViewController.navigationController!, formID: formViewController.viewModel.id, withFeedbackResults: results, isRedirectToAppStoreEnabled: formViewController.viewModel.model.redirectToAppStore)

        if UsabillaInternal.dismissAutomatically {
            formViewController.dismiss(animated: true, completion: nil)
            UsabillaInternal.delegate?.formDidClose(formID: formViewController.viewModel.id, withFeedbackResults: self.results, isRedirectToAppStoreEnabled: formViewController.viewModel.model.redirectToAppStore)
        }
    }

    func pageDidTurn(oldPageModel: PageModel, oldPageIndex: Int, newPageIndex: Int, nextPageType: PageType, formViewController: FormViewController) {
        guard nextPageType == .end else {
            return
        }
        results.append(formViewController.viewModel.model.toFeedbackResult(latestPageIndex: formViewController.viewModel.currentPageIndex))
        submissionManager.submit(form: formViewController.viewModel.model)

    }

}
