//
//  BaseComponentViewModelTests.swift
//  UsabillaTests
//
//  Created by Benjamin Grima on 18/12/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class BaseComponentViewModelTests: QuickSpec {

    class MockComponentModel: ComponentModel {
        var onReset: (() -> Void)?
        func reset() {
            onReset?()
        }
    }

    class MockBaseComponentViewModel: BaseComponentViewModel <String, MockComponentModel> {

    }

    var model: MockComponentModel!
    var componentViewModel: ComponentViewModel!

    override func spec() {
        describe("BaseComponentViewModel") {
            context("When the reset method is called") {
                beforeEach {
                    self.model = MockComponentModel()
                    self.componentViewModel = MockBaseComponentViewModel(model: self.model, theme: UsabillaTheme())
                }
                it("should reset the model and call the delegate") {
                    waitUntil(timeout: 1.0) { (done) in
                        self.model.onReset = {
                            done()
                        }
                        self.componentViewModel.reset()
                    }
                }
                it("should notify the delegate") {
                    let delegate = MockBaseComponentViewModelDelegate()
                    self.componentViewModel.delegate = delegate
                    waitUntil(timeout: 1.0) { (done) in
                        delegate.onValueDidChange = {
                            done()
                        }
                        self.componentViewModel.reset()
                    }
                }
            }
        }
    }
}

