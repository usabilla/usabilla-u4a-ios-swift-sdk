//
//  PageViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class PageViewModelTests: QuickSpec {

    override func spec() {

        var viewModel: PageViewModel!
        var pageModel: PageModel!
        var formModel: FormModel!

        beforeSuite {
            let path = Bundle(for: PageViewModelTests.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj = JSON(data: data as Data)
                formModel = FormModel(json: jsonObj, id: "a", themeConfig: UsabillaThemeConfigurator(), screenshot: nil)
                pageModel = formModel.pages[0]
            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }
        }

        describe("PageViewModelTests") {

            it("should correctly map fields") {
                viewModel = PageViewModel(page: pageModel)
                expect(viewModel.cellViewModels.count).to(equal(6))
                expect(viewModel.dynamicFields.count).to(equal(2))
                expect(viewModel.errorMessage).to(equal(pageModel.errorMessage))
                expect(viewModel.numberOfCells).to(equal(6))
            }

            context("when viewModelForCellAt is called ") {
                it("should return the correct viewModel when called with right index") {
                    var cellViewModel = viewModel.viewModelForCellAt(index: 0)
                    expect(cellViewModel?.model is MoodFieldModel).to(beTrue())

                    cellViewModel = viewModel.viewModelForCellAt(index: 1)
                    expect(cellViewModel?.model is ParagraphFieldModel).to(beTrue())
                }

                it("should return nil when called with wrong index") {
                    var cellViewModel = viewModel.viewModelForCellAt(index: -1)
                    expect(cellViewModel).to(beNil())

                    cellViewModel = viewModel.viewModelForCellAt(index: 10)
                    expect(cellViewModel).to(beNil())
                }
            }
        }
    }
}
