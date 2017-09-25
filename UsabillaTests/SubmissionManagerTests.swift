//
//  SubmissionManagerTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 26/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Usabilla

class ReachabilityMock: Reachable {
    var reachable: Bool = true {
        didSet {
            if oldValue == false && reachable == true {
                whenReachable?(Reachability()!)
            }
        }
    }

    var whenReachable: ((Reachability) -> Void)?

    var currentReachabilityStatus: Reachability.NetworkStatus {
        return reachable ? Reachability.NetworkStatus.reachableViaWiFi : Reachability.NetworkStatus.notReachable
    }
    var isReachable: Bool {
        return reachable
    }

    func startNotifier() throws {

    }
}

class SubmissionManagerTests: QuickSpec {

    override func spec() {
        var formModel: FormModel?
        let reachabilityMock = ReachabilityMock()
        var sm: SubmissionManager!

        describe("The SubmissionManager") {
            beforeEach {
                formModel = UBMock.formMock()
                sm = SubmissionManager(formService: UBFormServiceMock(), reachability: reachabilityMock)
            }

            it("should work online and offline") {
                //set offline
                reachabilityMock.reachable = false
                sm.submit(form: formModel!)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(1))
                sm.submit(form: formModel!)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(2))

                //set online
                reachabilityMock.reachable = true
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(1), timeout: 4)
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(0), timeout: 4)
            }

            it("submit with reachable") {
                sm.submit(form: formModel!)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(1))
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(0), timeout: 4)
            }

            it("submit with custom vars, screenshot") {
                sm.userContext = ["test": "test"]
                sm.submit(form: UBMock.formMock())
                let request = UBFeedbackRequestDAO.shared.readAll().first!
                let data = request.payload["data"] as! [String: Any]
                let cv = data["custom_variables"] as! [String: String]
                expect(cv).to(equal(["test": "test"]))
            }
        }
    }
}
