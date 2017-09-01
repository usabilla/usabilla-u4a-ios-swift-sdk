//
//  UBFormViewModelTests.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 04/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble

@testable import UsabillaFeedbackForm

class UBFormViewModelTests: QuickSpec {

    var model: FormModel!
    override func spec() {
        describe("UBFormViewModelTests") {
            beforeEach {
                self.model = UBMock.formMock()
            }

            context("When initilized with correct model") {
                it("should have correct values") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.model).toNot(beNil())
                    expect(formViewModel.currentPageIndex).to(equal(0))
                    expect(formViewModel.currentPageViewModel.name).to(equal("start"))
                    expect(formViewModel.id).to(equal(self.model.identifier))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.25))
                    expect(formViewModel.accentColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.backgrounColor).to(equal(self.model.theme.backgroundColor))
                    expect(formViewModel.statusBarColor).to(equal(self.model.theme.statusBarColor))
                    expect(formViewModel.headerColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.textOnAccentColor).to(equal(self.model.theme.textOnAccentColor))
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))
                    expect(formViewModel.isCurrentPageValid).to(beFalse())
                    expect(formViewModel.firstPageViewModel?.name).to(equal(formViewModel.currentPageViewModel.name))
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationNext))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.nextPageIndex).to(equal(2))
                    expect(formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex).name).to(equal("Third"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                    expect(formViewModel.navigationBarTitle).to(equal("FeedbackTest"))
                }
                it("should have correct value when there is no appTitle") {
                    self.model.copyModel.appTitle = nil
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    expect(formViewModel.navigationBarTitle).to(beNil())
                }
                it("should have correct values if we change default") {
                    let formViewModel = UBFormViewModel(formModel: self.model)

                    // Change theme header Color
                    self.model.theme.headerColor = .red
                    expect(formViewModel.headerColor).to(equal(UIColor.red))
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))
                    self.model.theme.headerColor = nil
                }
                it("should tell if an index is contained in the page view model count") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    expect(formViewModel.model.pages.count).to(equal(4))
                    var containsIndex = formViewModel.containsIndex(index: -1)
                    expect(containsIndex).to(beFalse())
                    containsIndex = formViewModel.containsIndex(index: 9999)
                    expect(containsIndex).to(beFalse())
                    containsIndex = formViewModel.containsIndex(index: 0)
                    expect(containsIndex).to(beTrue())
                    containsIndex = formViewModel.containsIndex(index: 3)
                    expect(containsIndex).to(beTrue())
                }
                it("should go to last PageViewModel") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    expect(formViewModel.model.pages.count).to(equal(4))
                    expect(formViewModel.currentPageIndex).to(equal(0))
                    formViewModel.goToLastPageIndex()
                    expect(formViewModel.currentPageIndex).to(equal(3))
                }
            }

            context("When going to next pages") {
                it("should have correct data if it's a form page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    expect(formViewModel.currentPageIndex).to(equal(2))
                    expect(formViewModel.currentPageViewModel.name).to(equal("Third"))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.75))
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))
                    expect(formViewModel.isCurrentPageValid).to(beTrue())
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationSubmit))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex).name).to(equal("end"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                }
                it("should have correct data if it's an end page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    expect(formViewModel.currentPageIndex).to(equal(3))
                    expect(formViewModel.currentPageViewModel.name).to(equal("end"))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(1))
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))
                    expect(formViewModel.isCurrentPageValid).to(beTrue())
                    expect(formViewModel.rightBarButtonTitle).to(beNil())
                    expect(formViewModel.endPageViewModel).toNot(beNil())
                    expect(formViewModel.isItTheEnd).to(beTrue())
                }
                it("Should have correct rating in end page") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)

                    (self.model.pages.first?.fields.first as? MoodFieldModel)?.fieldValue = 4
                    expect(formViewModel.endPageViewModel?.formRating).to(equal(4))
                }
            }

            context("When formViewModel is reset") {
                it("Should have correct initial data") {
                    let formViewModel = UBFormViewModel(formModel: self.model)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                    formViewModel.reset()

                    expect(formViewModel).toNot(beNil())
                    expect(formViewModel.model).toNot(beNil())
                    expect(formViewModel.currentPageIndex).to(equal(0))
                    expect(formViewModel.currentPageViewModel.name).to(equal("start"))
                    expect(formViewModel.id).to(equal(self.model.identifier))
                    expect(formViewModel.shouldHideProgressBar).to(beTrue())
                    expect(formViewModel.progress).to(equal(0.25))
                    expect(formViewModel.accentColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.statusBarColor).to(equal(self.model.theme.statusBarColor))
                    expect(formViewModel.headerColor).to(equal(self.model.theme.accentColor))
                    expect(formViewModel.cancelButtonTitle).to(equal(self.model.copyModel.cancelButton))
                    expect(formViewModel.isCurrentPageValid).to(beFalse())
                    expect(formViewModel.firstPageViewModel?.name).to(equal(formViewModel.currentPageViewModel.name))
                    expect(formViewModel.rightBarButtonTitle).to(equal(self.model.copyModel.navigationNext))
                    expect(formViewModel.endPageViewModel).to(beNil())
                    expect(formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex).name).to(equal("Third"))
                    expect(formViewModel.isItTheEnd).to(beFalse())
                }

                context("When FormViewModel is initlialized with PageViewModels containing different required fields") {
                    it("should have correct values for showing the requiredFiled header") {
                        let formJson = UBTestHelper.getJSONFromFile(named: "ShouldShowRequiredFieldHeader")
                        let formModel = FormModel(json: formJson, id: "", screenshot: nil)
                        let formViewModel = UBFormViewModel(formModel: formModel)
                        expect(formViewModel).toNot(beNil())

                        let pageVM0 = formViewModel.pageViewModel(atIndex: 0)
                        expect(pageVM0.shouldShowRequiredLabel).to(beTrue())
                        let pageVM1 = formViewModel.pageViewModel(atIndex: 1)
                        expect(pageVM1.shouldShowRequiredLabel).to(beTrue())
                        let pageVM2 = formViewModel.pageViewModel(atIndex: 2)
                        expect(pageVM2.shouldShowRequiredLabel).to(beFalse())
                        let pageVM3 = formViewModel.pageViewModel(atIndex: 3)
                        expect(pageVM3.shouldShowRequiredLabel).to(beTrue())
                    }
                }
            }

            describe("isItTheEnd") {
                context("When formViewModel is a campaign") {
                    var formViewModel: UBFormViewModel!
                    beforeEach {
                        let path = Bundle(for: UBFormViewModelTests.self).path(forResource: "CampaignForm", ofType: "json")!
                        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                        let json = JSON(data: (data as Data?)!)
                        let formModel = FormModel(json: json, id: "", screenshot: nil)
                        formViewModel = UBFormViewModel(formModel: formModel)

                    }
                    it("Should be false when current page is not a toast and not an end page") {
                        expect(formViewModel.currentPageViewModel.model.type).to(equal(PageType.banner))
                        expect(formViewModel.isItTheEnd).to(beFalse())
                    }

                    it("Should be true when current page is a toast") {
                        formViewModel.currentPageViewModel = formViewModel.pageViewModel(atIndex: formViewModel.nextPageIndex)
                        expect(formViewModel.currentPageViewModel.model.type).to(equal(PageType.toast))
                        expect(formViewModel.isItTheEnd).to(beTrue())
                    }
                }
            }
        }
    }
}
