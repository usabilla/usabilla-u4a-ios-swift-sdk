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
                DataStore.feedbacks.forEach { _ in
                    DataStore.removeFeedback(index: 0)
                }
                let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
                do {
                    let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                    let jsonObj = JSON(data: data as Data)
                    formModel = FormModel(json: jsonObj, id: "a", themeConfig: UsabillaThemeConfigurator(), screenshot: nil)
                } catch {
                    fail()
                }

                sm = SubmissionManager(reachability: reachabilityMock)
            }

            it("SubmissionManager submit without reachability") {
                reachabilityMock.reachable = false
                SubmissionManager.submit(sm)(form: formModel!, customVars: nil)
                expect(DataStore.feedbacks.count).to(equal(1))
                SubmissionManager.submit(sm)(form: formModel!, customVars: nil)
                expect(DataStore.feedbacks.count).to(equal(2))
            }

            it("SubmissionManager enable reachability should send data") {
                reachabilityMock.reachable = true
                expect(DataStore.feedbacks.count).toEventually(equal(1), timeout: 4)
                expect(DataStore.feedbacks.count).toEventually(equal(0), timeout: 4)
            }

            it("SubmissionManager submit with reachability") {
                SubmissionManager.submit(sm)(form: formModel!, customVars: nil)
                expect(DataStore.feedbacks.count).to(equal(1))
                expect(DataStore.feedbacks.count).toEventually(equal(0), timeout: 4)
            }

            it("SubmissionManager submit with custom vars, screenshot") {
                let screenshost = ScreenshotModel(json: JSON.parse("{\"title\":\"test\", \"name\": \"myField\"}"), pageModel: formModel!.pages.first!)
                screenshost.image = Icons.imageOfPoweredBy(color: .blue)
                formModel?.pages.first?.fields.append(screenshost)
                formModel?.isDefault = true
                SubmissionManager.submit(sm)(form: formModel!, customVars: ["test": "test"])
                expect(DataStore.feedbacks.count).to(equal(1))
                expect(DataStore.feedbacks.count).toEventually(equal(0), timeout: 4)
            }

        }
    }
}
