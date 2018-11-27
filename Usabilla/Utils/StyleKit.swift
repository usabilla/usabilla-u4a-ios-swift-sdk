//
//  Icons.swift
//  iOS feedback form
//
//  Created by Gijs on 28/12/2016.
//  Copyright © 2016 Usabilla. All rights reserved.
//
//  Generated by PaintCode Plugin for Sketch
//  http://www.paintcodeapp.com/sketch
//

import UIKit



class Icons: NSObject {


    //MARK: - Canvas Drawings

    /// -Form copy
    private class func drawIconCamera(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 64, height: 64), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 64, height: 64), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 32, y: resizedFrame.height / 32)
        
        
        //// Color Declarations
        let strokeColor = color
        let fillColor = color
        
        //// Symbols
        //// icon/camera
        //// Group 4
        //// Path Drawing
        let pathPath = UIBezierPath()
        pathPath.move(to: CGPoint(x: 13, y: 3))
        pathPath.addLine(to: CGPoint(x: 19.5, y: 3))
        pathPath.addCurve(to: CGPoint(x: 20.5, y: 3.5), controlPoint1: CGPoint(x: 19.98, y: 3), controlPoint2: CGPoint(x: 20.24, y: 3.11))
        pathPath.addCurve(to: CGPoint(x: 22.5, y: 6.7), controlPoint1: CGPoint(x: 21.66, y: 5.37), controlPoint2: CGPoint(x: 22.32, y: 6.44))
        pathPath.addCurve(to: CGPoint(x: 24, y: 7), controlPoint1: CGPoint(x: 22.76, y: 7.09), controlPoint2: CGPoint(x: 23.52, y: 7))
        pathPath.addCurve(to: CGPoint(x: 28, y: 7), controlPoint1: CGPoint(x: 24.32, y: 7), controlPoint2: CGPoint(x: 25.65, y: 7))
        pathPath.addCurve(to: CGPoint(x: 31, y: 10), controlPoint1: CGPoint(x: 29.58, y: 7), controlPoint2: CGPoint(x: 31, y: 8.44))
        pathPath.addLine(to: CGPoint(x: 31, y: 24))
        pathPath.addCurve(to: CGPoint(x: 28, y: 27), controlPoint1: CGPoint(x: 31, y: 25.56), controlPoint2: CGPoint(x: 29.58, y: 27))
        pathPath.addLine(to: CGPoint(x: 4, y: 27))
        pathPath.addCurve(to: CGPoint(x: 1, y: 24), controlPoint1: CGPoint(x: 2.42, y: 27), controlPoint2: CGPoint(x: 1, y: 25.56))
        pathPath.addLine(to: CGPoint(x: 1, y: 10))
        pathPath.addCurve(to: CGPoint(x: 4, y: 7), controlPoint1: CGPoint(x: 1, y: 8.44), controlPoint2: CGPoint(x: 2.42, y: 7))
        pathPath.addLine(to: CGPoint(x: 8.5, y: 7))
        strokeColor.setStroke()
        pathPath.lineWidth = 2
        pathPath.miterLimit = 4
        pathPath.lineCapStyle = .round
        pathPath.lineJoinStyle = .round
        pathPath.stroke()
        
        
        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 4, y: 10, width: 2, height: 2), cornerRadius: 1)
        fillColor.setFill()
        rectangle2Path.fill()
        
        
        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 13, height: 13))
        strokeColor.setStroke()
        oval2Path.lineWidth = 2
        oval2Path.stroke()
        
        context.restoreGState()
        
    }
    private class func drawIconTrashCan(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 64, height: 64), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 32, height: 32), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 32, y: resizedFrame.height / 32)
        
        
        //// Color Declarations
        let strokeColor = color
        let fillColor = color
        
        //// Symbols
        //// icon/delete
        //// Group 4
        //// Rectangle-4 Drawing
        let rectangle4Path = UIBezierPath()
        rectangle4Path.move(to: CGPoint(x: 6.12, y: 7))
        rectangle4Path.addLine(to: CGPoint(x: 8.55, y: 29.11))
        rectangle4Path.addCurve(to: CGPoint(x: 9.54, y: 30), controlPoint1: CGPoint(x: 8.6, y: 29.62), controlPoint2: CGPoint(x: 9.03, y: 30))
        rectangle4Path.addLine(to: CGPoint(x: 22.46, y: 30))
        rectangle4Path.addCurve(to: CGPoint(x: 23.45, y: 29.11), controlPoint1: CGPoint(x: 22.97, y: 30), controlPoint2: CGPoint(x: 23.4, y: 29.62))
        rectangle4Path.addLine(to: CGPoint(x: 25.88, y: 7))
        rectangle4Path.addLine(to: CGPoint(x: 6.12, y: 7))
        rectangle4Path.close()
        strokeColor.setStroke()
        rectangle4Path.lineWidth = 2
        rectangle4Path.miterLimit = 4
        rectangle4Path.stroke()
        
        
        //// Rectangle-6 Drawing
        let rectangle6Path = UIBezierPath(roundedRect: CGRect(x: 3, y: 7, width: 26, height: 1), cornerRadius: 0.5)
        fillColor.setFill()
        rectangle6Path.fill()
        strokeColor.setStroke()
        rectangle6Path.lineWidth = 1
        rectangle6Path.stroke()
        
        
        //// Path Drawing
        let pathPath = UIBezierPath()
        pathPath.move(to: CGPoint(x: 21, y: 7))
        pathPath.addLine(to: CGPoint(x: 11, y: 7))
        pathPath.addLine(to: CGPoint(x: 11, y: 4))
        pathPath.addCurve(to: CGPoint(x: 13, y: 2), controlPoint1: CGPoint(x: 11, y: 2.9), controlPoint2: CGPoint(x: 11.9, y: 2))
        pathPath.addLine(to: CGPoint(x: 19, y: 2))
        strokeColor.setStroke()
        pathPath.lineWidth = 1
        pathPath.miterLimit = 4
        pathPath.lineCapStyle = .round
        pathPath.stroke()
        
        
        //// Rectangle-3 Drawing
        let rectangle3Path = UIBezierPath(roundedRect: CGRect(x: 12, y: 12, width: 1, height: 12), cornerRadius: 0.5)
        strokeColor.setStroke()
        rectangle3Path.lineWidth = 1
        rectangle3Path.stroke()
        
        
        //// Rectangle- 7 Drawing
        let rectangle7Path = UIBezierPath(roundedRect: CGRect(x: 20, y: 12, width: 1, height: 12), cornerRadius: 0.5)
        strokeColor.setStroke()
        rectangle7Path.lineWidth = 1
        rectangle7Path.stroke()
        
        
        //// Rectangle- 9 Drawing
        let rectangle9Path = UIBezierPath(roundedRect: CGRect(x: 16, y: 12, width: 1, height: 12), cornerRadius: 0.5)
        strokeColor.setStroke()
        rectangle9Path.lineWidth = 1
        rectangle9Path.stroke()
        
        context.restoreGState()
        
    }

    
    private class func drawIconCircle(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 36, height: 36), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 36, height: 36), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 36, y: resizedFrame.height / 36)
        
        
        //// Color Declarations
        let strokeColor = color
        let fillColor = color
        
        let path = UIBezierPath(roundedRect: CGRect(x: 4, y: 4, width: 28, height: 28), cornerRadius: 28/2)

        strokeColor.setStroke()
        fillColor.setFill()
        path.lineWidth = 1
        path.stroke()
        path.fill()
        context.restoreGState()
        
    }

    
    private class func drawAddImage(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 300, height: 300), resizing: ResizingBehavior = .aspectFit) {

        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 24, height: 24), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 24, y: resizedFrame.height / 24)


        //// Color Declarations
        let fillColor = color

        //// addScreenshotIcon.pdf Group
        //// Bezier Drawing
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 12, y: 12), radius: 11, startAngle: 0, endAngle: 360, clockwise: true)
        color.setStroke()
        bezierPath.stroke()


        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 12.62, y: 6.53))
        bezier2Path.addLine(to: CGPoint(x: 11.37, y: 6.53))
        bezier2Path.addLine(to: CGPoint(x: 11.37, y: 11.37))
        bezier2Path.addLine(to: CGPoint(x: 6.56, y: 11.37))
        bezier2Path.addLine(to: CGPoint(x: 6.56, y: 12.63))
        bezier2Path.addLine(to: CGPoint(x: 11.37, y: 12.63))
        bezier2Path.addLine(to: CGPoint(x: 11.37, y: 17.47))
        bezier2Path.addLine(to: CGPoint(x: 12.62, y: 17.47))
        bezier2Path.addLine(to: CGPoint(x: 12.62, y: 12.63))
        bezier2Path.addLine(to: CGPoint(x: 17.43, y: 12.63))
        bezier2Path.addLine(to: CGPoint(x: 17.43, y: 11.37))
        bezier2Path.addLine(to: CGPoint(x: 12.62, y: 11.37))
        bezier2Path.addLine(to: CGPoint(x: 12.62, y: 6.53))
        bezier2Path.close()
        bezier2Path.usesEvenOddFillRule = true
        fillColor.setFill()
        bezier2Path.fill()

        context.restoreGState()

    }

    /// Symbols

    private class func drawPoweredBy(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 149, height: 40), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 149, height: 33), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 149, y: resizedFrame.height / 33)

        /// Powered by
        let poweredBy2 = NSMutableAttributedString(string: "Powered by")

        poweredBy2.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: poweredBy2.length))
        poweredBy2.addAttribute(NSKernAttributeName, value: -0.24, range: NSRange(location: 0, length: poweredBy2.length))
        context.saveGState()
        poweredBy2.draw(at: CGPoint(x: 1, y: 15))
        context.restoreGState()
        /// Logo
        do {
            context.saveGState()
            context.translateBy(x: 67, y: -2)

            /// Fill 1
            let fill1 = UIBezierPath()
            fill1.move(to: CGPoint(x: 4.84, y: 2.38))
            fill1.addCurve(to: CGPoint(x: 2.42, y: 4.75), controlPoint1: CGPoint(x: 4.84, y: 3.69), controlPoint2: CGPoint(x: 3.76, y: 4.75))
            fill1.addCurve(to: CGPoint(x: 0, y: 2.38), controlPoint1: CGPoint(x: 1.08, y: 4.75), controlPoint2: CGPoint(x: 0, y: 3.69))
            fill1.addCurve(to: CGPoint(x: 2.42, y: 0), controlPoint1: CGPoint(x: 0, y: 1.06), controlPoint2: CGPoint(x: 1.08, y: 0))
            fill1.addCurve(to: CGPoint(x: 4.84, y: 2.38), controlPoint1: CGPoint(x: 3.76, y: 0), controlPoint2: CGPoint(x: 4.84, y: 1.06))
            context.saveGState()
            context.translateBy(x: 32.68, y: 6.23)
            fill1.usesEvenOddFillRule = true
            color.setFill()
            fill1.fill()
            context.restoreGState()

            /// Fill 2
            let fill2 = UIBezierPath()
            fill2.move(to: CGPoint(x: 2.5, y: 1.23))
            fill2.addCurve(to: CGPoint(x: 1.25, y: 2.46), controlPoint1: CGPoint(x: 2.5, y: 1.91), controlPoint2: CGPoint(x: 1.94, y: 2.46))
            fill2.addCurve(to: CGPoint(x: 0, y: 1.23), controlPoint1: CGPoint(x: 0.56, y: 2.46), controlPoint2: CGPoint(x: 0, y: 1.91))
            fill2.addCurve(to: CGPoint(x: 1.25, y: 0), controlPoint1: CGPoint(x: 0, y: 0.55), controlPoint2: CGPoint(x: 0.56, y: 0))
            fill2.addCurve(to: CGPoint(x: 2.5, y: 1.23), controlPoint1: CGPoint(x: 1.94, y: 0), controlPoint2: CGPoint(x: 2.5, y: 0.55))
            context.saveGState()
            context.translateBy(x: 36.86, y: 11.71)
            fill2.usesEvenOddFillRule = true
            color.setFill()
            fill2.fill()
            context.restoreGState()

            /// Fill 3
            let fill3 = UIBezierPath()
            fill3.move(to: CGPoint(x: 5.09, y: 2.5))
            fill3.addCurve(to: CGPoint(x: 2.54, y: 5), controlPoint1: CGPoint(x: 5.09, y: 3.88), controlPoint2: CGPoint(x: 3.95, y: 5))
            fill3.addCurve(to: CGPoint(x: 0, y: 2.5), controlPoint1: CGPoint(x: 1.14, y: 5), controlPoint2: CGPoint(x: 0, y: 3.88))
            fill3.addCurve(to: CGPoint(x: 2.54, y: 0), controlPoint1: CGPoint(x: 0, y: 1.12), controlPoint2: CGPoint(x: 1.14, y: 0))
            fill3.addCurve(to: CGPoint(x: 5.09, y: 2.5), controlPoint1: CGPoint(x: 3.95, y: 0), controlPoint2: CGPoint(x: 5.09, y: 1.12))
            context.saveGState()
            context.translateBy(x: 34.97, y: 0)
            fill3.usesEvenOddFillRule = true
            color.setFill()
            fill3.fill()
            context.restoreGState()

            /// Fill 4
            let fill4 = UIBezierPath()
            fill4.move(to: CGPoint(x: 6.75, y: 3.31))
            fill4.addCurve(to: CGPoint(x: 3.37, y: 6.62), controlPoint1: CGPoint(x: 6.75, y: 5.14), controlPoint2: CGPoint(x: 5.24, y: 6.62))
            fill4.addCurve(to: CGPoint(x: 0, y: 3.31), controlPoint1: CGPoint(x: 1.51, y: 6.62), controlPoint2: CGPoint(x: 0, y: 5.14))
            fill4.addCurve(to: CGPoint(x: 3.37, y: 0), controlPoint1: CGPoint(x: 0, y: 1.48), controlPoint2: CGPoint(x: 1.51, y: 0))
            fill4.addCurve(to: CGPoint(x: 6.75, y: 3.31), controlPoint1: CGPoint(x: 5.24, y: 0), controlPoint2: CGPoint(x: 6.75, y: 1.48))
            context.saveGState()
            context.translateBy(x: 38.99, y: 5)
            fill4.usesEvenOddFillRule = true
            color.setFill()
            fill4.fill()
            context.restoreGState()

            /// Fill 5
            let fill5 = UIBezierPath()
            fill5.move(to: CGPoint.zero)
            fill5.addLine(to: CGPoint(x: 2.81, y: 0))
            fill5.addLine(to: CGPoint(x: 2.81, y: 5.45))
            fill5.addCurve(to: CGPoint(x: 3.02, y: 7.58), controlPoint1: CGPoint(x: 2.81, y: 6.47), controlPoint2: CGPoint(x: 2.88, y: 7.18))
            fill5.addCurve(to: CGPoint(x: 3.71, y: 8.5), controlPoint1: CGPoint(x: 3.17, y: 7.97), controlPoint2: CGPoint(x: 3.4, y: 8.28))
            fill5.addCurve(to: CGPoint(x: 4.88, y: 8.83), controlPoint1: CGPoint(x: 4.03, y: 8.72), controlPoint2: CGPoint(x: 4.42, y: 8.83))
            fill5.addCurve(to: CGPoint(x: 6.06, y: 8.51), controlPoint1: CGPoint(x: 5.34, y: 8.83), controlPoint2: CGPoint(x: 5.74, y: 8.72))
            fill5.addCurve(to: CGPoint(x: 6.78, y: 7.55), controlPoint1: CGPoint(x: 6.38, y: 8.29), controlPoint2: CGPoint(x: 6.62, y: 7.97))
            fill5.addCurve(to: CGPoint(x: 6.95, y: 5.54), controlPoint1: CGPoint(x: 6.9, y: 7.24), controlPoint2: CGPoint(x: 6.95, y: 6.57))
            fill5.addLine(to: CGPoint(x: 6.95, y: 0))
            fill5.addLine(to: CGPoint(x: 9.73, y: 0))
            fill5.addLine(to: CGPoint(x: 9.73, y: 4.82))
            fill5.addCurve(to: CGPoint(x: 9.27, y: 8.72), controlPoint1: CGPoint(x: 9.73, y: 6.72), controlPoint2: CGPoint(x: 9.58, y: 8.02))
            fill5.addCurve(to: CGPoint(x: 7.62, y: 10.69), controlPoint1: CGPoint(x: 8.9, y: 9.57), controlPoint2: CGPoint(x: 8.35, y: 10.23))
            fill5.addCurve(to: CGPoint(x: 4.86, y: 11.37), controlPoint1: CGPoint(x: 6.9, y: 11.14), controlPoint2: CGPoint(x: 5.98, y: 11.37))
            fill5.addCurve(to: CGPoint(x: 1.91, y: 10.57), controlPoint1: CGPoint(x: 3.64, y: 11.37), controlPoint2: CGPoint(x: 2.66, y: 11.1))
            fill5.addCurve(to: CGPoint(x: 0.33, y: 8.34), controlPoint1: CGPoint(x: 1.16, y: 10.04), controlPoint2: CGPoint(x: 0.63, y: 9.29))
            fill5.addCurve(to: CGPoint(x: 0, y: 4.74), controlPoint1: CGPoint(x: 0.11, y: 7.68), controlPoint2: CGPoint(x: 0, y: 6.48))
            fill5.addLine(to: CGPoint.zero)
            context.saveGState()
            context.translateBy(x: 0, y: 17.46)
            fill5.usesEvenOddFillRule = true
            color.setFill()
            fill5.fill()
            context.restoreGState()

            /// Fill 6
            let fill6 = UIBezierPath()
            fill6.move(to: CGPoint(x: 7.65, y: 1.8))
            fill6.addLine(to: CGPoint(x: 5.93, y: 3.49))
            fill6.addCurve(to: CGPoint(x: 4.03, y: 2.47), controlPoint1: CGPoint(x: 5.24, y: 2.81), controlPoint2: CGPoint(x: 4.6, y: 2.47))
            fill6.addCurve(to: CGPoint(x: 3.3, y: 2.66), controlPoint1: CGPoint(x: 3.72, y: 2.47), controlPoint2: CGPoint(x: 3.47, y: 2.53))
            fill6.addCurve(to: CGPoint(x: 3.03, y: 3.15), controlPoint1: CGPoint(x: 3.12, y: 2.79), controlPoint2: CGPoint(x: 3.03, y: 2.96))
            fill6.addCurve(to: CGPoint(x: 3.2, y: 3.55), controlPoint1: CGPoint(x: 3.03, y: 3.3), controlPoint2: CGPoint(x: 3.09, y: 3.43))
            fill6.addCurve(to: CGPoint(x: 4.03, y: 4.06), controlPoint1: CGPoint(x: 3.31, y: 3.68), controlPoint2: CGPoint(x: 3.59, y: 3.85))
            fill6.addLine(to: CGPoint(x: 5.05, y: 4.56))
            fill6.addCurve(to: CGPoint(x: 7.26, y: 6.15), controlPoint1: CGPoint(x: 6.12, y: 5.08), controlPoint2: CGPoint(x: 6.86, y: 5.61))
            fill6.addCurve(to: CGPoint(x: 7.86, y: 8.05), controlPoint1: CGPoint(x: 7.66, y: 6.69), controlPoint2: CGPoint(x: 7.86, y: 7.32))
            fill6.addCurve(to: CGPoint(x: 6.77, y: 10.47), controlPoint1: CGPoint(x: 7.86, y: 9.01), controlPoint2: CGPoint(x: 7.5, y: 9.82))
            fill6.addCurve(to: CGPoint(x: 3.87, y: 11.44), controlPoint1: CGPoint(x: 6.05, y: 11.11), controlPoint2: CGPoint(x: 5.08, y: 11.44))
            fill6.addCurve(to: CGPoint(x: 0, y: 9.58), controlPoint1: CGPoint(x: 2.25, y: 11.44), controlPoint2: CGPoint(x: 0.96, y: 10.82))
            fill6.addLine(to: CGPoint(x: 1.71, y: 7.75))
            fill6.addCurve(to: CGPoint(x: 2.86, y: 8.65), controlPoint1: CGPoint(x: 2.04, y: 8.12), controlPoint2: CGPoint(x: 2.42, y: 8.42))
            fill6.addCurve(to: CGPoint(x: 4.02, y: 9), controlPoint1: CGPoint(x: 3.29, y: 8.88), controlPoint2: CGPoint(x: 3.68, y: 9))
            fill6.addCurve(to: CGPoint(x: 4.91, y: 8.74), controlPoint1: CGPoint(x: 4.39, y: 9), controlPoint2: CGPoint(x: 4.68, y: 8.91))
            fill6.addCurve(to: CGPoint(x: 5.24, y: 8.14), controlPoint1: CGPoint(x: 5.13, y: 8.56), controlPoint2: CGPoint(x: 5.24, y: 8.36))
            fill6.addCurve(to: CGPoint(x: 4.03, y: 6.91), controlPoint1: CGPoint(x: 5.24, y: 7.72), controlPoint2: CGPoint(x: 4.84, y: 7.31))
            fill6.addLine(to: CGPoint(x: 3.09, y: 6.45))
            fill6.addCurve(to: CGPoint(x: 0.41, y: 3.12), controlPoint1: CGPoint(x: 1.3, y: 5.56), controlPoint2: CGPoint(x: 0.41, y: 4.45))
            fill6.addCurve(to: CGPoint(x: 1.42, y: 0.91), controlPoint1: CGPoint(x: 0.41, y: 2.26), controlPoint2: CGPoint(x: 0.74, y: 1.52))
            fill6.addCurve(to: CGPoint(x: 4.01, y: 0), controlPoint1: CGPoint(x: 2.1, y: 0.3), controlPoint2: CGPoint(x: 2.96, y: 0))
            fill6.addCurve(to: CGPoint(x: 6.04, y: 0.46), controlPoint1: CGPoint(x: 4.73, y: 0), controlPoint2: CGPoint(x: 5.41, y: 0.15))
            fill6.addCurve(to: CGPoint(x: 7.65, y: 1.8), controlPoint1: CGPoint(x: 6.68, y: 0.77), controlPoint2: CGPoint(x: 7.21, y: 1.22))
            context.saveGState()
            context.translateBy(x: 9.95, y: 17.4)
            fill6.usesEvenOddFillRule = true
            color.setFill()
            fill6.fill()
            context.restoreGState()

            /// Fill 7
            let fill7 = UIBezierPath()
            fill7.move(to: CGPoint(x: 5.76, y: 2.52))
            fill7.addCurve(to: CGPoint(x: 3.62, y: 3.41), controlPoint1: CGPoint(x: 4.9, y: 2.52), controlPoint2: CGPoint(x: 4.19, y: 2.82))
            fill7.addCurve(to: CGPoint(x: 2.77, y: 5.71), controlPoint1: CGPoint(x: 3.05, y: 4.01), controlPoint2: CGPoint(x: 2.77, y: 4.78))
            fill7.addCurve(to: CGPoint(x: 3.64, y: 8.03), controlPoint1: CGPoint(x: 2.77, y: 6.65), controlPoint2: CGPoint(x: 3.06, y: 7.42))
            fill7.addCurve(to: CGPoint(x: 5.77, y: 8.94), controlPoint1: CGPoint(x: 4.21, y: 8.63), controlPoint2: CGPoint(x: 4.93, y: 8.94))
            fill7.addCurve(to: CGPoint(x: 7.94, y: 8.04), controlPoint1: CGPoint(x: 6.64, y: 8.94), controlPoint2: CGPoint(x: 7.37, y: 8.64))
            fill7.addCurve(to: CGPoint(x: 8.81, y: 5.7), controlPoint1: CGPoint(x: 8.52, y: 7.45), controlPoint2: CGPoint(x: 8.81, y: 6.67))
            fill7.addCurve(to: CGPoint(x: 7.94, y: 3.4), controlPoint1: CGPoint(x: 8.81, y: 4.75), controlPoint2: CGPoint(x: 8.52, y: 3.99))
            fill7.addCurve(to: CGPoint(x: 5.76, y: 2.52), controlPoint1: CGPoint(x: 7.37, y: 2.81), controlPoint2: CGPoint(x: 6.64, y: 2.52))
            fill7.close()
            fill7.move(to: CGPoint(x: 8.68, y: 0.92))
            fill7.addLine(to: CGPoint(x: 11.46, y: 0.92))
            fill7.addLine(to: CGPoint(x: 11.46, y: 11.16))
            fill7.addLine(to: CGPoint(x: 8.68, y: 11.16))
            fill7.addLine(to: CGPoint(x: 8.68, y: 10.01))
            fill7.addCurve(to: CGPoint(x: 7.05, y: 11.1), controlPoint1: CGPoint(x: 8.14, y: 10.51), controlPoint2: CGPoint(x: 7.6, y: 10.88))
            fill7.addCurve(to: CGPoint(x: 5.28, y: 11.44), controlPoint1: CGPoint(x: 6.51, y: 11.32), controlPoint2: CGPoint(x: 5.91, y: 11.44))
            fill7.addCurve(to: CGPoint(x: 1.57, y: 9.8), controlPoint1: CGPoint(x: 3.85, y: 11.44), controlPoint2: CGPoint(x: 2.61, y: 10.89))
            fill7.addCurve(to: CGPoint(x: 0, y: 5.74), controlPoint1: CGPoint(x: 0.52, y: 8.71), controlPoint2: CGPoint(x: 0, y: 7.36))
            fill7.addCurve(to: CGPoint(x: 1.52, y: 1.61), controlPoint1: CGPoint(x: 0, y: 4.06), controlPoint2: CGPoint(x: 0.5, y: 2.68))
            fill7.addCurve(to: CGPoint(x: 5.2, y: 0), controlPoint1: CGPoint(x: 2.52, y: 0.54), controlPoint2: CGPoint(x: 3.75, y: 0))
            fill7.addCurve(to: CGPoint(x: 7.07, y: 0.37), controlPoint1: CGPoint(x: 5.86, y: 0), controlPoint2: CGPoint(x: 6.48, y: 0.12))
            fill7.addCurve(to: CGPoint(x: 8.68, y: 1.48), controlPoint1: CGPoint(x: 7.65, y: 0.62), controlPoint2: CGPoint(x: 8.19, y: 0.99))
            fill7.addLine(to: CGPoint(x: 8.68, y: 0.92))
            fill7.addLine(to: CGPoint(x: 8.68, y: 0.92))
            fill7.close()
            fill7.move(to: CGPoint(x: 8.68, y: 0.92))
            context.saveGState()
            context.translateBy(x: 18.24, y: 17.4)
            fill7.usesEvenOddFillRule = true
            color.setFill()
            fill7.fill()
            context.restoreGState()

            /// Fill 8
            let fill8 = UIBezierPath()
            fill8.move(to: CGPoint(x: 5.68, y: 6.01))
            fill8.addCurve(to: CGPoint(x: 3.5, y: 6.89), controlPoint1: CGPoint(x: 4.8, y: 6.01), controlPoint2: CGPoint(x: 4.08, y: 6.3))
            fill8.addCurve(to: CGPoint(x: 2.64, y: 9.19), controlPoint1: CGPoint(x: 2.93, y: 7.48), controlPoint2: CGPoint(x: 2.64, y: 8.24))
            fill8.addCurve(to: CGPoint(x: 3.5, y: 11.53), controlPoint1: CGPoint(x: 2.64, y: 10.16), controlPoint2: CGPoint(x: 2.93, y: 10.94))
            fill8.addCurve(to: CGPoint(x: 5.68, y: 12.43), controlPoint1: CGPoint(x: 4.08, y: 12.13), controlPoint2: CGPoint(x: 4.8, y: 12.43))
            fill8.addCurve(to: CGPoint(x: 7.82, y: 11.52), controlPoint1: CGPoint(x: 6.53, y: 12.43), controlPoint2: CGPoint(x: 7.24, y: 12.13))
            fill8.addCurve(to: CGPoint(x: 8.69, y: 9.2), controlPoint1: CGPoint(x: 8.4, y: 10.91), controlPoint2: CGPoint(x: 8.69, y: 10.14))
            fill8.addCurve(to: CGPoint(x: 7.84, y: 6.91), controlPoint1: CGPoint(x: 8.69, y: 8.27), controlPoint2: CGPoint(x: 8.41, y: 7.5))
            fill8.addCurve(to: CGPoint(x: 5.68, y: 6.01), controlPoint1: CGPoint(x: 7.27, y: 6.31), controlPoint2: CGPoint(x: 6.55, y: 6.01))
            fill8.close()
            fill8.move(to: CGPoint(x: 2.76, y: 0))
            fill8.addLine(to: CGPoint(x: 2.76, y: 4.97))
            fill8.addCurve(to: CGPoint(x: 4.39, y: 3.86), controlPoint1: CGPoint(x: 3.26, y: 4.48), controlPoint2: CGPoint(x: 3.8, y: 4.11))
            fill8.addCurve(to: CGPoint(x: 6.26, y: 3.49), controlPoint1: CGPoint(x: 4.97, y: 3.62), controlPoint2: CGPoint(x: 5.6, y: 3.49))
            fill8.addCurve(to: CGPoint(x: 9.95, y: 5.1), controlPoint1: CGPoint(x: 7.71, y: 3.49), controlPoint2: CGPoint(x: 8.93, y: 4.03))
            fill8.addCurve(to: CGPoint(x: 11.46, y: 9.23), controlPoint1: CGPoint(x: 10.96, y: 6.17), controlPoint2: CGPoint(x: 11.46, y: 7.55))
            fill8.addCurve(to: CGPoint(x: 9.9, y: 13.29), controlPoint1: CGPoint(x: 11.46, y: 10.85), controlPoint2: CGPoint(x: 10.94, y: 12.2))
            fill8.addCurve(to: CGPoint(x: 6.18, y: 14.93), controlPoint1: CGPoint(x: 8.85, y: 14.38), controlPoint2: CGPoint(x: 7.61, y: 14.93))
            fill8.addCurve(to: CGPoint(x: 4.4, y: 14.59), controlPoint1: CGPoint(x: 5.54, y: 14.93), controlPoint2: CGPoint(x: 4.95, y: 14.82))
            fill8.addCurve(to: CGPoint(x: 2.76, y: 13.5), controlPoint1: CGPoint(x: 3.85, y: 14.37), controlPoint2: CGPoint(x: 3.3, y: 14.01))
            fill8.addLine(to: CGPoint(x: 2.76, y: 14.65))
            fill8.addLine(to: CGPoint(x: 0, y: 14.65))
            fill8.addLine(to: CGPoint.zero)
            fill8.addLine(to: CGPoint(x: 2.76, y: 0))
            fill8.addLine(to: CGPoint(x: 2.76, y: 0))
            fill8.close()
            fill8.move(to: CGPoint(x: 2.76, y: 0))
            context.saveGState()
            context.translateBy(x: 30.39, y: 13.9)
            fill8.usesEvenOddFillRule = true
            color.setFill()
            fill8.fill()
            context.restoreGState()

            /// Fill 9
            let fill9 = UIBezierPath()
            fill9.move(to: CGPoint(x: 0, y: 14.65))
            fill9.addLine(to: CGPoint(x: 2.78, y: 14.65))
            fill9.addLine(to: CGPoint(x: 2.78, y: 0))
            fill9.addLine(to: CGPoint.zero)
            fill9.addLine(to: CGPoint(x: 0, y: 14.65))
            fill9.close()
            fill9.move(to: CGPoint(x: 0, y: 14.65))
            context.saveGState()
            context.translateBy(x: 46.32, y: 13.9)
            fill9.usesEvenOddFillRule = true
            color.setFill()
            fill9.fill()
            context.restoreGState()

            /// Fill 10
            let fill10 = UIBezierPath()
            fill10.move(to: CGPoint(x: 0, y: 14.65))
            fill10.addLine(to: CGPoint(x: 2.78, y: 14.65))
            fill10.addLine(to: CGPoint(x: 2.78, y: 0))
            fill10.addLine(to: CGPoint.zero)
            fill10.addLine(to: CGPoint(x: 0, y: 14.65))
            fill10.close()
            fill10.move(to: CGPoint(x: 0, y: 14.65))
            context.saveGState()
            context.translateBy(x: 49.84, y: 13.9)
            fill10.usesEvenOddFillRule = true
            color.setFill()
            fill10.fill()
            context.restoreGState()

            /// Fill 11
            let fill11 = UIBezierPath()
            fill11.move(to: CGPoint(x: 5.76, y: 2.52))
            fill11.addCurve(to: CGPoint(x: 3.62, y: 3.41), controlPoint1: CGPoint(x: 4.9, y: 2.52), controlPoint2: CGPoint(x: 4.19, y: 2.82))
            fill11.addCurve(to: CGPoint(x: 2.77, y: 5.71), controlPoint1: CGPoint(x: 3.05, y: 4.01), controlPoint2: CGPoint(x: 2.77, y: 4.78))
            fill11.addCurve(to: CGPoint(x: 3.64, y: 8.03), controlPoint1: CGPoint(x: 2.77, y: 6.65), controlPoint2: CGPoint(x: 3.06, y: 7.42))
            fill11.addCurve(to: CGPoint(x: 5.77, y: 8.94), controlPoint1: CGPoint(x: 4.21, y: 8.63), controlPoint2: CGPoint(x: 4.93, y: 8.94))
            fill11.addCurve(to: CGPoint(x: 7.94, y: 8.04), controlPoint1: CGPoint(x: 6.64, y: 8.94), controlPoint2: CGPoint(x: 7.37, y: 8.64))
            fill11.addCurve(to: CGPoint(x: 8.81, y: 5.7), controlPoint1: CGPoint(x: 8.52, y: 7.45), controlPoint2: CGPoint(x: 8.81, y: 6.67))
            fill11.addCurve(to: CGPoint(x: 7.94, y: 3.4), controlPoint1: CGPoint(x: 8.81, y: 4.75), controlPoint2: CGPoint(x: 8.52, y: 3.99))
            fill11.addCurve(to: CGPoint(x: 5.76, y: 2.52), controlPoint1: CGPoint(x: 7.37, y: 2.81), controlPoint2: CGPoint(x: 6.64, y: 2.52))
            fill11.close()
            fill11.move(to: CGPoint(x: 8.68, y: 0.92))
            fill11.addLine(to: CGPoint(x: 11.46, y: 0.92))
            fill11.addLine(to: CGPoint(x: 11.46, y: 11.16))
            fill11.addLine(to: CGPoint(x: 8.68, y: 11.16))
            fill11.addLine(to: CGPoint(x: 8.68, y: 10.01))
            fill11.addCurve(to: CGPoint(x: 7.05, y: 11.1), controlPoint1: CGPoint(x: 8.14, y: 10.51), controlPoint2: CGPoint(x: 7.6, y: 10.88))
            fill11.addCurve(to: CGPoint(x: 5.28, y: 11.44), controlPoint1: CGPoint(x: 6.51, y: 11.32), controlPoint2: CGPoint(x: 5.91, y: 11.44))
            fill11.addCurve(to: CGPoint(x: 1.57, y: 9.8), controlPoint1: CGPoint(x: 3.85, y: 11.44), controlPoint2: CGPoint(x: 2.61, y: 10.89))
            fill11.addCurve(to: CGPoint(x: 0, y: 5.74), controlPoint1: CGPoint(x: 0.52, y: 8.71), controlPoint2: CGPoint(x: 0, y: 7.36))
            fill11.addCurve(to: CGPoint(x: 1.52, y: 1.61), controlPoint1: CGPoint(x: 0, y: 4.06), controlPoint2: CGPoint(x: 0.5, y: 2.68))
            fill11.addCurve(to: CGPoint(x: 5.2, y: 0), controlPoint1: CGPoint(x: 2.53, y: 0.54), controlPoint2: CGPoint(x: 3.75, y: 0))
            fill11.addCurve(to: CGPoint(x: 7.07, y: 0.37), controlPoint1: CGPoint(x: 5.86, y: 0), controlPoint2: CGPoint(x: 6.48, y: 0.12))
            fill11.addCurve(to: CGPoint(x: 8.68, y: 1.48), controlPoint1: CGPoint(x: 7.65, y: 0.62), controlPoint2: CGPoint(x: 8.19, y: 0.99))
            fill11.addLine(to: CGPoint(x: 8.68, y: 0.92))
            fill11.addLine(to: CGPoint(x: 8.68, y: 0.92))
            fill11.close()
            fill11.move(to: CGPoint(x: 8.68, y: 0.92))
            context.saveGState()
            context.translateBy(x: 53.38, y: 17.4)
            fill11.usesEvenOddFillRule = true
            color.setFill()
            fill11.fill()
            context.restoreGState()

            /// Fill 12
            let fill12 = UIBezierPath()
            fill12.move(to: CGPoint(x: 1.39, y: 0))
            fill12.addCurve(to: CGPoint(x: 0, y: 1.36), controlPoint1: CGPoint(x: 0.62, y: 0), controlPoint2: CGPoint(x: 0, y: 0.61))
            fill12.addLine(to: CGPoint(x: 0, y: 9.16))
            fill12.addLine(to: CGPoint(x: 2.78, y: 9.16))
            fill12.addLine(to: CGPoint(x: 2.78, y: 1.36))
            fill12.addCurve(to: CGPoint(x: 1.39, y: 0), controlPoint1: CGPoint(x: 2.78, y: 0.61), controlPoint2: CGPoint(x: 2.16, y: 0))
            context.saveGState()
            context.translateBy(x: 42.58, y: 19.39)
            fill12.usesEvenOddFillRule = true
            color.setFill()
            fill12.fill()
            context.restoreGState()

            /// Fill 13
            let fill13 = UIBezierPath()
            fill13.move(to: CGPoint(x: 2.49, y: 0))
            fill13.addCurve(to: CGPoint(x: 4.26, y: 0.73), controlPoint1: CGPoint(x: 3.18, y: 0), controlPoint2: CGPoint(x: 3.77, y: 0.24))
            fill13.addCurve(to: CGPoint(x: 4.99, y: 2.51), controlPoint1: CGPoint(x: 4.75, y: 1.22), controlPoint2: CGPoint(x: 4.99, y: 1.81))
            fill13.addCurve(to: CGPoint(x: 4.26, y: 4.26), controlPoint1: CGPoint(x: 4.99, y: 3.19), controlPoint2: CGPoint(x: 4.75, y: 3.78))
            fill13.addCurve(to: CGPoint(x: 2.52, y: 4.99), controlPoint1: CGPoint(x: 3.78, y: 4.75), controlPoint2: CGPoint(x: 3.2, y: 4.99))
            fill13.addCurve(to: CGPoint(x: 0.74, y: 4.25), controlPoint1: CGPoint(x: 1.82, y: 4.99), controlPoint2: CGPoint(x: 1.23, y: 4.74))
            fill13.addCurve(to: CGPoint(x: 0, y: 2.45), controlPoint1: CGPoint(x: 0.25, y: 3.76), controlPoint2: CGPoint(x: 0, y: 3.16))
            fill13.addCurve(to: CGPoint(x: 0.73, y: 0.72), controlPoint1: CGPoint(x: 0, y: 1.78), controlPoint2: CGPoint(x: 0.24, y: 1.2))
            fill13.addCurve(to: CGPoint(x: 2.49, y: 0), controlPoint1: CGPoint(x: 1.22, y: 0.24), controlPoint2: CGPoint(x: 1.8, y: 0))
            context.saveGState()
            context.translateBy(x: 40.43, y: 13.48)
            fill13.usesEvenOddFillRule = true
            color.setFill()
            fill13.fill()
            context.restoreGState()

            context.restoreGState()
        }

        context.restoreGState()
    }

    class func deleteIcon(color: UIColor) -> UIImage {
        struct LocalCache {
            static var image: UIImage!
            static var color: UIColor!
        }
        if LocalCache.image != nil && LocalCache.color == color {
            return LocalCache.image
        }
        var image: UIImage
        let size = CGSize(width: 64, height: 64)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        Icons.drawIconTrashCan(color: color, frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        LocalCache.color = color
        return image
    }

    class func imageOfEdit(color: UIColor) -> UIImage {
        struct LocalCache {
            static var image: UIImage!
            static var color: UIColor!
        }
        if LocalCache.image != nil && LocalCache.color == color {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 64, height: 64), false, 0)
        Icons.drawIconCamera(color: color)

        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        LocalCache.color = color
        return image
    }


    /// -Form copy
    class func imageOfAddImage(color: UIColor) -> UIImage {
        struct LocalCache {
            static var image: UIImage!
            static var color: UIColor!
        }
        if LocalCache.image != nil && LocalCache.color == color {
            return LocalCache.image
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), false, 0)
        Icons.drawAddImage(color: color)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        LocalCache.color = color
        return image
    }

    /// Symbols

    class func imageOfPoweredBy(color: UIColor) -> UIImage {
        struct LocalCache {
            static var lastColor: UIColor!
            static var image: UIImage!
        }

        if LocalCache.image != nil {
            if LocalCache.lastColor == color {
                return LocalCache.image
            }
            LocalCache.lastColor = color
        }
        var image: UIImage

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 149, height: 33), false, 0)
        Icons.drawPoweredBy(color: color)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        LocalCache.image = image
        return image
    }

    class func imageOfCircle( color: UIColor) -> UIImage {
        struct LocalCache {
            static var lastColor: UIColor!
            static var image: UIImage!
        }
        
        if LocalCache.image != nil {
            if LocalCache.lastColor == color {
                return LocalCache.image
            }
            LocalCache.lastColor = color
        }
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        Icons.drawIconCircle(color: color)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        LocalCache.image = image
        return image
   }
    
    //MARK: - Resizing Behavior

    enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
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


} // swiftlint:disable:this file_length
