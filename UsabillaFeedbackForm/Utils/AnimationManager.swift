//
//  CheckboxAnimationManager.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 04/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class AnimationManager {

    var animationDuration: Double

    init(animationDuration: Double) {
        self.animationDuration = animationDuration
    }

    func strokeAnimationReverse(_ reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        if reverse {
            animation.fromValue = 1
            animation.toValue = 0
        } else {
            animation.fromValue = 0
            animation.toValue = 1
        }
        animation.duration = self.animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    func opacityAnimationReverse(_ reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")

        if reverse {
            animation.fromValue = 1
            animation.toValue = 0
        } else {
            animation.fromValue = 0
            animation.toValue = 1
        }
        animation.duration = self.animationDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    func morphAnimationFromPath(_ fromPath: UIBezierPath, toPath: UIBezierPath) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = fromPath.cgPath
        animation.toValue = toPath.cgPath

        return animation
    }

    func fillAnimationWithBounces(_ bounces: Int, amplitude: CGFloat, reverse: Bool) -> CAKeyframeAnimation {
        var values: [NSValue] = []
        var keyTimes: [NSNumber] = []

        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))
        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 0)))
        }

        keyTimes.append(0.0)

        for index in 1...bounces {
            let i = CGFloat(index)
            let scale = (i.truncatingRemainder(dividingBy: 2) != 0) ? (1 + amplitude / i) : (1 - amplitude / i)
            let time = i * 1.0 / CGFloat(bounces + 1)

            values.append(NSValue(caTransform3D: CATransform3DMakeScale(scale, scale, scale)))
            keyTimes.append(NSNumber(value: Float(time)))
        }

        if reverse {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)))

        } else {
            values.append(NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1)))

        }

        keyTimes.append(1.0)

        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.values = values
        animation.keyTimes = keyTimes
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

}
