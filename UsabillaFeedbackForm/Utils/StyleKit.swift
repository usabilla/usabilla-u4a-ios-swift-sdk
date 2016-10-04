//
//  StyleKit.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 14/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class StyleKit {


    //MARK: - Canvas Drawings

    /// Page 1

    class func drawTrash(frame frame: CGRect = CGRect(x: 0, y: 0, width: 34, height: 44), resizing: ResizingBehavior = .AspectFit, themeConfig: UsabillaThemeConfigurator) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize To Frame
        CGContextSaveGState(context)
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 34, height: 44), target: frame)
        CGContextTranslateCTM(context, resizedFrame.minX, resizedFrame.minY)
        let resizedScale = CGSize(width: resizedFrame.width / 34, height: resizedFrame.height / 44)
        CGContextScaleCTM(context, resizedScale.width, resizedScale.height)

        /// trash
        let trash2 = UIBezierPath()
        trash2.moveToPoint(CGPoint(x: 9.27, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 9.27, y: 3.35))
        trash2.addCurveToPoint(CGPoint(x: 12.63, y: 0), controlPoint1: CGPoint(x: 9.27, y: 1.5), controlPoint2: CGPoint(x: 10.77, y: 0))
        trash2.addLineToPoint(CGPoint(x: 21.37, y: 0))
        trash2.addCurveToPoint(CGPoint(x: 24.73, y: 3.35), controlPoint1: CGPoint(x: 23.23, y: 0), controlPoint2: CGPoint(x: 24.73, y: 1.5))
        trash2.addLineToPoint(CGPoint(x: 24.73, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 34, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 34, y: 6.7))
        trash2.addLineToPoint(CGPoint(x: 30.69, y: 6.7))
        trash2.addCurveToPoint(CGPoint(x: 31.84, y: 9.73), controlPoint1: CGPoint(x: 31.48, y: 7.43), controlPoint2: CGPoint(x: 31.94, y: 8.51))
        trash2.addLineToPoint(CGPoint(x: 29.4, y: 40.01))
        trash2.addCurveToPoint(CGPoint(x: 25.09, y: 44), controlPoint1: CGPoint(x: 29.23, y: 42.21), controlPoint2: CGPoint(x: 27.3, y: 44))
        trash2.addLineToPoint(CGPoint(x: 9.22, y: 44))
        trash2.addCurveToPoint(CGPoint(x: 4.99, y: 40.01), controlPoint1: CGPoint(x: 7.02, y: 44), controlPoint2: CGPoint(x: 5.12, y: 42.22))
        trash2.addLineToPoint(CGPoint(x: 3.16, y: 9.73))
        trash2.addCurveToPoint(CGPoint(x: 4.39, y: 6.7), controlPoint1: CGPoint(x: 3.09, y: 8.52), controlPoint2: CGPoint(x: 3.57, y: 7.43))
        trash2.addLineToPoint(CGPoint(x: 0, y: 6.7))
        trash2.addLineToPoint(CGPoint(x: 0, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 9.27, y: 4.78))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 11.33, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 11.33, y: 3.83))
        trash2.addCurveToPoint(CGPoint(x: 13.26, y: 1.91), controlPoint1: CGPoint(x: 11.33, y: 2.76), controlPoint2: CGPoint(x: 12.19, y: 1.91))
        trash2.addLineToPoint(CGPoint(x: 20.74, y: 1.91))
        trash2.addCurveToPoint(CGPoint(x: 22.67, y: 3.83), controlPoint1: CGPoint(x: 21.81, y: 1.91), controlPoint2: CGPoint(x: 22.67, y: 2.77))
        trash2.addLineToPoint(CGPoint(x: 22.67, y: 4.78))
        trash2.addLineToPoint(CGPoint(x: 11.33, y: 4.78))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 5.15, y: 7.65))
        trash2.addLineToPoint(CGPoint(x: 7.2, y: 39.14))
        trash2.addCurveToPoint(CGPoint(x: 9.33, y: 41.13), controlPoint1: CGPoint(x: 7.28, y: 40.24), controlPoint2: CGPoint(x: 8.22, y: 41.13))
        trash2.addLineToPoint(CGPoint(x: 25.36, y: 41.13))
        trash2.addCurveToPoint(CGPoint(x: 27.51, y: 39.14), controlPoint1: CGPoint(x: 26.47, y: 41.13), controlPoint2: CGPoint(x: 27.43, y: 40.23))
        trash2.addLineToPoint(CGPoint(x: 29.88, y: 7.65))
        trash2.addLineToPoint(CGPoint(x: 5.15, y: 7.65))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 9.27, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 10.3, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 12.36, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 11.33, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 9.27, y: 10.52))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 16.48, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 16.48, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 18.55, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 18.55, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 16.48, y: 10.52))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 22.67, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 21.64, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 23.7, y: 37.34))
        trash2.addLineToPoint(CGPoint(x: 24.73, y: 10.52))
        trash2.addLineToPoint(CGPoint(x: 22.67, y: 10.52))
        trash2.closePath()
        trash2.moveToPoint(CGPoint(x: 22.67, y: 10.52))
        CGContextSaveGState(context)
        trash2.usesEvenOddFillRule = true
        themeConfig.textColor.setFill()
        trash2.fill()
        CGContextRestoreGState(context)

        CGContextRestoreGState(context)
    }


    //MARK: - Canvas Images

    /// Page 1

    class func imageOfTrash(size size: CGSize = CGSize(width: 34, height: 44), resizing: ResizingBehavior = .AspectFit, themeConfig: UsabillaThemeConfigurator) -> UIImage {
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        StyleKit.drawTrash(frame: CGRect(origin: CGPoint.zero, size: size), resizing: resizing, themeConfig: themeConfig)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

    class func drawPlus(frame frame: CGRect = CGRect(x: 0, y: 0, width: 44, height: 44), resizing: ResizingBehavior = .AspectFit, themeConfig: UsabillaThemeConfigurator) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize To Frame
        CGContextSaveGState(context)
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 44, height: 44), target: frame)
        CGContextTranslateCTM(context, resizedFrame.minX, resizedFrame.minY)
        let resizedScale = CGSize(width: resizedFrame.width / 44, height: resizedFrame.height / 44)
        CGContextScaleCTM(context, resizedScale.width, resizedScale.height)

        /// Page 1
        let page2 = UIBezierPath()
        page2.moveToPoint(CGPoint(x: 22, y: 42))
        page2.addCurveToPoint(CGPoint(x: 2, y: 22), controlPoint1: CGPoint(x: 10.96, y: 42), controlPoint2: CGPoint(x: 2, y: 33.05))
        page2.addCurveToPoint(CGPoint(x: 22, y: 2), controlPoint1: CGPoint(x: 2, y: 10.96), controlPoint2: CGPoint(x: 10.96, y: 2))
        page2.addCurveToPoint(CGPoint(x: 42, y: 22), controlPoint1: CGPoint(x: 33.05, y: 2), controlPoint2: CGPoint(x: 42, y: 10.96))
        page2.addCurveToPoint(CGPoint(x: 22, y: 42), controlPoint1: CGPoint(x: 42, y: 33.05), controlPoint2: CGPoint(x: 33.05, y: 42))
        page2.moveToPoint(CGPoint(x: 22, y: 0))
        page2.addCurveToPoint(CGPoint(x: 0, y: 22), controlPoint1: CGPoint(x: 9.85, y: 0), controlPoint2: CGPoint(x: 0, y: 9.85))
        page2.addCurveToPoint(CGPoint(x: 22, y: 44), controlPoint1: CGPoint(x: 0, y: 34.15), controlPoint2: CGPoint(x: 9.85, y: 44))
        page2.addCurveToPoint(CGPoint(x: 44, y: 22), controlPoint1: CGPoint(x: 34.15, y: 44), controlPoint2: CGPoint(x: 44, y: 34.15))
        page2.addCurveToPoint(CGPoint(x: 22, y: 0), controlPoint1: CGPoint(x: 44, y: 9.85), controlPoint2: CGPoint(x: 34.15, y: 0))
        page2.moveToPoint(CGPoint(x: 33, y: 21))
        page2.addLineToPoint(CGPoint(x: 23, y: 21))
        page2.addLineToPoint(CGPoint(x: 23, y: 11))
        page2.addCurveToPoint(CGPoint(x: 22, y: 10), controlPoint1: CGPoint(x: 23, y: 10.45), controlPoint2: CGPoint(x: 22.55, y: 10))
        page2.addCurveToPoint(CGPoint(x: 21, y: 11), controlPoint1: CGPoint(x: 21.45, y: 10), controlPoint2: CGPoint(x: 21, y: 10.45))
        page2.addLineToPoint(CGPoint(x: 21, y: 21))
        page2.addLineToPoint(CGPoint(x: 11, y: 21))
        page2.addCurveToPoint(CGPoint(x: 10, y: 22), controlPoint1: CGPoint(x: 10.45, y: 21), controlPoint2: CGPoint(x: 10, y: 21.45))
        page2.addCurveToPoint(CGPoint(x: 11, y: 23), controlPoint1: CGPoint(x: 10, y: 22.55), controlPoint2: CGPoint(x: 10.45, y: 23))
        page2.addLineToPoint(CGPoint(x: 21, y: 23))
        page2.addLineToPoint(CGPoint(x: 21, y: 33))
        page2.addCurveToPoint(CGPoint(x: 22, y: 34), controlPoint1: CGPoint(x: 21, y: 33.55), controlPoint2: CGPoint(x: 21.45, y: 34))
        page2.addCurveToPoint(CGPoint(x: 23, y: 33), controlPoint1: CGPoint(x: 22.55, y: 34), controlPoint2: CGPoint(x: 23, y: 33.55))
        page2.addLineToPoint(CGPoint(x: 23, y: 23))
        page2.addLineToPoint(CGPoint(x: 33, y: 23))
        page2.addCurveToPoint(CGPoint(x: 34, y: 22), controlPoint1: CGPoint(x: 33.55, y: 23), controlPoint2: CGPoint(x: 34, y: 22.55))
        page2.addCurveToPoint(CGPoint(x: 33, y: 21), controlPoint1: CGPoint(x: 34, y: 21.45), controlPoint2: CGPoint(x: 33.55, y: 21))
        CGContextSaveGState(context)
        page2.usesEvenOddFillRule = true
        themeConfig.textColor.setFill()
        page2.fill()
        CGContextRestoreGState(context)

        CGContextRestoreGState(context)
    }


    //MARK: - Canvas Images

    /// Page 1

    class func imageOfPlus(size size: CGSize = CGSize(width: 44, height: 44), resizing: ResizingBehavior = .AspectFit, themeConfig: UsabillaThemeConfigurator) -> UIImage {
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        StyleKit.drawPlus(frame: CGRect(origin: CGPoint.zero, size: size), resizing: resizing, themeConfig: themeConfig)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }


    //MARK: - Resizing Behavior

    enum ResizingBehavior {
        case AspectFit /// The content is proportionally resized to fit into the target rectangle.
        case AspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case Stretch /// The content is stretched to match the entire target rectangle.
        case Center /// The content is centered in the target rectangle, but it is NOT resized.

        func apply(rect rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .AspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .AspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .Stretch:
                break
            case .Center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
