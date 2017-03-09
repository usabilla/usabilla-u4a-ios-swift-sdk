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

    func leftBarButtonTapped(_ formViewController: FormViewController) {
        let i = formViewController.currentPage

        if formViewController.currentPageModel?.type != .end {
            results.append(formViewController.formModel.toFeedbackResult(latestPageIndex: i))
        }

        UsabillaFeedbackForm.delegate?.formDidClose(formID: formViewController.formModel.appId, with: results)

        if UsabillaFeedbackForm.dismissAutomatically {
            formViewController.dismiss(animated: true, completion: nil)
        }
    }

    func rightBarButtonTapped(_ formViewController: FormViewController) {
        guard formViewController.currentPageModel?.type == .end else {
            return
        }
        results.append(formViewController.formModel.toFeedbackResult(latestPageIndex: formViewController.currentPage))
        SubmissionManager.shared.submit(form: formViewController.formModel, customVars: formViewController.customVars)
    }
}
