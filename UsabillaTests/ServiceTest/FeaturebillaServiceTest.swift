//
//  FeaturebillaServiceTest.swift
//  Usabilla
//
//  Created by Hitesh Jain on 25/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class FeaturebillaServiceTest: QuickSpec {
    override func spec() {

        describe("FeaturebillaService") {

            context("When getSettings is called") {
                it("should succeed if request succeeds") {
                    let validData = try! UBMock.json(fromFile:"Featurebilla").rawData()
                    let validJSON = try! JSONSerialization.jsonObject(with: validData, options: .allowFragments)
                    UBHTTPMock.response = HTTPClientResponse(data: validJSON, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: DispatchTimeInterval.seconds(2)) { done in
                        FeaturebillaService(httpClient: UBHTTPMock.self).getSettings().then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
                it("should fail if request fails") {
                    waitUntil(timeout: DispatchTimeInterval.seconds(2)) { done in
                        FeaturebillaService(httpClient: UBHTTPMockFail.self).getSettings().then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
                it("should fail if there is no data nor error") {
                    UBHTTPMock.response = HTTPClientResponse(data: nil, headers: nil, error: nil, success: true, isChanged: true)
                    waitUntil(timeout: DispatchTimeInterval.seconds(2)) { done in
                        FeaturebillaService(httpClient: UBHTTPMock.self).getSettings().then { _ in
                            fail("should not go here")
                        }.catch { _ in
                            done()
                        }
                    }
                }
            }
        }
    }
}
