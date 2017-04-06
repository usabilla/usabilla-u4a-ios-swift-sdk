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
            formModel = UBMock.formMock()
            pageModel = formModel.pages[0]
        }

        describe("PageViewModelTests") {
            beforeEach {
                viewModel = PageViewModel(page: pageModel)
            }

            context("When initilized") {
                it("should set correct values") {
                    expect(viewModel.cellViewModels.count).to(equal(6))
                    expect(viewModel.dynamicFields.count).to(equal(2))
                    expect(viewModel.errorMessage).to(equal(pageModel.errorMessage))
                    expect(viewModel.numberOfCells).to(equal(6))
                    expect(viewModel.name).to(equal("start"))
                }
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

            context("When getting next page name") {
                it("should return the right page name with default jumpRule") {
                    let nextPageName = viewModel.nextPageName()
                    expect(nextPageName).to(equal("Third"))
                }
                it("should return the right page name with jumpRule is satisfied") {
                    let npsField = pageModel.fields.first { $0 is RatingFieldModel } as? RatingFieldModel
                    npsField?.fieldValue = 1
                    let nextPageName = viewModel.nextPageName()
                    expect(nextPageName).to(equal("second"))
                }
            }
        }
    }
}
