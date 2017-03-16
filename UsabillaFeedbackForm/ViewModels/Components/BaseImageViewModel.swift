//
//  BaseImageViewModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseImageViewModel<T: ImageComponentModel>: BaseComponentViewModel<UIImage, T> {
    override var value: UIImage? {
        get {
            return model.image
        }
        set {
            model.image = newValue
        }
    }
}
