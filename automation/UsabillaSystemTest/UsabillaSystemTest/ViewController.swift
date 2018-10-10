//
//  ViewController.swift
//  UsabillaIntegrationTest
//
//  Created by Benjamin Grima on 27/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import Usabilla

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Usabilla.customVariables = ["frequent flyer status": "sky elite"]
        textField.delegate = self
    }

    @IBAction func sendAction(_ sender: Any) {
        textField.resignFirstResponder()
        let eventName = textField.text
        Usabilla.sendEvent(event: eventName!)
    }

    @IBAction func resetAction(_ sender: Any) {
        textField.resignFirstResponder()
        Usabilla.resetCampaignData(completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

