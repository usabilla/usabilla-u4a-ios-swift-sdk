//
//  HeaderComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 27/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class HeaderComponentViewModel: BaseStringComponentViewModel<HeaderFieldModel>, Centerable {
    var isCentered: Bool = false

    override var cardBackGroundColor: UIColor? {
        get {
            return .clear
        }
        set {
            _ = newValue
        }
    }
}
