//
//  UBSADrawingView.swift
//  Usabilla
//
//  Created by Hitesh Jain on 24/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

enum UBSADrawingToolType {
    case pen
}

enum ImageRenderingMode {
    case scale
    case original
}

@objc protocol UBSADrawingViewDelegate: NSObjectProtocol {
    @objc optional func drawView(_ view: UBSADrawingView, willBeginDrawUsingTool tool: AnyObject)
    @objc optional func drawView(_ view: UBSADrawingView, didEndDrawUsingTool tool: AnyObject)
}

class UBSADrawingView: UIView {
    var lineColor = UIColor.black
    var lineWidth = CGFloat(12)
    var lineAlpha = CGFloat(1)
    var drawTool: UBSADrawingToolType = .pen
    var drawingPenType: PenType = .normal
    weak var sketchViewDelegate: UBSADrawingViewDelegate?
    private var currentTool: UBSADrawingTool?
    private let pathArray: NSMutableArray = NSMutableArray()
    private var currentPoint: CGPoint?
    private var previousPoint1: CGPoint?
    private var previousPoint2: CGPoint?
    private var image: UIImage?
    private var backgroundImage: UIImage?
    private var drawMode: ImageRenderingMode = .original
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForInitial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareForInitial()
    }

    private func prepareForInitial() {
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        switch drawMode {
        case .original:
            image?.draw(at: CGPoint.zero)
        case .scale:
            image?.draw(in: self.bounds)
        }

        currentTool?.draw()
    }

    private func updateCacheImage(_ isUpdate: Bool) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        if isUpdate {
            image = nil
            switch drawMode {
            case .original:
                if let backgroundImage = backgroundImage {
                    guard let copyImage: UIImage = backgroundImage.copy() as? UIImage else { return }
                    copyImage.draw(at: CGPoint.zero)
                }
            case .scale:
                guard let copyImage: UIImage = backgroundImage?.copy() as? UIImage else { return }
                copyImage.draw(in: self.bounds)
            }

            for obj in pathArray {
                if let tool = obj as? UBSADrawingTool {
                    tool.draw()
                }
            }
        } else {
            switch drawMode {
            case .original:
                image?.draw(at: .zero)
            case .scale:
                image?.draw(in: self.bounds)
            }
            currentTool?.draw()
        }

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func toolWithCurrentSettings() -> UBSADrawingTool? {
        switch drawTool {
        case .pen:
            return PenTool()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        if currentTool != nil {
            finishDrawing()
        }

        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        // swiftlint:disable:next force_unwrapping
        currentTool = toolWithCurrentSettings()!
        currentTool?.lineWidth = lineWidth
        currentTool?.lineColor = lineColor
        currentTool?.lineAlpha = lineAlpha

        sketchViewDelegate?.drawView?(self, willBeginDrawUsingTool: currentTool as AnyObject)

        switch currentTool {
        case is PenTool:
            guard let penTool = currentTool as? PenTool else { return }
            pathArray.add(penTool)
            penTool.drawingPenType = drawingPenType
            // swiftlint:disable:next force_unwrapping
            penTool.setInitialPoint(currentPoint!)
        default:
            guard let currentTool = currentTool else { return }
            pathArray.add(currentTool)
            // swiftlint:disable:next force_unwrapping
            currentTool.setInitialPoint(currentPoint!)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        previousPoint2 = previousPoint1
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)

        if let penTool = currentTool as? PenTool {
            // swiftlint:disable:next force_unwrapping
            let renderingBox = penTool.createBezierRenderingBox(previousPoint2!, widhPreviousPoint: previousPoint1!, withCurrentPoint: currentPoint!)

            setNeedsDisplay(renderingBox)
        } else {
            // swiftlint:disable:next force_unwrapping
            currentTool?.moveFromPoint(previousPoint1!, toPoint: currentPoint!)
            setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
        finishDrawing()
    }

    fileprivate func finishDrawing() {
        updateCacheImage(false)
        sketchViewDelegate?.drawView?(self, didEndDrawUsingTool: currentTool as AnyObject)
        currentTool = nil
    }

    private func resetTool() {
        currentTool = nil
    }

    func clear() {
        resetTool()
        pathArray.removeAllObjects()
        updateCacheImage(true)
        
        setNeedsDisplay()
    }

    func undo() {
        if canUndo() {
            resetTool()
            pathArray.removeLastObject()
            updateCacheImage(true)

            setNeedsDisplay()
        }
    }

    func canUndo() -> Bool {
        return pathArray.count > 0
    }

    func done() {
        print("am here")
    }
}

extension UIView {
    var screenCapture: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        // swiftlint:disable:next force_unwrapping
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
