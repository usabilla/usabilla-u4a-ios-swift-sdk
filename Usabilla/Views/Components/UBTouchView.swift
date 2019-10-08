//
//  UBTouchView.swift
//  Usabilla
//
//  Created by Anders Liebl on 08/10/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

// this overrides the  iOS 13 issue with swipe to remove on modal-view
class UBTouchView: UIView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
