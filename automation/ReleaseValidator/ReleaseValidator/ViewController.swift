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
        Usabilla.loadFeedbackForm("5c419a8cd9209606f31f9c36")//5a16d9c67d66810f2248aad9")
    }
}

extension ViewController: UsabillaDelegate {
    func formDidLoad(form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }
    
    func formDidFailLoading(error: UBError) {
        
    }
}
