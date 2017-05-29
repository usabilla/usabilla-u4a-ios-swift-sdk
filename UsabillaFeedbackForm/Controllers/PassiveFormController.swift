//
//  PassiveFormController.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 09/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class PassiveFormController: FormViewControllerDelegate {

    private var results: [FeedbackResult] = []
    private var submissionManager: SubmissionManager!

    init(submissionManager: SubmissionManager) {
        self.submissionManager = submissionManager
    }

    func leftBarButtonTapped(_ formViewController: FormViewController) {
        if !formViewController.viewModel.isItTheEnd {
            results.append(formViewController.viewModel.model.toFeedbackResult(latestPageIndex: formViewController.viewModel.currentPageIndex))
        }

        UsabillaFeedbackForm.delegate?.formDidClose(formViewController.navigationController!, formID: formViewController.viewModel.id, with: results)

        if UsabillaFeedbackForm.dismissAutomatically {
            formViewController.dismiss(animated: true, completion: nil)
        }
    }

    func rightBarButtonTapped(_ formViewController: FormViewController) {
        guard formViewController.viewModel.isItTheEnd else {
            return
        }
        results.append(formViewController.viewModel.model.toFeedbackResult(latestPageIndex: formViewController.viewModel.currentPageIndex))
        submissionManager.submit(form: formViewController.viewModel.model, customVars: formViewController.customVars)
    }
}
