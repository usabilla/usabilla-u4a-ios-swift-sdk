//
//  SubmissionManagerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 26/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import UsabillaFeedbackForm

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

class SubmissionManagerTest: QuickSpec {

    override func spec() {
        var formModel: FormModel?
        let reachabilityMock = ReachabilityMock()
        var sm: SubmissionManager!

        describe("SubmissionManager test") {
            it("SubmissionManager init") {
                //initialization code not in a before suite to not overlap with DataStore unit tests
                formModel = UBMock.formMock()
                sm = SubmissionManager(formService: UBFormServiceMock(), reachability: reachabilityMock)
            }

            it("SubmissionManager should work online and offline") {
                //set offline
                reachabilityMock.reachable = false
                sm.submit(form: formModel!, customVars: nil)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(1))
                sm.submit(form: formModel!, customVars: nil)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(2))

                //set online
                reachabilityMock.reachable = true
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(1), timeout: 4)
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(0), timeout: 4)
            }

            it("SubmissionManager submit with reachability") {
                sm.submit(form: formModel!, customVars: nil)
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(1))
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(0), timeout: 4)
            }

            it("SubmissionManager submit with custom vars, screenshot") {
                let screenshost = ScreenshotModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: formModel!.pages.first!)
                screenshost.image = Icons.imageOfPoweredBy(color: .blue)
                formModel?.pages.first?.fields.append(screenshost)
                formModel?.isDefault = true
                sm.submit(form: formModel!, customVars: ["test": "test"])
                expect(UBFeedbackRequestDAO.shared.readAll().count).to(equal(1))
                expect(UBFeedbackRequestDAO.shared.readAll().count).toEventually(equal(0), timeout: 4)
            }
        }
    }
}
