//
//  BaseComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBComponent<CVM : ComponentViewModel>: UIView {
    internal var viewModel: CVM!

    required init(viewModel: CVM) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        build()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func build() {
    }
}
