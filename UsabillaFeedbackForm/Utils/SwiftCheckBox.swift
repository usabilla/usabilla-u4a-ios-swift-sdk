//
//  SwiftCheckBox.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 04/07/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol SwiftCheckBoxDelegate {
    func didTapCheckBox(checkBox: SwiftCheckBox)
    //func animationDidStopForCheckBox(checkBox: SwiftCheckBox)
}

class SwiftCheckBox: UIView {

    /** The layer where the box is drawn when the check box is set to On.
     */
    var delegate: SwiftCheckBoxDelegate?
    var onBoxLayer: CAShapeLayer!
    var offBoxLayer: CAShapeLayer!
    var checkMarkLayer: CAShapeLayer?
    let animationManager: AnimationManager
    let pathManager: PathManager
    var on: Bool = false
    var hideBox: Bool = false
    var boxType: BoxType = BoxType.Square {
        didSet {
            pathManager.boxType = boxType
            reload()
        }
    }

    var onTintColor: UIColor = UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 255/255, alpha: 1) {
        didSet {
            reload()
        }
    }
    var onFillColor: UIColor = UIColor.clearColor() {
        didSet {
            reload()
        }
    }
    var onCheckColor: UIColor = UIColor(colorLiteralRed: 0, green: 122.0/255.0, blue: 255/255, alpha: 1) {
        didSet {
            reload()
        }
    }
    var lineWidth: CGFloat = 2.0 {
        didSet {
            pathManager.lineWidth = lineWidth
            reload()
        }
    }

    var animationDuration = 0.5 {
        didSet {
            animationManager.animationDuration = animationDuration
        }
    }
    var minimumTouchSize = CGSize(width: 44, height: 44)
    var onAnimationType = AnimationType.Stroke
    var offAnimationType = AnimationType.Stroke
    //var _animationManager: AnimationManager


    override init(frame: CGRect) {
        pathManager = PathManager()
        pathManager.lineWidth = 2.0
        pathManager.boxType = BoxType.Square
        animationManager = AnimationManager(animationDuration: 0.5)

        super.init(frame: frame)
        offBoxLayer = CAShapeLayer(layer: layer)
        onBoxLayer = CAShapeLayer(layer: layer)

        backgroundColor = UIColor.clearColor()
        tintColor = UIColor.lightGrayColor()
    }

    required init(coder: NSCoder) {
        pathManager = PathManager()
        pathManager.lineWidth = 2.0
        pathManager.boxType = BoxType.Square
        animationManager = AnimationManager(animationDuration: 0.5)
        super.init(coder: coder)!
        offBoxLayer = CAShapeLayer(layer: layer)
        onBoxLayer = CAShapeLayer(layer: layer)

        backgroundColor = UIColor.clearColor()
        tintColor = UIColor.lightGrayColor()


    }


    override func layoutSubviews() {
        let a = self.frame.size.height
        self.pathManager.size = a
        super.layoutSubviews()
    }

    func reload() {
        offBoxLayer.removeFromSuperlayer()
        onBoxLayer.removeFromSuperlayer()
        checkMarkLayer?.removeFromSuperlayer()
        //self.onBoxLayer? = nil;
        //self.checkMarkLayer? = nil;
        setNeedsDisplay()
        layoutIfNeeded()
    }

    func setOn(on: Bool, animated: Bool) {
        self.on = on

        drawEntireCheckBox()

        if on {
            if animated {
                addOnAnimation()
            }
        } else {
            if animated {
                addOffAnimation()
            } else {
                onBoxLayer.removeFromSuperlayer()
                checkMarkLayer?.removeFromSuperlayer()
            }
        }
    }



    func setTintColora(tintColor: UIColor) {
        self.tintColor = tintColor
        drawOffBox()
    }



    func handleTapCheckBox() {
        setOn(!self.on, animated: true)
        delegate?.didTapCheckBox(self)

    }

    func pointInsidea(point: CGPoint, withEvent: UIEvent ) -> Bool {

        var found = super.pointInside(point, withEvent: withEvent)

        let minimumSize = self.minimumTouchSize
        let width = self.bounds.size.width
        let height = self.bounds.size.height

        if found == false && (width < minimumSize.width || height < minimumSize.height) {
            let increaseWidth = minimumSize.width - width
            let increaseHeight = minimumSize.height - height

            let rect = CGRectInset(self.bounds, (-increaseWidth / 2), (-increaseHeight / 2))

            found = rect.contains(point)
        }

        return found
    }


    override func drawRect(rect: CGRect) {
        setOn(self.on, animated: false)

    }

    /** Draws the entire checkbox, depending on the current state of the on property.
     */
    func drawEntireCheckBox() {
        if !self.hideBox {
            if  CGPathGetBoundingBox(self.offBoxLayer.path).size.height == 0.0 {
                drawOffBox()
            }
            if self.on {
                drawOnBox()
            }
        }
        if self.on {
            drawCheckMark()
        }
    }

    /** Draws the box used when the checkbox is set to Off.
     */
    func drawOffBox() {
        offBoxLayer.removeFromSuperlayer()
        self.offBoxLayer = CAShapeLayer(layer: layer)
        self.offBoxLayer.frame = self.bounds
        self.offBoxLayer.path = pathManager.pathForBox().CGPath
        self.offBoxLayer.fillColor = UIColor.clearColor().CGColor
        self.offBoxLayer.strokeColor = self.tintColor.CGColor
        self.offBoxLayer.lineWidth = self.lineWidth

        self.offBoxLayer.rasterizationScale = 2.0 * UIScreen.mainScreen().scale
        self.offBoxLayer.shouldRasterize = true


        self.layer.addSublayer(offBoxLayer)

    }

    /** Draws the box when the checkbox is set to On.
     */
    func drawOnBox() {
        onBoxLayer.removeFromSuperlayer()
        self.onBoxLayer = CAShapeLayer(layer: layer)
        self.onBoxLayer.frame = self.bounds
        self.onBoxLayer.path = pathManager.pathForBox().CGPath

        self.onBoxLayer.lineWidth = self.lineWidth
        self.onBoxLayer.fillColor = self.onFillColor.CGColor
        self.onBoxLayer.strokeColor = self.onTintColor.CGColor
        self.onBoxLayer.rasterizationScale = 2.0 * UIScreen.mainScreen().scale
        self.onBoxLayer.shouldRasterize = true
        self.layer.addSublayer(onBoxLayer)
    }

    /** Draws the check mark when the checkbox is set to On.
     */
    func drawCheckMark() {
        checkMarkLayer?.removeFromSuperlayer()
        self.checkMarkLayer = CAShapeLayer(layer: layer)
        self.checkMarkLayer?.frame = self.bounds
        self.checkMarkLayer?.path = pathManager.pathForCheckMark().CGPath
        self.checkMarkLayer?.strokeColor = self.onCheckColor.CGColor
        self.checkMarkLayer?.lineWidth = self.lineWidth
        self.checkMarkLayer?.fillColor =  UIColor.clearColor().CGColor
        self.checkMarkLayer?.lineCap = kCALineCapRound
        self.checkMarkLayer?.lineJoin = kCALineJoinRound

        self.checkMarkLayer?.rasterizationScale = 2.0 * UIScreen.mainScreen().scale
        self.checkMarkLayer?.shouldRasterize = true

        self.layer.addSublayer(checkMarkLayer!)

    }

    func addOnAnimation() {
        if self.animationDuration == 0.0 {
            return
        }

        switch self.onAnimationType {
        case AnimationType.Stroke:
            let animation = self.animationManager.strokeAnimationReverse(false)
            self.onBoxLayer.addAnimation(animation, forKey: "strokeEnd")

            animation.delegate = self
            self.checkMarkLayer?.addAnimation(animation, forKey: "strokeEnd")

            break

        case AnimationType.Fill:
            let wiggle = self.animationManager.fillAnimationWithBounces(1, amplitude: 0.18, reverse: false)
            let opacityAnimation = self.animationManager.opacityAnimationReverse(false)
            opacityAnimation.delegate = self
            self.onBoxLayer.addAnimation(wiggle, forKey: "transform")
            self.checkMarkLayer?.addAnimation(opacityAnimation, forKey: "opacity")

            break

        case .Bounce:
            let amplitude = (self.boxType == BoxType.Square) ? CGFloat( 0.20) : CGFloat(0.35)
            let wiggle = self.animationManager.fillAnimationWithBounces(1, amplitude: amplitude, reverse: false)
            wiggle.delegate = self

            let opacity = self.animationManager.opacityAnimationReverse(false)
            opacity.duration = self.animationDuration / 1.4

            self.onBoxLayer.addAnimation(opacity, forKey: "opacity")
            checkMarkLayer?.addAnimation(wiggle, forKey: "transform")

            break

        case .Flat:
            let morphAnimation = self.animationManager.morphAnimationFromPath(self.pathManager.pathForFlatCheckMark(), toPath: self.pathManager.pathForCheckMark())
            morphAnimation.delegate = self

            let opacity =  self.animationManager.opacityAnimationReverse(false)
            opacity.duration = self.animationDuration / 5

            onBoxLayer.addAnimation(opacity, forKey: "opacity")
            checkMarkLayer?.addAnimation(morphAnimation, forKey: "path")
            checkMarkLayer?.addAnimation(opacity, forKey: "opacity")

            break

        case .Stroke:
            // Temporary set the path of the checkmarl to the long checkmarl
            checkMarkLayer?.path = pathManager.pathForLongCheckMark().bezierPathByReversingPath().CGPath


            let boxStrokeAnimation = animationManager.strokeAnimationReverse(false)
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2
            onBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")


            let checkStrokeAnimation = animationManager.strokeAnimationReverse(false)
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkStrokeAnimation.fillMode = kCAFillModeBackwards
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            checkMarkLayer?.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")


            let checkMorphAnimation = animationManager.morphAnimationFromPath(pathManager.pathForLongCheckMark(), toPath: pathManager.pathForCheckMark())
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
            checkMorphAnimation.removedOnCompletion = false
            checkMorphAnimation.fillMode = kCAFillModeForwards
            checkMorphAnimation.delegate = self
            checkMarkLayer?.addAnimation(checkMorphAnimation, forKey: "path")

            break

        default:
            let animation = animationManager.opacityAnimationReverse(false)
            onBoxLayer.addAnimation(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.addAnimation(animation, forKey: "opacity")
            break
        }
    }

    func addOffAnimation() {
        if self.animationDuration == 0.0 {
            onBoxLayer.removeFromSuperlayer()
            checkMarkLayer?.removeFromSuperlayer()
        }

        switch self.offAnimationType {
        case .Stroke:
            let animation = animationManager.strokeAnimationReverse(true)
            onBoxLayer.addAnimation(animation, forKey: "strokeEnd")
            animation.delegate = self
            checkMarkLayer?.addAnimation(animation, forKey: "strokeEnd")
            break

        case .Fill:
            let wiggle = animationManager.fillAnimationWithBounces(1, amplitude: 0.18, reverse: true)
            wiggle.duration = self.animationDuration
            wiggle.delegate = self
            onBoxLayer.addAnimation(wiggle, forKey: "transform")
            checkMarkLayer?.addAnimation(animationManager.opacityAnimationReverse(true), forKey: "opacity")

            break

        case .Bounce:
            let amplitude = (self.boxType == BoxType.Square) ? CGFloat(0.20) : CGFloat(0.35)
            let wiggle = animationManager.fillAnimationWithBounces(1, amplitude: amplitude, reverse: true)
            wiggle.duration = self.animationDuration / 1.1
            let opacity = animationManager.opacityAnimationReverse(true)
            opacity.delegate = self
            onBoxLayer.addAnimation(opacity, forKey: "opacity")
            checkMarkLayer?.addAnimation(wiggle, forKey: "transform")

            break

        case .Flat:
            let animation = animationManager.morphAnimationFromPath(pathManager.pathForCheckMark(), toPath: pathManager.pathForFlatCheckMark())
            animation.delegate = self

            let opacity = animationManager.opacityAnimationReverse(true)
            opacity.duration = self.animationDuration

            onBoxLayer.addAnimation(opacity, forKey: "opacity")
            checkMarkLayer?.addAnimation(animation, forKey: "path")
            checkMarkLayer?.addAnimation(opacity, forKey: "opacity")

            break

        case .Stroke:
            self.checkMarkLayer?.path = pathManager.pathForLongCheckMark().bezierPathByReversingPath().CGPath

            let checkMorphAnimation = animationManager.morphAnimationFromPath(pathManager.pathForCheckMark(), toPath: pathManager.pathForLongCheckMark())
            checkMorphAnimation.delegate = nil
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6
            checkMarkLayer?.addAnimation(checkMorphAnimation, forKey: "path")


            let checkStrokeAnimation = self.animationManager.strokeAnimationReverse(true)
            checkStrokeAnimation.delegate = nil
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3
            checkMarkLayer?.addAnimation(checkStrokeAnimation, forKey: "strokeEnd")


            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.checkMarkLayer?.lineCap = kCALineCapButt
            })

            let boxStrokeAnimation = animationManager.strokeAnimationReverse(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2
            boxStrokeAnimation.delegate = self
            onBoxLayer.addAnimation(boxStrokeAnimation, forKey: "strokeEnd")

            break

        default:
            let animation = animationManager.opacityAnimationReverse(true)
            onBoxLayer.addAnimation(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.addAnimation(animation, forKey: "opacity")
            break
        }
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag == true {
            if self.on == false {
                onBoxLayer.removeFromSuperlayer()
                checkMarkLayer?.removeFromSuperlayer()


            }

            //delegate?.animationDidStopForCheckBox(self)
        }
    }
}



class PathManager {


    var boxType: BoxType
    var size: CGFloat!
    var lineWidth: CGFloat!


    init() {
        boxType = BoxType.Square
    }

    func pathForBox() -> UIBezierPath {
        let path: UIBezierPath

        switch self.boxType {
        case .Square:
            path = UIBezierPath(roundedRect: CGRectMake(0, 0, size, size), cornerRadius: 3.0)
            path.applyTransform(CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat( M_PI * 2.5)))
            path.applyTransform(CGAffineTransformMakeTranslation(size, 0))

            break

        default:
            let radius: CGFloat = self.size / 2
            path = UIBezierPath.init(arcCenter: CGPointMake(size/2, size/2), radius: radius, startAngle: CGFloat(-M_PI / 4), endAngle: CGFloat(2 * M_PI - M_PI / 4), clockwise: true)


            break
        }
        return path
    }

    func pathForCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()

        checkMarkPath.moveToPoint(CGPointMake(self.size/3.1578, self.size/2))
        checkMarkPath.addLineToPoint(CGPointMake(self.size/2.0618, self.size/1.57894))
        checkMarkPath.addLineToPoint(CGPointMake(self.size/1.3953, self.size/2.7272))


        if self.boxType == .Square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            checkMarkPath.applyTransform(CGAffineTransformMakeTranslation(-self.size/4, -self.size/4))

        }

        return checkMarkPath
    }

    func pathForLongCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()

        checkMarkPath.moveToPoint(CGPointMake(self.size/3.1578, self.size/2))
        checkMarkPath.addLineToPoint(CGPointMake(self.size/2.0618, self.size/1.57894))

        if self.boxType == .Square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.addLineToPoint(CGPointMake(self.size/1.2053, self.size/4.5272))
            checkMarkPath.applyTransform(CGAffineTransformMakeScale(1.5, 1.5))
            checkMarkPath.applyTransform(CGAffineTransformMakeTranslation(-self.size/4, -self.size/4))


        } else {
            checkMarkPath.addLineToPoint(CGPointMake(self.size/1.1553, self.size/5.9272))
        }

        return checkMarkPath
    }

    func pathForFlatCheckMark() -> UIBezierPath {
        let flatCheckMarkPath = UIBezierPath()
        flatCheckMarkPath.moveToPoint(CGPointMake(self.size/4, self.size/2))
        flatCheckMarkPath.addLineToPoint(CGPointMake(self.size/2, self.size/2))
        flatCheckMarkPath.addLineToPoint(CGPointMake(self.size/1.2, self.size/2))

        return flatCheckMarkPath
    }
}

enum BoxType {
    /** Circled box.
     */
    case Circle

    /** Squared box.
     */
    case Square
}

enum AnimationType {
    /** Animates the box and the check as if they were drawn.
     *  Should be used with a clear colored onFillColor property.
     */
    case Stroke

    /** When tapped, the checkbox is filled from its center.
     * Should be used with a colored onFillColor property.
     */
    case Fill

    /** Animates the check mark with a bouncy effect.
     */
    case Bounce

    /** Morphs the checkmark from a line.
     * Should be used with a colored onFillColor property.
     */
    case Flat

    /** Animates the box and check as if they were drawn in one continuous line.
     * Should be used with a clear colored onFillColor property.
     */
    case OneStroke

    /** When tapped, the checkbox is fading in or out (opacity).
     */
    case Fade
}


class AnimationManager {

    var animationDuration: Double

    init(animationDuration: Double) {
        self.animationDuration = animationDuration
    }

    func strokeAnimationReverse(reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        if reverse {
            animation.fromValue = 1
            animation.toValue = 0
        } else {
            animation.fromValue = 0
            animation.toValue = 1
        }
        animation.duration = self.animationDuration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    func opacityAnimationReverse(reverse: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "opacity")

        if reverse {
            animation.fromValue = 1
            animation.toValue = 0
        } else {
            animation.fromValue = 0
            animation.toValue = 1
        }
        animation.duration = self.animationDuration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    func morphAnimationFromPath(fromPath: UIBezierPath, toPath: UIBezierPath ) -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)


        animation.fromValue = fromPath.CGPath
        animation.toValue = toPath.CGPath

        return animation
    }

    func fillAnimationWithBounces(bounces: Int, amplitude: CGFloat, reverse: Bool) -> CAKeyframeAnimation {
        var values: [NSValue] = []
        var keyTimes: [NSNumber] = []

        if reverse {
            values.append(NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1)))
        } else {
            values.append(NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 0)))
        }

        keyTimes.append(0.0)

        for index in 1...bounces {
            let i = CGFloat(index)
            let scale = (i % 2 != 0) ? (1 + amplitude/i) : (1 - amplitude/i)
            let time = i * 1.0/CGFloat(bounces + 1)

            values.append(NSValue(CATransform3D: CATransform3DMakeScale(scale, scale, scale)))
            keyTimes.append(time)

        }


        if reverse {
            values.append(NSValue(CATransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)))

        } else {
            values.append(NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1)))

        }

        keyTimes.append(1.0)

        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.values = values
        animation.keyTimes = keyTimes
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = self.animationDuration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)


        return animation
    }


}
