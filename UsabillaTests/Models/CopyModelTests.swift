//
//  CopyModelTests.swift
//  Usabilla
//
//  Created by Adil Bougamza on 24/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class CopyModelTests: QuickSpec {

    var copyModelJson: [String: Any] = [:]
    let appTitle = "appTitle", appSubmit = "appSubmit", errorMessage = "errorMessage"
    let navigationNext = "navigationNext", cancelButton = "cancelButton", screenshotTitle = "screenshotTitle", appStore = "appStore"
    let introCancel = "introCancelButton", introContinue = "introContinueButton"

    override func spec() {

        describe("") {
            beforeEach {
                self.copyModelJson["data"] = [self.appTitle: "title", self.appSubmit: "submit", self.errorMessage: "error"]
                self.copyModelJson["localization"] = [self.navigationNext: "Next", self.cancelButton: "Cancel", self.screenshotTitle: "Screenshot", self.appStore: "Go to the app store", self.introCancel: "Cancel", self.introContinue: "Continue"]
            }

            context("When CopyModel is initialized", {
                it("Should have right values", closure: {
                    let json = JSON(self.copyModelJson)
                    let copyModel = CopyModel(json: json)
                    expect(copyModel).toNot(beNil())

                    expect(copyModel.navigationNext).to(equal("Next"))
                    expect(copyModel.cancelButton).to(equal("Cancel"))
                    expect(copyModel.screenshotTitle).to(equal("Screenshot"))
                    expect(copyModel.cancelButton).to(equal("Cancel"))
                    expect(copyModel.introCancelButton).to(equal("Cancel"))
                    expect(copyModel.introContinueButton).to(equal("Continue"))

                    expect(copyModel.appTitle).to(equal("title"))
                    expect(copyModel.navigationSubmit).to(equal("submit"))
                    expect(copyModel.errorMessage).to(equal("error"))
                })
            })
        }
    }
}
