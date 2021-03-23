//
//  TelemetryServiceTest.swift
//  Usabilla
//
//  Created by Anders Liebl on 23/03/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class TelemetryServiceTest: QuickSpec {

   
    override func spec() {
        describe("TelemtryService") {
            context("When Submitting a telemetry data") {
                it("should succeed without an AppId") {
                    UBHTTPMock.response = HTTPClientResponse(data: "", headers: nil, error: nil, success: true, isChanged: true)
                    let telemtryService = TelemtryService(requestBuilder: RequestBuilder.self, httpClient: UBHTTPMock.self)

                    waitUntil(timeout: DispatchTimeInterval.seconds(10)) { done in
                        let promise = telemtryService.submitTelemtryData(appId: "", body: "TestData")
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
 
                it("should succeed without an body") {
                    UBHTTPMock.response = HTTPClientResponse(data: "", headers: nil, error: nil, success: true, isChanged: true)
                    let telemtryService = TelemtryService(requestBuilder: RequestBuilder.self, httpClient: UBHTTPMock.self)

                    waitUntil(timeout: DispatchTimeInterval.seconds(10)) { done in
                        let promise = telemtryService.submitTelemtryData(appId: "345-23423412-21412", body: "")
                        promise.then { _ in
                            done()
                        }.catch { _ in
                            fail("should not go here")
                        }
                    }
                }
}

        }
    }
}
