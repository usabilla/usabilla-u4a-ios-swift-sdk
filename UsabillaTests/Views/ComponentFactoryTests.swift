//
//  ComponentFactoryTest.swift
//  Usabilla
//
//  Created by Benjamin Grima on 20/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class ComponentFactoryTests: QuickSpec {

    override func spec() {
        let theme = UsabillaTheme()
        describe("ComponentFactoryTests") {
            context("when model is ChecboxComponentViewModel") {
                it("should viewModel a CheckBoxComponent") {
                    let model = CheckboxFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = CheckBoxComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is CheckBoxComponent).to(beTrue())
                }
            }

            context("when viewModel is PickerComponentViewModel") {
                it("should return a PickerComponent") {
                    let model = PickerFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = PickerComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is PickerComponent).to(beTrue())
                }
            }

            context("when viewModel is EmailComponentViewModel") {
                it("should return a EmailComponent") {
                    let model = EmailFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = EmailComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is EmailComponent).to(beTrue())
                }
            }

            context("when viewModel is HeaderComponentViewModel") {
                it("should return a HeaderComponent") {
                    let model = HeaderFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = HeaderComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is HeaderComponent).to(beTrue())
                }
            }

            context("when viewModel is MoodComponentViewModel") {
                it("should return a MoodComponent") {
                    let model = MoodFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = MoodComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is MoodComponent).to(beTrue())
                }
            }

            context("when viewModel is ParagraphComponentViewModel") {
                it("should return a ParagraphComponent") {
                    let model = ParagraphFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = ParagraphComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is ParagraphComponent).to(beTrue())
                }
            }

            context("when viewModel is RadioComponentViewModel") {
                it("should return a RadioComponent") {
                    let model = RadioFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = RadioComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is RadioComponent).to(beTrue())
                }
            }

            context("when viewModel is ScreenshotComponentViewModel") {
                it("should return a ScreenshotComponent") {
                    let model = ScreenshotModel(json: JSON(parseJSON: ""))
                    let viewModel = ScreenshotComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is ScreenshotComponent).to(beTrue())
                }
            }

            context("when viewModel is SliderComponentViewModel") {
                it("should return a SliderComponent") {
                    let model = RatingFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = SliderComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is SliderComponent).to(beTrue())
                }
            }

            context("when viewModel is TextAreaComponentViewModel") {
                it("should return a TextAreaComponent") {
                    let model = TextAreaFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = TextAreaComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is TextAreaComponent).to(beTrue())
                }
            }

            context("when viewModel is TextFieldComponentViewModel") {
                it("should return a BaseTextFieldComponent") {
                    let model = TextFieldModel(json: JSON(parseJSON: ""))
                    let viewModel = TextFieldComponentViewModel(model: model, theme: theme)
                    let component = ComponentFactory.component(viewModel: viewModel)
                    expect(component is BaseTextFieldComponent<TextFieldComponentViewModel>).to(beTrue())
                }
            }
        }
    }
}
