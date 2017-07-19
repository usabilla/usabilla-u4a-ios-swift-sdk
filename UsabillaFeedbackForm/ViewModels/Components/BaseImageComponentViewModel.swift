//
//  BaseImageComponentViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class BaseImageComponentViewModel<T: ImageComponentModel>: BaseComponentViewModel<UIImage, T> {
    override var value: UIImage? {
        get {
            return model.image
        }
        set {
            model.image = newValue
        }
    }
}
