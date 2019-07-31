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
    fileprivate var colorPickerView: ColorPickerView?
    fileprivate var drawingToolView: PenToolView?

    override var toolbarButtonImageName: String {
            return "ic_pencil"
    }
    override func bottomMenu(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .white
        
        let colorpickerFrame = CGRect(x: 120, y: 21, width: frame.width - 90, height: frame.height - 21)
        let colorpicker = ColorPickerView(frame: colorpickerFrame)
        colorpicker.delegate = self
        colorPickerView = colorpicker
        view.addSubview(colorpicker)
        // Set the drawingToolView 🙋🏻‍♂️
        let penToolView = PenToolView(frame: CGRect(x: 0, y: 0, width: 120, height: frame.height))
        penToolView.delegate = self
        drawingToolView = penToolView
        view.addSubview(penToolView)

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

    override func finalView() -> UIImageView? {
        if let view = drawingView?.cropedView() {
            return view
        }
        return nil
    }
    override func pluginDidShow() {
        super.pluginDidShow()
        colorPickerView?.selectColor(at: 1, animated: false)
        drawingToolView?.selectedTool = .marker
    }

}

extension DrawingPlugin: ColorPickerViewDelegate {
    func colorPockerView(_ colorPickerView: ColorPickerView, didSelectColor color: UIColor) {
        drawingView?.lineColor = color
        drawingToolView?.togglePenColor(penColor: color)
    }
}

extension DrawingPlugin: PenToolViewDelegate {
    func selectedPenTool(penType: PenType) {
        switch penType {
        case .marker:
            drawingView?.lineWidth = PenStrokeWidth.marker.rawValue
        case .pencil:
            drawingView?.lineWidth = PenStrokeWidth.pencil.rawValue
        }
    }
}
