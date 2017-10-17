//
//  ComponentViewModelFactoryTests.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class ComponentViewModelFactoryTests: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test")
        let theme = UsabillaTheme()

        describe("ComponentViewModelFactoryTests") {
            context("when model is CheckBox") {
                it("should return a ChecboxComponentViewModel") {
                    let model = CheckboxFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is CheckBoxComponentViewModel).to(beTrue())
                }
            }

            context("when model is PickerFieldModel") {
                it("should return a PickerComponentViewModel") {
                    let model = PickerFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is PickerComponentViewModel).to(beTrue())
                }
            }

            context("when model is EmailFieldModel") {
                it("should return a EmailComponentViewModel") {
                    let model = EmailFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is EmailComponentViewModel).to(beTrue())
                }
            }

            context("when model is HeaderFieldModel") {
                it("should return a HeaderComponentViewModel") {
                    let model = HeaderFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is HeaderComponentViewModel).to(beTrue())
                }
            }

            context("when model is MoodFieldModel") {
                it("should return a MoodComponentViewModel") {
                    let model = MoodFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is MoodComponentViewModel).to(beTrue())
                }
            }

            context("when model is ParagraphFieldModel") {
                it("should return a ParagraphComponentViewModel") {
                    let model = ParagraphFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is ParagraphComponentViewModel).to(beTrue())
                }
            }

            context("when model is RadioFieldModel") {
                it("should return a RadioComponentViewModel") {
                    let model = RadioFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is RadioComponentViewModel).to(beTrue())
                }
            }

            context("when model is ScreenshotModel") {
                it("should return a ScreenshotComponentViewModel") {
                    let model = ScreenshotModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is ScreenshotComponentViewModel).to(beTrue())
                }
            }

            context("when model is RatingFieldModel") {
                it("should return a SliderComponentViewModel") {
                    let model = RatingFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is SliderComponentViewModel).to(beTrue())
                }
            }

            context("when model is TextAreaFieldModel") {
                it("should return a TextAreaComponentViewModel") {
                    let model = TextAreaFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is TextAreaComponentViewModel).to(beTrue())
                }
            }

            context("when model is TextFieldModel") {
                it("should return a TextFieldComponentViewModel") {
                    let model = TextFieldModel(json: JSON(parseJSON: ""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model, theme: theme)
                    expect(component is TextFieldComponentViewModel).to(beTrue())
                }
            }
        }
    }
}
