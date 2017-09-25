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
        // swiftlint:disable:next force_unwrapping
        Usabilla.delegate?.formWillClose(formViewController.navigationController!, formID: formViewController.viewModel.id, with: results, isRedirectToAppStoreEnabled: formViewController.viewModel.model.redirectToAppStore)

        if Usabilla.dismissAutomatically {
            formViewController.dismiss(animated: true, completion: nil)
            // swiftlint:disable:next force_unwrapping
            Usabilla.delegate?.formDidClose(formViewController.navigationController!, formID: formViewController.viewModel.id, with: self.results, isRedirectToAppStoreEnabled: formViewController.viewModel.model.redirectToAppStore)
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
