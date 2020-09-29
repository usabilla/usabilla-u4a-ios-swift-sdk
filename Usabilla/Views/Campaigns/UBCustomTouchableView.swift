//
//  UBCustomTouchableView.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBCustomTouchableView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view != self {
            return view
        }
        while !(view is PassthroughWindow) {
            view = view?.superview
        }
        return view
    }
}
