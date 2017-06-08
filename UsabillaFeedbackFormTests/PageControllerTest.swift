//
//  PageControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 23/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import UsabillaFeedbackForm

// swiftlint:disable force_cast
class PageControllerTest: QuickSpec {

    override func spec() {
        var viewController: PageController!
        var formModel: FormModel!

        beforeSuite {
            formModel = UBMock.formMock()
            let pageViewModel = PageViewModel(page: formModel.pages.first!, theme: UsabillaTheme())
            viewController = PageController(viewModel: pageViewModel)

            // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
            _ = viewController.view

            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
        }

        beforeEach {

        }

        describe(".viewDidLoad()") {
            beforeEach {
            }

            it("sets the background color") {
                // Since the label is only initialized when the view is loaded, this
                // would fail if we didn't access the view in the `beforeEach` above.
                expect(viewController.view.backgroundColor).to(equal(viewController.viewModel.theme.backgroundColor))
                expect(viewController.tableView.backgroundColor).to(equal(viewController.viewModel.theme.backgroundColor))
            }

            it("sets up the header") {
                let headerWrapper = viewController.tableView.tableHeaderView
                let header = headerWrapper?.subviews.first as? UILabel
                expect(header).toNot(beNil())
                expect(header?.text).to(equal(viewController.viewModel.copy.errorMessage))
                expect(header?.textColor).to(equal(viewController.viewModel.theme.textColor))
                expect(header?.font).to(equal(viewController.viewModel.theme.font.withSize(viewController.viewModel.theme.miniFontSize)))
                expect(header?.backgroundColor).to(equal(viewController.viewModel.theme.backgroundColor))
            }

            it("sets up the variables") {
                expect(viewController.viewModel.dynamicFields).to(equal([1, 2]))
            }
        }

        describe("turns the page only on valid data") {
            beforeEach {
                let field = viewController.viewModel.cellViewModels.first?.componentViewModel as? MoodComponentViewModel
                field?.value = nil
            }
        }

        describe(".viewWillDisappear()") {
            beforeEach {
                // Method #3: Directly call the lifecycle event.
                viewController.viewWillDisappear(false)
            }
        }
    }
}
