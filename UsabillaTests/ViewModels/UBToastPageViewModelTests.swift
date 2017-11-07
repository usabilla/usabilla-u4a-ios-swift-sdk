//
//  UBToastPageViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBToastPageViewModelTests: QuickSpec {

    var endPageModel: UBEndPageModel!
    var formModel: FormModel!

    override func spec() {
        describe("UBToastPageViewModelTests") {
            beforeSuite {
                let path = Bundle(for: UBToastPageViewModelTests.self).path(forResource: "CampaignForm", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let json = JSON(data: (data as Data?)!)
                self.formModel = FormModel(json: json, id: "a", screenshot: nil)
                self.endPageModel = self.formModel.pages.last as? UBEndPageModel
            }

            context("When initilized") {
                it("should have the correct data") {
                    let paragraphFieldModel = self.endPageModel.fields.first as? ParagraphFieldModel

                    let toastViewModel = UBToastPageViewModel(model: self.endPageModel)
                    expect(toastViewModel.text).to(equal(paragraphFieldModel?.fieldValue))
                    expect(toastViewModel.text).to(equal("Thanks!"))
                }
            }
        }
    }
}
