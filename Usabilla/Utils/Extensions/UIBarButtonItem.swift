//
//  UIBarButtonItem.swift
//  Usabilla
//
//  Created by Benjamin Grima on 10/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    func setFont(font: UIFont) {
        guard #available(iOS 11, *) else {
            setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
            return
        }
        let states = [
            UIControlState.normal,
            UIControlState.disabled,
            UIControlState.focused,
            UIControlState.highlighted,
            UIControlState.selected
        ]
        // applying this for all the states (fix iOS 11 bug)
        for state in states {
            setTitleTextAttributes([NSFontAttributeName: font], for: state)
        }
    }

    func setTextForegroundColor(color: UIColor) {
        if #available(iOS 11, *) {
            setTitleTextAttributes([NSForegroundColorAttributeName: color], for: .normal)
            return
        }
    }
}
