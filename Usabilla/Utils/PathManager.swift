//
//  PathManager.swift
//  Usabilla
//
//  Created by Benjamin Grima on 04/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class PathManager {

    var boxType: BoxType
    var size: CGFloat!
    var lineWidth: CGFloat!
    init() {
        boxType = BoxType.square
    }

    func pathForBox() -> UIBezierPath {
        let path: UIBezierPath

        switch self.boxType {
        case .square:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: 3.0)
            path.apply(CGAffineTransform.identity.rotated(by: CGFloat( Double.pi * 2.5)))
            path.apply(CGAffineTransform(translationX: size, y: 0))
        default:
            let radius: CGFloat = self.size / 2
            path = UIBezierPath.init(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: radius, startAngle: CGFloat(-Double.pi / 4), endAngle: CGFloat(2 * Double.pi - Double.pi / 4), clockwise: true)
        }
        return path
    }

    func pathForCheckMark() -> UIBezierPath {
        var checkMarkPath = UIBezierPath()

        switch self.boxType {
        case .square:
            checkMarkPath.move(to: CGPoint(x: 20.25, y: 7.19))
            checkMarkPath.addCurve(to: CGPoint(x: 11.53, y: 16.81), controlPoint1: CGPoint(x: 16.17, y: 9.92), controlPoint2: CGPoint(x: 13.27, y: 13.13))
            checkMarkPath.addCurve(to: CGPoint(x: 7.19, y: 12.96), controlPoint1: CGPoint(x: 10.38, y: 15.34), controlPoint2: CGPoint(x: 9, y: 13.79))
         case .circle:
            let radius: CGFloat = self.size / 5
            checkMarkPath = UIBezierPath.init(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: radius, startAngle: CGFloat(-Double.pi / 4), endAngle: CGFloat(2 * Double.pi - Double.pi / 4), clockwise: true)
            checkMarkPath.fill()

        }

        return checkMarkPath
    }

    func pathForLongCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()

        checkMarkPath.move(to: CGPoint(x: self.size / 3.1578, y: self.size / 2))
        checkMarkPath.addLine(to: CGPoint(x: self.size / 2.0618, y: self.size / 1.57894))

        if self.boxType == .square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.addLine(to: CGPoint(x: self.size / 1.2053, y: self.size / 4.5272))
            checkMarkPath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
            checkMarkPath.apply(CGAffineTransform(translationX: -self.size / 4, y: -self.size / 4))
        } else {
           // checkMarkPath.addLine(to: CGPoint(x: self.size / 1.1553, y: self.size / 5.9272))
        }

        return checkMarkPath
    }

    func pathForFlatCheckMark() -> UIBezierPath {
        let flatCheckMarkPath = UIBezierPath()
        flatCheckMarkPath.move(to: CGPoint(x: self.size / 4, y: self.size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: self.size / 2, y: self.size / 2))
        flatCheckMarkPath.addLine(to: CGPoint(x: self.size / 1.2, y: self.size / 2))

        return flatCheckMarkPath
    }
}
