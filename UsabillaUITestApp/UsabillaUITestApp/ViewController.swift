//
//  ViewController.swift
//  UsabillaUITestApp
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//
// swiftlint:disable force_try
import UIKit
import Usabilla

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Usabilla.delegate = self
        Usabilla.dismissAutomatically = false
    }

    @IBAction func scenarioAction(_ sender: UIButton) {
        // swiftlint:disable:next force_unwrapping
        let scenarioName = sender.accessibilityIdentifier!
        // swiftlint:disable:next force_unwrapping
        let path = Bundle(for: ViewController.self).path(forResource: scenarioName, ofType: "json")!
        let data = try! NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)

        if let controller = Usabilla.formViewController(forFormData: data as Data) {
            self.present(controller, animated: true)
        }
    }
}

extension ViewController: UsabillaDelegate {

    func formDidFailLoading(error: UBError) {

    }

    func formDidLoad(form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }

    func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
        form.dismiss(animated: true, completion: nil)
    }
}
