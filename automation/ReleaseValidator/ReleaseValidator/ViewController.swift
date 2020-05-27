//
//  ViewController.swift
//  ReleaseValidator
//
//  Created by Benjamin Grima on 23/11/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit
import Usabilla

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Usabilla.delegate = self
    }
    
    @IBAction func barButtonFeedbackAction(_ sender: Any) {
        let bundle = Bundle(for: AppDelegate.self)
        let formID = bundle.infoDictionary!["USABILLA_FORM_ID"] as? String ?? ""
        Usabilla.loadFeedbackForm(formID)
    }
}

extension ViewController: UsabillaDelegate {
    func formDidLoad(form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }
    
    func formDidFailLoading(error: UBError) {
        print("Error - \(error)")
    }
}
