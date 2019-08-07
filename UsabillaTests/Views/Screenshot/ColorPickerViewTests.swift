//
//  ColorPickerViewTests.swift
//  UsabillaTests
//
//  Created by Hitesh Jain on 07/08/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class ColorPickerViewTests: QuickSpec {
    
    override func spec() {
        
        describe("ColorPickerView"){
            
            var view: ColorPickerView!
            
            beforeEach {
                view = ColorPickerView(frame: .zero)
            }
            
            context("When initialized") {
                it("sets the background color") {
                    expect(view.backgroundColor).to(equal(UIColor.clear))
                }
                
                it("should have 4 basic color") {
                    expect(view.colors.count).to(equal(4))
                    expect(view.colors.first).to(equal(UIColor.black))
                }
            }
        }
    }
}
