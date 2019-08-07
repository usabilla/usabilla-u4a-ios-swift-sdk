//
//  PenToolViewTests.swift
//  UsabillaTests
//
//  Created by Hitesh Jain on 07/08/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Quick
import Nimble

@testable import Usabilla

class PenToolViewTests: QuickSpec {
    
    override func spec() {
        
        describe("PenToolView"){
            
            var view: PenToolView!
            
            beforeEach {
                view = PenToolView(frame: .zero)
            }
            
            context("When initialized") {
                it("sets the background color") {
                    expect(view.backgroundColor).to(equal(UIColor.clear))
                }
                
                it("default pen as marker and color as black") {
                    expect(view.selectedTool).to(equal(.marker))
                    expect(view.selectedColor).to(equal(.black))
                }
            }
            
            context("When Color toggled") {
                beforeEach {
                   let _ = view.togglePenColor(penColor: .white)
                }
                it("should toggle to white color") {
                    expect(view.selectedTool).to(equal(.marker))
                    expect(view.selectedColor).to(equal(.white))
                }
            }
            
            context("When Marker Clicked") {
                beforeEach {
                    let _ = view.markerClicked()
                    let _ = view.togglePenColor(penColor: .white)
                }
                it("should toggle to marker with white color") {
                    expect(view.selectedTool).to(equal(.marker))
                    expect(view.selectedColor).to(equal(.white))
                }
            }
            
            context("When Pencil Clicked") {
                beforeEach {
                    let _ = view.pencilClicked()
                    let _ = view.togglePenColor(penColor: .white)
                }
                it("should toggle to pencil with white color") {
                    expect(view.selectedTool).to(equal(.pencil))
                    expect(view.selectedColor).to(equal(.white))
                }
            }
        }
    }
}
