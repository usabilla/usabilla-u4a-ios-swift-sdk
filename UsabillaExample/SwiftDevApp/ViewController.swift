//
//  ViewController.swift
//  SwiftDevApp
//
//  Created by Giacomo Pinato on 21/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import UIKit
import Usabilla

class ViewController: UIViewController, UsabillaDelegate {

    let themeConfig = UsabillaTheme()
    var customVariables: [String: Any] = [:]
    var configurator: UsabillaTheme!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Usabilla.initialize(appID: nil)
        Usabilla.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        customVariables["customerId"] = "As123Bc"
        customVariables["happynessRating"] = 100
        Usabilla.customVariables = customVariables
        Usabilla.hideGiveMoreFeedback = false
    }

    @IBAction func otherShow(_ sender: AnyObject) {
        Usabilla.loadFeedbackForm("583c0d8ea935028022c145f4")
    }

    @IBAction func show(_ sender: Any) {
        Usabilla.loadFeedbackForm("57ea3cacaaba75e6addebf7b")
    }
    
    func formLoadedCorrectly(_ form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }
    
    func formFailedLoading() {
//        present(backupForm, animated: true, completion: nil)
    }
}
