//
//  CellViewModelTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 26/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

//swiftlint:disable force_cast

import Quick
import Nimble

@testable import Usabilla

class CellViewModelTests: QuickSpec {

    class MockCellViewModelDelegate: CellViewModelDelegate {
        var onValueDidChange: ((BaseFieldModel) -> Void)?
        func valueDidChange(model: BaseFieldModel) {
            onValueDidChange?(model)
        }
    }

    override func spec() {
        var form: FormModel!
        var field: BaseFieldModel!
        let theme = UsabillaTheme()
        var cellViewModel: CellViewModel!

        describe("CellViewModelTests") {
            beforeEach {
                form = UBMock.formMock()
                field = form.pages.first?.fields.first as! MoodFieldModel
                cellViewModel = CellViewModel(model: field, theme: theme, copy: CopyModel())
            }
            context("when model is valid") {
                beforeEach {
                    let mood = (field as! MoodFieldModel)
                    mood.fieldValue = 3
                }
                it("cellViewModel should be valid if the cell is visible") {
                    expect(cellViewModel.isViewCurrentlyVisible).to(beTrue())
                    expect(cellViewModel.isValid).to(beTrue())
                }
                it("cellViewModel should be valid if the cell is invisible") {
                    let showHideRule = ShowHideRule(dependsOnID: "mood", targetValues: ["5"], pageModel: form.pages.first!, show: true)
                    let mood = (field as! MoodFieldModel)
                    mood.rule = showHideRule
                    cellViewModel.updateVisibility()
                    expect(cellViewModel.isViewCurrentlyVisible).to(beFalse())
                    expect(cellViewModel.isValid).to(beTrue())
                }
            }
            context("when model is invalid") {
                it("cellViewModel should be invalid if the cell is visible") {
                    cellViewModel.updateVisibility()
                    expect(cellViewModel.isViewCurrentlyVisible).to(beTrue())
                    expect(cellViewModel.isValid).to(beFalse())
                }
                it("cellViewModel should be valid if the cell is not visible") {
                    let showHideRule = ShowHideRule(dependsOnID: "mood", targetValues: ["5"], pageModel: form.pages.first!, show: true)
                    let mood = (field as! MoodFieldModel)
                    mood.rule = showHideRule
                    cellViewModel.updateVisibility()
                    expect(cellViewModel.isViewCurrentlyVisible).to(beFalse())
                    expect(cellViewModel.isValid).to(beTrue())
                }
            }
            context("when updating value") {
                it("should notify the delegate") {
                    let delegate = MockCellViewModelDelegate()
                    cellViewModel.delegate = delegate
                    waitUntil(timeout: DispatchTimeInterval.seconds(1)) { done in
                        delegate.onValueDidChange = { model in
                            expect(model.fieldID).to(equal(field.fieldID))
                            done()
                        }
                        cellViewModel.valueDidChange()
                    }
                }
            }
        }
    }
}
