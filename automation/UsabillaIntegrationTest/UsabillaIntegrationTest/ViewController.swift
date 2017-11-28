//
//  ViewController.swift
//  UsabillaIntegrationTest
//
//  Created by Benjamin Grima on 27/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import Usabilla

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "purchaseComplete"

        Usabilla.customVariables = ["frequent flyer status": "sky elite"]
    }

    @IBAction func sendAction(_ sender: Any) {
        let eventName = textField.text
        Usabilla.sendEvent(event: eventName!)
    }

    @IBAction func resetAction(_ sender: Any) {
        Usabilla.resetCampaignData(completion: nil)
    }
}

