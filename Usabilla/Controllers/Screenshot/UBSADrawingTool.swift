//
//  UBSADrawingTool.swift
//  Usabilla
//
//  Created by Hitesh Jain on 24/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

protocol UBSADrawingTool {
    var lineWidth: CGFloat { get set }
    var lineColor: UIColor { get set }
    var lineAlpha: CGFloat { get set }

    func setInitialPoint(_ firstPoint: CGPoint)
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint)
    func draw()
}

enum PenType {
    case normal
    case thick
}

class PenTool: UIBezierPath, UBSADrawingTool {
    var path: CGMutablePath
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var drawingPenType: PenType

    override init() {
        path = CGMutablePath.init()
        lineColor = .black
        lineAlpha = 0
        drawingPenType = .normal
        super.init()
        lineCapStyle = CGLineCap.round
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInitialPoint(_ firstPoint: CGPoint) {}

    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}

    func createBezierRenderingBox(_ previousPoint2: CGPoint, widhPreviousPoint previousPoint1: CGPoint, withCurrentPoint cpoint: CGPoint) -> CGRect {
        let mid1 = middlePoint(previousPoint1, previousPoint2: previousPoint2)
        let mid2 = middlePoint(cpoint, previousPoint2: previousPoint1)
        let subpath = CGMutablePath.init()

        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint1.x, y: previousPoint1.y))
        path.addPath(subpath)

        var boundingBox: CGRect = subpath.boundingBox
        boundingBox.origin.x -= lineWidth * 2.0
        boundingBox.origin.y -= lineWidth * 2.0
        boundingBox.size.width += lineWidth * 4.0
        boundingBox.size.height += lineWidth * 4.0
        
        return boundingBox
    }
    
    private func middlePoint(_ previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPoint {
        return CGPoint(x: (previousPoint1.x + previousPoint2.x) * 0.5, y: (previousPoint1.y + previousPoint2.y) * 0.5)
    }

    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        switch drawingPenType {
        case .normal:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setBlendMode(.normal)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        case .thick:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setBlendMode(.screen)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        }
    }
}
