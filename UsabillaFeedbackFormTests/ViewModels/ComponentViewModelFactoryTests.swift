//
//  ComponentViewModelFactoryTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

class ComponentViewModelFactoryTests: QuickSpec {

    override func spec() {
        let pageModel = PageModel(pageNumber: 0, pageName: "test", theme: UsabillaTheme())
        describe("ComponentViewModelFactoryTests") {
            context("when model is CheckBox") {
                it("should return a ChecboxComponentViewModel") {
                    let model = CheckboxFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is CheckBoxComponentViewModel).to(beTrue())
                }
            }

            context("when model is ChoiceFieldModel") {
                it("should return a ChoiceComponentViewModel") {
                    let model = ChoiceFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is ChoiceComponentViewModel).to(beTrue())
                }
            }

            context("when model is EmailFieldModel") {
                it("should return a EmailComponentViewModel") {
                    let model = EmailFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is EmailComponentViewModel).to(beTrue())
                }
            }

            context("when model is HeaderFieldModel") {
                it("should return a HeaderComponentViewModel") {
                    let model = HeaderFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is HeaderComponentViewModel).to(beTrue())
                }
            }

            context("when model is MoodFieldModel") {
                it("should return a MoodComponentViewModel") {
                    let model = MoodFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is MoodComponentViewModel).to(beTrue())
                }
            }

            context("when model is ParagraphFieldModel") {
                it("should return a ParagraphComponentViewModel") {
                    let model = ParagraphFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is ParagraphComponentViewModel).to(beTrue())
                }
            }

            context("when model is RadioFieldModel") {
                it("should return a RadioComponentViewModel") {
                    let model = RadioFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is RadioComponentViewModel).to(beTrue())
                }
            }

            context("when model is ScreenshotModel") {
                it("should return a ScreenshotComponentViewModel") {
                    let model = ScreenshotModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is ScreenshotComponentViewModel).to(beTrue())
                }
            }

            context("when model is RatingFieldModel") {
                it("should return a SliderComponentViewModel") {
                    let model = RatingFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is SliderComponentViewModel).to(beTrue())
                }
            }

            context("when model is TextAreaFieldModel") {
                it("should return a TextAreaComponentViewModel") {
                    let model = TextAreaFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is TextAreaComponentViewModel).to(beTrue())
                }
            }

            context("when model is TextFieldModel") {
                it("should return a TextFieldComponentViewModel") {
                    let model = TextFieldModel(json: JSON.parse(""), pageModel: pageModel)
                    let component = ComponentViewModelFactory.component(field: model)
                    expect(component is TextFieldComponentViewModel).to(beTrue())
                }
            }
        }
    }
}
