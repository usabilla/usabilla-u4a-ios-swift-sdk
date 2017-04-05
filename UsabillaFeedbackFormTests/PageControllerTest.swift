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
        var moodCell: RootCellView!

        beforeSuite {
            formModel = UBMock.formMock()

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))

            viewController = storyboard.instantiateViewController(withIdentifier: "page") as! PageController

            let pageViewModel = PageViewModel(page: formModel.pages.first!)
            viewController.initWithViewModel(pageViewModel)

            // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
            _ = viewController.view

            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            moodCell = viewController.tableView.visibleCells.first as? RootCellView
        }

        beforeEach {

        }

        describe(".viewDidLoad()") {
            beforeEach {
            }

            it("sets the background color") {
                // Since the label is only initialized when the view is loaded, this
                // would fail if we didn't access the view in the `beforeEach` above.
                expect(viewController.view.backgroundColor).to(equal(viewController.pageViewModel.theme.backgroundColor))
                expect(viewController.tableView.backgroundColor).to(equal(viewController.pageViewModel.theme.backgroundColor))
            }

            it("sets up the header") {
                let header = viewController.tableView.tableHeaderView as? UILabel
                expect(header).toNot(beNil())
                expect(header?.text).to(equal(viewController.pageViewModel.copy.errorMessage))
                expect(header?.textColor).to(equal(viewController.pageViewModel.theme.textColor))
                expect(header?.font).to(equal(viewController.pageViewModel.theme.font.withSize(viewController.pageViewModel.theme.miniFontSize)))
                expect(header?.backgroundColor).to(equal(viewController.pageViewModel.theme.backgroundColor))
            }

            it("sets up the variables") {
                expect(viewController.pageViewModel.dynamicFields).to(equal([1, 2]))
            }

            it("sets up the tableview") {
                expect(viewController.tableView.visibleCells.count).to(equal(7))
                //expect(viewController.showErrorMessages).to(equal(false))
            }
        }

        describe("turns the page only on valid data") {
            beforeEach {
                let field = viewController.pageViewModel.cellViewModels.first?.componentViewModel as? MoodComponentViewModel
                field?.value = nil
            }

            it("shows an error message on the mood field") {
                expect(moodCell?.errorLabel.isHidden).to(beFalse())
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
