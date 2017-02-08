//
//  ViewController.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import UsabillaFeedbackForm

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UsabillaFeedbackForm.delegate = self
        UsabillaFeedbackForm.hideGiveMoreFeedback = false
        UsabillaFeedbackForm.showCancelButton = true
        UsabillaFeedbackForm.dismissAutomatically = false
    }
    
    @IBAction func scenario1ButtonTap(_ sender: Any) {
        UsabillaFeedbackForm.loadFeedbackForm("583c0d8ea935028022c145f4")
    }
}

extension ViewController: UsabillaFeedbackFormDelegate {
    
    func formFailedLoading(_ backupForm: UINavigationController) {
        
    }
    
    func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {
        present(form, animated: true, completion: nil)
    }
    
    func formDidClose(formID: String, with feedbackResults: [FeedbackResult]) {
        dismiss(animated: true, completion: nil)
    }
}
