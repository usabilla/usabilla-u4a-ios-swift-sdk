//
//  UBCameraViewControllerTest.swift
//  UsabillaTests
//
//  Created by Hitesh Jain on 04/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBCameraViewControllerTest: QuickSpec {
    
    override func spec() {
        var viewController: UBCameraViewController!
        var navigationController: UBNavigationController!
        
        beforeSuite {
            viewController = UBCameraViewController()
            navigationController = UBNavigationController(rootViewController: viewController)
            _ = navigationController
            // Method #1: Access the view to trigger UBCameraViewController.viewDidLoad().
            _ = viewController.view
            // Method #2: Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events.
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
        }
        
        beforeEach {
            
        }
        describe("basics") {
            
            describe("viewWillAppear") {
                
                it("sets the back buttons") {
                    expect(viewController.backButton.titleLabel?.text).to(equal("Cancel"))
                }
            }
            
            describe("viewDidLoad") {
                
                it("sets the background color") {
                    expect(viewController.view.backgroundColor).to(equal(UIColor.black))
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
