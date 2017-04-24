//
//  PageControllerTest.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 23/05/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import UsabillaFeedbackForm


// swiftlint:disable force_cast
class PageControllerTest: QuickSpec {

    override func spec() {
        var viewController: PageController!
        var formModel: FormModel!
        var moodCell: MoodCellView!
        
        beforeSuite {
            let path = Bundle(for: JSONParserTest.self).path(forResource: "test", ofType: "json")!
            do {
                let data = try NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: data as Data)
                formModel = JSONFormParser.parseFormJson(jsonObj, appId: "a", screenshot: nil, themeConfig: UsabillaThemeConfigurator())

            } catch let error as NSError {
                Swift.debugPrint(error.localizedDescription)
            }

            let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
            
            viewController = storyboard.instantiateViewController(withIdentifier: "page") as! PageController
            
            viewController.initWithPage(formModel.pages.first!)

            // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
            _ = viewController.view

            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
            moodCell = viewController.tableView.visibleCells.first as? MoodCellView

        }

        beforeEach {

        }

        describe(".viewDidLoad()") {
            beforeEach {
            }

            it("sets the background color") {
                // Since the label is only initialized when the view is loaded, this
                // would fail if we didn't access the view in the `beforeEach` above.
                expect(viewController.view.backgroundColor).to(equal(viewController.pageModel.themeConfig.backgroundColor))
                expect(viewController.tableView.backgroundColor).to(equal(viewController.pageModel.themeConfig.backgroundColor))
            }
            
            it("sets up the header") {
                let header = viewController.tableView.tableHeaderView as? UILabel
                expect(header).toNot(beNil())
                expect(header?.text).to(equal(viewController.pageModel.copy?.errorMessage))
                expect(header?.textColor).to(equal(viewController.pageModel.themeConfig.textColor))
                expect(header?.font).to(equal(viewController.pageModel.themeConfig.font.withSize(viewController.pageModel.themeConfig.miniFontSize)))
                expect(header?.backgroundColor).to(equal(viewController.pageModel.themeConfig.backgroundColor))
            }
            
            it("sets up the variables") {
                expect(viewController.dynamicFields).to(equal([[0, 1], [0, 2]]))
            }
            
            it("sets up the tableview") {
                expect(viewController.tableView.visibleCells.count).to(equal(7))
                //expect(viewController.showErrorMessages).to(equal(false))
            }
            
            

        }
        
        describe("turns the page only on valid data") {

            beforeEach {
                let field = viewController.pageModel.fields.first as? IntFieldModel
                field?.fieldValue = nil
            }
            
            it("returns false if not correctly filled") {
                expect(viewController.isCorrectlyFilled()).to(beFalse())
            }
            
            it("shows an error message on the mood field") {
                expect(moodCell?.errorLabel.isHidden).to(beFalse())
            }
            
            it("returns true if correctly filled") {
                moodCell?.moodModel.fieldValue = 2
                expect(viewController.isCorrectlyFilled()).to(beTrue())
            }
        }
        
        
        describe("jumping to the next page") {
            
            it("should be correct") {
                expect(viewController.whereShouldIJump()).to(equal("Third"))
                let npsModel = viewController.pageModel.fields[2] as! RatingFieldModel
                npsModel.fieldValue = 2
                expect(viewController.whereShouldIJump()).to(equal("second"))
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
