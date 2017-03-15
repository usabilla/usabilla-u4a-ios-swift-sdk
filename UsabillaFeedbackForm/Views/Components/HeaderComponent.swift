//
//  HeaderComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 02/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class HeaderComponent: BaseLabelComponent {

    override func build() {
        super.build()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    }
}
