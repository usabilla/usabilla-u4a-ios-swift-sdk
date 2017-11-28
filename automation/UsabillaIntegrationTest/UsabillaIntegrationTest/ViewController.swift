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
    @IBOutlet weak var buttonSend: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "purchaseComplete"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendAction(_ sender: Any) {
        let eventName = textField.text
        Usabilla.sendEvent(event: eventName!)
    }

    @IBAction func resetAction(_ sender: Any) {
        Usabilla.resetCampaignData(completion: nil)
    }
}

