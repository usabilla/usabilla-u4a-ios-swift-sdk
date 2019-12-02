//
//  FeaturebillaStoreTests.swift
//  UsabillaTests
//
//  Created by Hitesh Jain on 27/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class FeaturebillaStoreTests: QuickSpec {
    
    var featurebillaStore: FeaturebillaStore!
    var featurebillaService: FeaturebillaServiceProtocol!

    override func spec() {

        beforeSuite {
            self.featurebillaService = FeaturebillaService()
            self.featurebillaStore = FeaturebillaStore(service: self.featurebillaService)
        }
        
        describe("FeaturebillaStoreTests") {

        context("When calling loadSettings", {
            it("Should succeed and return settingModel from network", closure: {
                waitUntil(timeout: 2.0) { done in
                    let promise = self.featurebillaStore.loadSettings()
                    promise.then { settingModel in
                        expect(settingModel.self).toNot(beNil())
                        expect(settingModel.settings.count).to(equal(2))
                        done()
                    }.catch { _ in
                        fail("should not go here")
                    }
                }
            })
            })
        }
    }
}
