//
//  ViewController.swift
//  SwiftDevApp
//
//  Created by Giacomo Pinato on 21/06/16.
//  Copyright © 2016 usabilla. All rights reserved.
//

import UIKit
import UsabillaFeedbackForm

class ViewController: UIViewController, UsabillaFeedbackFormDelegate {

    let themeConfig = UsabillaThemeConfigurator()
    var customVariables: [String: Any] = [:]
    var configurator: UsabillaThemeConfigurator!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UsabillaFeedbackForm.delegate = self
        UsabillaFeedbackForm.showCancelButton = true
        UsabillaFeedbackForm.appStoreId = "asdasd"
        //UsabillaFeedbackForm.localizedStringFile = "asd"

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        customVariables["customerId"] = "As123Bc"
        customVariables["happynessRating"] = 100

        let off = UIImage(named: "catoff")!
        let on = UIImage(named: "caton")!

        themeConfig.fullStar = UIImage(named: "caton")
        themeConfig.emptyStar = UIImage(named: "catoff")
        themeConfig.enabledEmoticons = [on, on, on, on, on]
        themeConfig.disabledEmoticons = [off, off, off, off, off]
        //themeConfig.customFont = UIFont(name: "batang", size: 12)

        UsabillaFeedbackForm.hideGiveMoreFeedback = false

        configurator = UsabillaThemeConfigurator()
        configurator.titleColor = UIColor.orange
        configurator.textColor = UIColor.black
        configurator.accentColor = UIColor.orange
        configurator.textOnAccentColor = UIColor.blue
        configurator.errorColor = UIColor.red
        configurator.statusBarColor = UIStatusBarStyle.lightContent

    }

    @IBAction func otherShow(_ sender: AnyObject) {
        UsabillaFeedbackForm.loadFeedbackForm("583c0d8ea935028022c145f4", screenshot: UsabillaFeedbackForm.takeScreenshot(self.view), customVariables: customVariables)
    }

    @IBAction func show(_ sender: Any) {
        UsabillaFeedbackForm.loadFeedbackForm("57ea3cacaaba75e6addebf7b", screenshot: nil, customVariables: customVariables, themeConfig: configurator)
    }

    func formFailedLoading(_ backupForm: UINavigationController) {
        present(backupForm, animated: true, completion: nil)
    }

    func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {
        present(form, animated: true, completion: nil)
    }
}
