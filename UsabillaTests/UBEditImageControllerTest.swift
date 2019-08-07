//
//  UBEditImageControllerTest.swift
//  Usabilla
//
//  Created by Anders Liebl on 04/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import Quick
import Nimble
import UIKit
@testable import Usabilla

class UBEditImageControllerTest: QuickSpec {
    
    fileprivate var doneRight: (() -> Void)?
    fileprivate var doneLeft: (() -> Void)?
    
    override func spec() {
        var viewController: UBEditImageMainViewController!
        var formModel: FormModel!
        
        describe("UBEditPageControllerTest init from Camera") {
            beforeEach {
                let path = Bundle(for: UBEditImageControllerTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as Data?)!)
                formModel = FormModel(json: jsonObj, id: "a", screenshot: nil, maskModel: nil, client: ClientModel())
                
                viewController = UBEditImageMainViewController( theme: formModel!.theme, client: formModel.client!)
                
                
                // Method #1: Access the view to trigger viewDidLoad().
                _ = viewController.view
                
                // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            }
            describe("viewDidLoad") {
                
                it("sets the buttons correct when added from camera") {
                    let testImage = UIImage(named: "a") ?? UIImage()
                    viewController.addBaseImage(image: testImage, source: .camera)
                    expect(viewController.leftButton.titleLabel!.text).to(equal("Retake"))
                    expect(viewController.rightButton.titleLabel!.text).to(equal("Add"))
                }

                it("sets the buttons correct when added from library") {
                    let testImage = UIImage(named: "a") ?? UIImage()
                    viewController.addBaseImage(image: testImage, source: .library)
                    expect(viewController.leftButton.titleLabel!.text).to(equal("Library"))
                    expect(viewController.rightButton.titleLabel!.text).to(equal("Add"))
                }
            }
            
            describe(".viewWillDisappear()") {
                beforeEach {
                    // Method #3: Directly call the lifecycle event.
                    viewController.viewWillDisappear(false)
                }
                
            }
        }
 
        describe("UBEditPageControllerTest init from Library") {
            beforeEach {
                let path = Bundle(for: UBEditImageControllerTest.self).path(forResource: "test", ofType: "json")!
                let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
                let jsonObj: JSON = JSON(data: (data as Data?)!)
                formModel = FormModel(json: jsonObj, id: "a", screenshot: nil, maskModel: nil, client: ClientModel())
                viewController = UBEditImageMainViewController( theme: formModel!.theme, client: formModel.client!)
                
                // Method #1: Access the view to trigger BananaViewController.viewDidLoad().
                _ = viewController.view
                
                // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
                viewController.beginAppearanceTransition(true, animated: false)
                viewController.endAppearanceTransition()
            }
            describe("viewDidLoad") {
                
                it("sets the  buttons") {
                    let testImage = UIImage(named: "a") ?? UIImage()
                    viewController.addBaseImage(image: testImage, source: .library)
                    
                    expect(viewController.leftButton.titleLabel!.text).to(equal("Library"))
                    expect(viewController.rightButton.titleLabel!.text).to(equal("Add"))
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
}
