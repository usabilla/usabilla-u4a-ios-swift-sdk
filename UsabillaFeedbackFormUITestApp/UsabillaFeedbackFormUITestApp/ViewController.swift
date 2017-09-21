//
//  ViewController.swift
//  UsabillaFeedbackFormUITestApp
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//
// swiftlint:disable force_try
import UIKit
import UsabillaFeedbackForm

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UsabillaFeedbackForm.delegate = self
        UsabillaFeedbackForm.hideGiveMoreFeedback = false

        UsabillaFeedbackForm.dismissAutomatically = false
    }

    @IBAction func scenarioAction(_ sender: UIButton) {
        let scenarioName = sender.accessibilityIdentifier!

        let path = Bundle(for: ViewController.self).path(forResource: scenarioName, ofType: "json")!
        let data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let json: JSON = JSON(data: data as Data)

        if let controller = UsabillaFeedbackForm.formViewController(forFormJson: json) {
            self.present(controller, animated: true)
        }
    }
}

extension ViewController: UsabillaFeedbackFormDelegate {

    func formFailedLoading() {

    }

    func formLoadedCorrectly(_ form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }

    func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult]) {
        form.dismiss(animated: true, completion: nil)
    }
}
