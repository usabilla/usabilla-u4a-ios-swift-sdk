//
//  ClientModelTest.swift
//  Usabilla
//
//  Created by Anders Liebl on 11/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import Usabilla

class ClientModelTests: QuickSpec {
    override func spec() {
        var clientModel: ClientModel!
        describe("Init ClientModel ") {
            beforeEach {
                clientModel = ClientModel()
            }

            context("When Adding key - value, json should output correct") {
                it("Should have the key-values inside the behavior object") {
                    clientModel.addBehaviour("Test","Result")
                    let json = String(describing:clientModel.toJson())
                    expect(json).to(equal("[\"behaviour\": [\"Test\": \"Result\"]]"))
                }
             }
        }
    }
}
