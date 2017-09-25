//
//  ComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class BaseComponentViewModel<T, V: ComponentModel>: ComponentViewModel {
    var model: V
    let theme: UsabillaTheme

    var value: T?

    init(model: V, theme: UsabillaTheme) {
        self.model = model
        self.theme = theme
    }
}
