//
//  DummyPlugin.swift
//  Usabilla
//
//  Created by Anders Liebl on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

struct DrawingPluginValues {
    static let halfAlpha: CGFloat = 0.3
    static let widthPenToolView: CGFloat = 96
    static let distanceFromPenToolView: CGFloat = 24
    static let startPtForColorPickerView: CGFloat = widthPenToolView + distanceFromPenToolView
    static let widthColorPickerView: CGFloat = 192
    static let widthDrawContainerView: CGFloat = startPtForColorPickerView + widthColorPickerView
}

class DrawingPlugin: UBSAPluginViewController {
    fileprivate var drawingView: UBSADrawingView?
    fileprivate var colorPickerView: ColorPickerView?
    fileprivate var drawingToolView: PenToolView?
        override var toolbarButtonImageName: String {
            return "ic_pencil"
    }

    override func bottomMenu(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        let bgcolor: UIColor =  theme?.colors.cardColor ?? .white

        view.backgroundColor = bgcolor

        let drawContainerView = UIView(frame: .zero)
        drawContainerView.backgroundColor = bgcolor
        view.addSubview(drawContainerView)
        drawContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Set the drawingToolView 🙋🏻‍♂️
        let penToolViewFrame = CGRect(x: 0, y: 0, width: DrawingPluginValues.widthPenToolView, height: frame.height)
        let penToolView = PenToolView(frame: penToolViewFrame)
        penToolView.delegate = self
        drawingToolView = penToolView
        drawContainerView.addSubview(penToolView)
        // Set the colorPickerView 🙋🏻‍♂️
        let colorpickerFrame = CGRect(x: DrawingPluginValues.startPtForColorPickerView, y: 0, width: DrawingPluginValues.widthColorPickerView, height: frame.height)
        let colorpicker = ColorPickerView(frame: colorpickerFrame)
        colorpicker.backgroundColor = bgcolor
        colorpicker.delegate = self
        colorPickerView = colorpicker
        drawContainerView.addSubview(colorpicker)

        NSLayoutConstraint.activate([
                drawContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                drawContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                drawContainerView.widthAnchor.constraint(equalToConstant: DrawingPluginValues.widthDrawContainerView),
                drawContainerView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
        return view
    }

    override func topMenuType() -> UBSATopMenuType {
        return .iconsUndoDone
    }

    override func canvas(frame: CGRect) -> UIView {
        let draw = UBSADrawingView(frame: frame)
        drawingView = draw
        drawingView?.sketchViewDelegate = self
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
        colorPickerView?.selectColor(at: 0, animated: false)
        drawingToolView?.selectedTool = .marker
        if let color = theme?.colors {
            let text = color.text
            let bgColor = color.cardColor
            drawingToolView?.textColor = text
            colorPickerView?.externalBorderColor = text
            colorPickerView?.internalBorderColor = bgColor
        }
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
extension DrawingPlugin: UBSADrawingViewDelegate {
    func drawingViewIsNotEmpty(_ status: Bool) {
            self.drawingModeOn(status)
    }
}
