//
//  PromiseTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 18/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class PromiseTest: QuickSpec {

    override func spec() {

        describe("Promise") {
            it("Promise succeed") {
                waitUntil(timeout: 2.0) { done in
                    Promise<Bool> { fullfilled, _ in
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 100)) {
                            fullfilled(true)
                        }
                    }.then { success in
                        expect(success).to(beTrue())
                        done()
                    }.catch { _ in
                        fail("should not go here")

                    }

                }
            }

            it("Promise failure") {
                waitUntil(timeout: 2.0) { done in
                    Promise<Bool> { _, reject in
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 100)) {
                            reject(NSError(domain: "", code: 0, userInfo: nil))
                        }
                    }.then { _ in
                        fail("should not go here")

                    }.catch { err in
                        expect(err).toNot(beNil())
                        done()
                    }

                }
            }

            it("Promise succeed without async") {
                waitUntil(timeout: 2.0) { done in
                    Promise<Bool> { fullfilled, _ in
                        fullfilled(true)

                    }.then { success in
                        expect(success).to(beTrue())
                        done()
                    }.catch { _ in
                        fail("should not go here")

                    }

                }
            }

            it("Promise failure without async") {
                waitUntil(timeout: 2.0) { done in
                    Promise<Bool> { _, reject in
                        reject(NSError(domain: "", code: 0, userInfo: nil))
                    }.then { _ in
                        fail("should not go here")

                    }.catch { err in
                        expect(err).toNot(beNil())
                        done()
                    }

                }
            }

        }
    }
}
