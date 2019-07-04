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
                
                it("sets the navigation buttons") {
                    expect(viewController.navigationItem.leftBarButtonItem?.title).to(equal("Cancel"))
                    expect(viewController.navigationItem.leftBarButtonItem!.isEnabled).to(equal(true))
                }
                
                it("sets the navigation bar") {
                    expect(navigationController?.navigationBar.isTranslucent).to(equal(false))
                    expect(navigationController?.navigationBar.barTintColor).to(equal(UIColor.black))
                    expect(navigationController?.navigationBar.tintColor).to(equal(UIColor.white))
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
