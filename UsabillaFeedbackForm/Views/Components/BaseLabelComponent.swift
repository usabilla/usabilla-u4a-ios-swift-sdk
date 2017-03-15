//
//  BaseLabelComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 02/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseLabelComponent: UBComponent<String> {

    var label: UILabel!

    override func build() {
        label = UILabel()
        label.text = value
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        addSubview(label)

        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
