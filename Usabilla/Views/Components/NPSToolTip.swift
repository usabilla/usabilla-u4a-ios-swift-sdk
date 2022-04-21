//
//  NPSToolTip.swift
//  Usabilla
//
//  Created by Benjamin Grima on 13/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class NPSToolTip: UIView {

    let icon: NPSToolTipIcon = {
        let icon = NPSToolTipIcon()
        icon.backgroundColor = .clear
        return icon
    }()
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    var text: String? {
        set {
            label.text = newValue
            label.sizeToFit()
            label.center = CGPoint(x: self.frame.width / 2, y: 20)
        }
        get {
            return label.text
        }
    }

    required convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 35, height: 46))
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    func internalInit() {
        addSubviews(icon, label)
        icon.frame = self.bounds
    }
}

// MARK: Generated with PaintCode (drawing)

class NPSToolTipIcon: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        NPSToolTipIcon.drawCanvas1(frame: rect, color: tintColor)
    }

    class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 35, height: 46), color: UIColor) {
        //// General Declarations
        // swiftlint:disable:next force_unwrapping
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = apply(rect: CGRect(x: 0, y: 0, width: 35, height: 46), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 35, y: resizedFrame.height / 46)

        //// Color Declarations
        let fillColor = color

        //// Shape Drawing
        let shapePath = UIBezierPath()
        shapePath.move(to: CGPoint(x: 2.79, y: 26.51))
        shapePath.addLine(to: CGPoint(x: 2.88, y: 26.63))
        shapePath.addCurve(to: CGPoint(x: 3.21, y: 27.11), controlPoint1: CGPoint(x: 2.99, y: 26.79), controlPoint2: CGPoint(x: 3.1, y: 26.94))
        shapePath.addLine(to: CGPoint(x: 15.88, y: 45))
        shapePath.addCurve(to: CGPoint(x: 17.5, y: 45.83), controlPoint1: CGPoint(x: 16.25, y: 45.52), controlPoint2: CGPoint(x: 16.85, y: 45.83))
        shapePath.addCurve(to: CGPoint(x: 19.12, y: 45), controlPoint1: CGPoint(x: 18.15, y: 45.83), controlPoint2: CGPoint(x: 18.75, y: 45.52))
        shapePath.addLine(to: CGPoint(x: 31.76, y: 27.13))
        shapePath.addCurve(to: CGPoint(x: 32.12, y: 26.65), controlPoint1: CGPoint(x: 31.88, y: 26.96), controlPoint2: CGPoint(x: 32, y: 26.8))
        shapePath.addLine(to: CGPoint(x: 32.19, y: 26.53))
        shapePath.addLine(to: CGPoint(x: 32.19, y: 26.53))
        shapePath.addCurve(to: CGPoint(x: 28.97, y: 4.21), controlPoint1: CGPoint(x: 36.92, y: 19.34), controlPoint2: CGPoint(x: 35.55, y: 9.82))
        shapePath.addCurve(to: CGPoint(x: 6.03, y: 4.21), controlPoint1: CGPoint(x: 22.39, y: -1.4), controlPoint2: CGPoint(x: 12.61, y: -1.4))
        shapePath.addCurve(to: CGPoint(x: 2.8, y: 26.53), controlPoint1: CGPoint(x: -0.55, y: 9.82), controlPoint2: CGPoint(x: -1.93, y: 19.34))
        shapePath.addLine(to: CGPoint(x: 2.79, y: 26.51))
        shapePath.close()
        fillColor.setFill()
        shapePath.fill()

        context.restoreGState()
    }

    class func apply(rect: CGRect, target: CGRect) -> CGRect {
        if rect == target || target == CGRect.zero {
            return rect
        }

        var scales = CGSize.zero
        scales.width = abs(target.width / rect.width)
        scales.height = abs(target.height / rect.height)

        scales.width = min(scales.width, scales.height)
        scales.height = scales.width

        var result = rect.standardized
        result.size.width *= scales.width
        result.size.height *= scales.height
        result.origin.x = target.minX + (target.width - result.width) / 2
        result.origin.y = target.minY + (target.height - result.height) / 2
        return result
    }
}
