//
//  ChoiceComponentviewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ChoiceComponentViewModelTests: QuickSpec {

    func getJSONFromFile(named name: String) -> JSON {
        let path = Bundle(for: ChoiceComponentViewModelTests.self).path(forResource: name, ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        return JSON(data: (data as Data?)!)
    }

    override func spec() {

        var viewModelEmpty: ChoiceComponentViewModel!
        var modelEmpty: ChoiceFieldModel!

        var viewModelDefault: ChoiceComponentViewModel!
        var modelDefault: ChoiceFieldModel!

        var viewModel: ChoiceComponentViewModel!
        var model: ChoiceFieldModel!

        let pageModel = PageModel(pageNumber: 0, pageName: "")

        beforeEach {
            var jsonObj = self.getJSONFromFile(named: "PickerWithEmpty")
            modelEmpty = ChoiceFieldModel(json: jsonObj, pageModel: pageModel)
            viewModelEmpty = ChoiceComponentViewModel(model: modelEmpty, theme: UsabillaTheme())

            jsonObj = self.getJSONFromFile(named: "PickerWithDefault")
            modelDefault = ChoiceFieldModel(json: jsonObj, pageModel: pageModel)
            viewModelDefault = ChoiceComponentViewModel(model: modelDefault, theme: UsabillaTheme())

            jsonObj = self.getJSONFromFile(named: "Picker")
            model = ChoiceFieldModel(json: jsonObj, pageModel: pageModel)
            viewModel = ChoiceComponentViewModel(model: model, theme: UsabillaTheme())

        }

        describe("ChoiceComponentviewModelEmptyTests") {
            it("viewModelEmpty options should match model options") {
                expect(modelEmpty.options.count).to(equal(viewModelEmpty.options.count))
            }

            context("when updating value") {
                it("should update model") {
                    viewModelEmpty.value = "hello"
                    expect(modelEmpty.fieldValue).to(equal(["hello"]))
                }

                it("should update viewModelEmpty") {
                    viewModelEmpty.value = "hi"
                    expect(viewModelEmpty.value).to(equal("hi"))
                }
            }

            context("when retrieving the picker Button") {
                it("should return the correct picker button title when a value is selected") {
                    modelEmpty.fieldValue = ["Option_1"]
                    modelDefault.fieldValue = ["Option_1"]
                    model.fieldValue = ["Option_1"]
                    expect(viewModelDefault.pickerButtonTitle).to(equal("Option 1"))
                    expect(viewModel.pickerButtonTitle).to(equal("Option 1"))
                    expect(viewModelEmpty.pickerButtonTitle).to(equal("Option 1"))
                }
                it("should return the correct picker button title with no value selected and empty button") {
                    modelEmpty.fieldValue = []
                    expect(viewModelEmpty.pickerButtonTitle).to(equal("Empty"))
                }
                it("should return the correct picker button title with no value selected and no empty button") {
                    modelDefault.fieldValue = []
                    model.fieldValue = []
                    expect(viewModelDefault.pickerButtonTitle).to(beNil())
                    expect(viewModel.pickerButtonTitle).to(beNil())
                }
                it("should return default value if there is one") {
                    expect(viewModelDefault.value).to(equal("Option_3"))
                    expect(modelDefault.fieldValue).to(equal(["Option_3"]))
                    expect(viewModelDefault.pickerButtonTitle).to(equal("Option 3"))
                    expect(viewModel.pickerButtonTitle).to(beNil())
                }
            }

            context("when retrieving the index of the selected element") {
                it("should return nil when no element is selected") {
                    modelEmpty.fieldValue = []
                    modelDefault.fieldValue = []
                    model.fieldValue = []
                    expect(viewModelDefault.indexOfSelectedOption).to(beNil())
                    expect(viewModel.indexOfSelectedOption).to(beNil())
                    expect(viewModelEmpty.indexOfSelectedOption).to(beNil())
                }
                it("should return the correct index for the default value") {
                    expect(viewModelDefault.indexOfSelectedOption).to(equal(2))
                }
                it("should return the correct index  when a value is selected") {
                    modelEmpty.fieldValue = ["Option_1"]
                    modelDefault.fieldValue = ["Option_1"]
                    model.fieldValue = ["Option_1"]
                    expect(viewModelDefault.indexOfSelectedOption).to(equal(0))
                    expect(viewModel.indexOfSelectedOption).to(equal(0))
                    expect(viewModelEmpty.indexOfSelectedOption).to(equal(0))
                }
            }
        }
    }
}
