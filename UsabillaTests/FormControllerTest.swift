//
//  FormControllerTest.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 20/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Quick
import Nimble

@testable import Usabilla

class FormControllerTest: QuickSpec {

    fileprivate var doneRight: (() -> Void)?
    fileprivate var doneLeft: (() -> Void)?

    override func spec() {
        var viewController: FormViewController!
        var formModel: FormModel!

        describe("FormControllerTest ") {
            beforeEach {
                let path = Bundle(for: FormControllerTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as Data?)!)
                formModel = FormModel(json: jsonObj, id: "a", screenshot: nil)

                viewController = FormViewController(viewModel: UBFormViewModel(formModel: formModel))
                viewController.delegate = self

                // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
                _ = viewController.view

                // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            }
            describe("basics") {

                describe("viewDidLoad") {

                    it("sets the progress bar") {
                        // Since the label is only initialized when the view is loaded, this
                        // would fail if we didn't access the view in the `beforeEach` above.
                        expect(viewController.progressBar.progress).to(equal(1.0/3.0))
                    }

                    it("sets the navigation buttons") {
                        expect(viewController.navigationItem.rightBarButtonItem!.title).to(equal("Next"))
                        expect(viewController.navigationItem.leftBarButtonItem!.title).to(equal(formModel.copyModel.cancelButton))
                        expect(viewController.navigationItem.leftBarButtonItem!.isEnabled).to(equal(true))
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

        describe("delegate methods test") {

            it("tap on left button should notify delegate") {
                waitUntil(timeout: 5.0) { done in
                    self.doneLeft = {
                        done()
                    }
                    viewController.cancelButtonPressed(UIBarButtonItem())
                }
            }
        }
    }
}

extension FormControllerTest: FormViewControllerDelegate {

    func formWillClose(_ formViewController: FormViewController) {
        doneLeft?()
    }
    func pageDidTurn(oldPageModel: PageModel, oldPageIndex: Int, newPageIndex: Int, nextPageType: PageType, formViewController: FormViewController) {
        doneRight?()
    }
}
