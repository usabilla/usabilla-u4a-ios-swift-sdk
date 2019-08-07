//
//  UBSADrawingViewTests.swift
//  UsabillaTests
//
//  Created by Hitesh Jain on 07/08/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class UBSADrawingViewTests: QuickSpec {
    
    override func spec() {
        
        describe("UBSADrawingView"){
            
            var view: UBSADrawingView!
            
            beforeEach {
                view = UBSADrawingView(frame: .zero)
            }
            
            context("When initialized") {
                it("sets the background color") {
                    expect(view.backgroundColor).to(equal(UIColor.clear))
                }
                
                it("should have default tool as pen and default pen as marker") {
                    expect(view.drawTool).to(equal(.pen))
                    expect(view.drawingPenType).to(equal(.marker))
                }
                
                it("should have marker color black , width 12 point and color alpha 1") {
                    expect(view.lineColor).to(equal(UIColor.black))
                    expect(view.lineWidth).to(equal(12))
                    expect(view.lineAlpha).to(equal(1))
                }
            }
            
            context("When drawing is not began") {
                it("should not have undo enabled") {
                    expect(view.canUndo()).to(equal(false))
                }
            }
        }
    }
}
