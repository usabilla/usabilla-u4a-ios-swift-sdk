//
//  PageViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

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
                viewModel = PageViewModel(page: pageModel, theme: UsabillaTheme())
            }

            context("When initilized") {
                it("should set correct values") {
                    expect(viewModel.cellViewModels.count).to(equal(6))
                    expect(viewModel.dynamicFields.count).to(equal(2))
                    expect(viewModel.errorMessage).to(equal(pageModel.errorMessage))
                    expect(viewModel.numberOfCells).to(equal(6))
                    expect(viewModel.name).to(equal("start"))
                    expect(viewModel.indexOfInvalidField()).to(equal(0))
                }
            }

            context("when viewModelForCellAt is called ") {
                it("should return the correct viewModel when called with right index") {
                    var cellViewModel = viewModel.viewModelForCellAt(index: 0)
                    expect(cellViewModel!.model is MoodFieldModel).to(beTrue())

                    cellViewModel = viewModel.viewModelForCellAt(index: 1)
                    expect(cellViewModel!.model is ParagraphFieldModel).to(beTrue())
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
                    let npsField = pageModel.fields.first { $0 is NPSFieldModel } as? NPSFieldModel
                    let npsCellViewModel = viewModel.cellViewModels.first { $0.model is NPSFieldModel }
                    npsField?.fieldValue = 1
                    npsCellViewModel?.valueDidChange()
                    let nextPageName = viewModel.nextPageName()
                    expect(nextPageName).to(equal("second"))
                }
            }

            context("When a field value is updated") {
                var moodField: MoodFieldModel!
                beforeEach {
                    let copy = CopyModel()
                    pageModel = PageModel(pageName: "", type: PageType.form)
                    pageModel.copy = copy
                    moodField = MoodFieldModel(json: "{\"name\":\"mood\"}")
                    moodField.fieldID = "mood1"
                    pageModel.fields = [moodField]
                    viewModel = PageViewModel(page: pageModel, theme: UsabillaTheme())
                }
                it("should set the field value in the page model") {
                    expect(pageModel.fieldValuesCollection.keys.count).to(equal(0))
                    moodField.fieldValue = 1
                    viewModel.valueDidChange(model: moodField)
                    expect(pageModel.fieldValuesCollection.keys.count).to(equal(1))
                    expect(pageModel.fieldValuesCollection["mood1"]).to(equal(["1"]))
                }
                it("should remove the field value in the page model") {
                    moodField.fieldValue = 1
                    viewModel.valueDidChange(model: moodField)
                    expect(pageModel.fieldValuesCollection.keys.count).to(equal(1))
                    expect(pageModel.fieldValuesCollection["mood1"]).to(equal(["1"]))
                    moodField.fieldValue = nil
                    viewModel.valueDidChange(model: moodField)
                    expect(pageModel.fieldValuesCollection.keys.count).to(equal(0))
                }
            }
        }
    }
}
