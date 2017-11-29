//
//  PickerComponentViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class PickerComponentViewModelTests: QuickSpec {
    override func spec() {

        var viewModelEmpty: PickerComponentViewModel!
        var modelEmpty: PickerFieldModel!

        var viewModelDefault: PickerComponentViewModel!
        var modelDefault: PickerFieldModel!

        var viewModel: PickerComponentViewModel!
        var model: PickerFieldModel!

        beforeEach {
            var jsonObj = UBMock.json("PickerWithEmpty")!
            modelEmpty = PickerFieldModel(json: jsonObj)
            viewModelEmpty = PickerComponentViewModel(model: modelEmpty, theme: UsabillaTheme())

            jsonObj = UBMock.json("PickerWithDefault")!
            modelDefault = PickerFieldModel(json: jsonObj)
            viewModelDefault = PickerComponentViewModel(model: modelDefault, theme: UsabillaTheme())

            jsonObj = UBMock.json("Picker")!
            model = PickerFieldModel(json: jsonObj)
            viewModel = PickerComponentViewModel(model: model, theme: UsabillaTheme())
        }

        describe("the validation method") {
            it("Should validate if not required") {
                model.required = false
                model.fieldValue = []
                expect(viewModel.model.isValid()).to(beTrue())
            }
            it("Should not validate empty string") {
                model.required = true
                model.fieldValue = [""]
                expect(viewModel.model.isValid()).to(beFalse())
            }

            it("Should not validate nil values") {
                model.required = true
                model.fieldValue = []
                expect(viewModel.model.isValid()).to(beFalse())
            }

            it("Should validate strings") {
                model.required = true
                model.fieldValue = ["a"]
                expect(viewModel.model.isValid()).to(beTrue())
            }
        }

        describe("the json convertion method") {
            it("Should not validate empty string") {
                model.fieldValue = [""]
                expect(viewModel.model.exportableValue).to(beNil())
            }

            it("Should not validate nil values") {
                model.fieldValue = []
                expect(viewModel.model.exportableValue).to(beNil())
            }

            it("Should validate strings") {
                model.fieldValue = ["a"]
                // swiftlint:disable force_cast
                let json = viewModel.model.exportableValue as! [String]
                expect(json).to(equal(["a"]))
            }
        }

        describe("the PickerComponentViewModelTests") {
            it("viewModel options should match model options") {
                expect(modelEmpty.options.count).to(equal(viewModelEmpty.options.count))
            }

            context("when updating value") {
                it("should update model") {
                    viewModelEmpty.value = "hello"
                    expect(modelEmpty.fieldValue).to(equal(["hello"]))
                }
                it("should notify the delegate") {
                    let delegate = MockBaseComponentViewModelDelegate()
                    viewModel.delegate = delegate
                    waitUntil(timeout: 1.0) { done in
                        delegate.onValueDidChange = done
                        viewModel.value = nil
                    }
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
                    expect(viewModelEmpty.indexOfSelectedOption).to(equal(1))
                }
            }
        }
    }
}
