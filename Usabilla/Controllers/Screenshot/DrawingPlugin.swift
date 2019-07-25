//
//  DummyPlugin.swift
//  Usabilla
//
//  Created by Anders Liebl on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

class DrawingPlugin: UBSAPluginViewController {
    fileprivate var drawingView: UBSADrawingView?

    override var toolbarButtonImageName: String {
            return "ic_pencil"
    }
    override func bottomMenu(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        return view
    }

    override func topMenuType() -> UBSATopMenuType {
        return .iconsUndoDone
    }
    
    override func canvas(frame: CGRect) -> UIView {
        let draw = UBSADrawingView(frame: frame)
        drawingView = draw
        return draw
    }

    override func undoAction() {
        drawingView?.undo()
    }
    override func finalView() -> UIImageView {
        if let view = drawingView?.cropedView() {
            return view
        }
        return UIImageView()
    }
}
