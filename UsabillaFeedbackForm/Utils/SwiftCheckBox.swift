//
//  SwiftCheckBox.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 04/07/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol SwiftCheckBoxDelegate: class {
    func didTapCheckBox(_ checkBox: SwiftCheckBox)
    //func animationDidStopForCheckBox(checkBox: SwiftCheckBox)
}

class SwiftCheckBox: UIView, CAAnimationDelegate {

    /** The layer where the box is drawn when the check box is set to On.
     */
    weak var delegate: SwiftCheckBoxDelegate?
    var onBoxLayer: CAShapeLayer!
    var offBoxLayer: CAShapeLayer!
    var checkMarkLayer: CAShapeLayer?
    let animationManager: AnimationManager
    let pathManager: PathManager
    var on: Bool = false
    var hideBox: Bool = false
    var boxType: BoxType = BoxType.square {
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
    var onFillColor: UIColor = UIColor.clear {
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
    var onAnimationType = AnimationType.stroke
    var offAnimationType = AnimationType.stroke
    //var _animationManager: AnimationManager


    override init(frame: CGRect) {
        pathManager = PathManager()
        pathManager.lineWidth = 2.0
        pathManager.boxType = BoxType.square
        animationManager = AnimationManager(animationDuration: 0.5)

        super.init(frame: frame)
        offBoxLayer = CAShapeLayer(layer: layer)
        onBoxLayer = CAShapeLayer(layer: layer)

        backgroundColor = UIColor.clear
        tintColor = UIColor.lightGray
    }

    required init(coder: NSCoder) {
        pathManager = PathManager()
        pathManager.lineWidth = 2.0
        pathManager.boxType = BoxType.square
        animationManager = AnimationManager(animationDuration: 0.5)
        super.init(coder: coder)!
        offBoxLayer = CAShapeLayer(layer: layer)
        onBoxLayer = CAShapeLayer(layer: layer)

        backgroundColor = UIColor.clear
        tintColor = UIColor.lightGray


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

    func setOn(_ on: Bool, animated: Bool) {
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



    func setTintColora(_ tintColor: UIColor) {
        self.tintColor = tintColor
        drawOffBox()
    }



    func handleTapCheckBox() {
        setOn(!self.on, animated: true)
        delegate?.didTapCheckBox(self)

    }

    func pointInsidea(_ point: CGPoint, withEvent: UIEvent ) -> Bool {

        var found = super.point(inside: point, with: withEvent)

        let minimumSize = self.minimumTouchSize
        let width = self.bounds.size.width
        let height = self.bounds.size.height

        if found == false && (width < minimumSize.width || height < minimumSize.height) {
            let increaseWidth = minimumSize.width - width
            let increaseHeight = minimumSize.height - height

            let rect = self.bounds.insetBy(dx: (-increaseWidth / 2), dy: (-increaseHeight / 2))

            found = rect.contains(point)
        }

        return found
    }


    override func draw(_ rect: CGRect) {
        setOn(self.on, animated: false)
    }

    /** Draws the entire checkbox, depending on the current state of the on property.
     */
    func drawEntireCheckBox() {
        if !self.hideBox {
//            if let path = self.offBoxLayer.path {
//                if  CGPathGetBoundingBox(path).size.height == 0.0 {
//                drawOffBox()
//            }  DUNNO WHAT I'M DOING, PLEASE HELP
//            }
            if self.on {
                drawOnBox()
            } else {
                drawOffBox()
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
        self.offBoxLayer.path = pathManager.pathForBox().cgPath
        self.offBoxLayer.fillColor = UIColor.clear.cgColor
        self.offBoxLayer.strokeColor = self.tintColor.cgColor
        self.offBoxLayer.lineWidth = self.lineWidth

        self.offBoxLayer.rasterizationScale = 2.0 * UIScreen.main.scale
        self.offBoxLayer.shouldRasterize = true


        self.layer.addSublayer(offBoxLayer)

    }

    /** Draws the box when the checkbox is set to On.
     */
    func drawOnBox() {
        onBoxLayer.removeFromSuperlayer()
        self.onBoxLayer = CAShapeLayer(layer: layer)
        self.onBoxLayer.frame = self.bounds
        self.onBoxLayer.path = pathManager.pathForBox().cgPath

        self.onBoxLayer.lineWidth = self.lineWidth
        self.onBoxLayer.fillColor = self.onFillColor.cgColor
        self.onBoxLayer.strokeColor = self.onTintColor.cgColor
        self.onBoxLayer.rasterizationScale = 2.0 * UIScreen.main.scale
        self.onBoxLayer.shouldRasterize = true
        self.layer.addSublayer(onBoxLayer)
    }

    /** Draws the check mark when the checkbox is set to On.
     */
    func drawCheckMark() {
        checkMarkLayer?.removeFromSuperlayer()
        self.checkMarkLayer = CAShapeLayer(layer: layer)
        self.checkMarkLayer?.frame = self.bounds
        self.checkMarkLayer?.path = pathManager.pathForCheckMark().cgPath
        self.checkMarkLayer?.strokeColor = self.onCheckColor.cgColor
        self.checkMarkLayer?.lineWidth = self.lineWidth
        self.checkMarkLayer?.fillColor =  UIColor.clear.cgColor
        self.checkMarkLayer?.lineCap = kCALineCapRound
        self.checkMarkLayer?.lineJoin = kCALineJoinRound

        self.checkMarkLayer?.rasterizationScale = 2.0 * UIScreen.main.scale
        self.checkMarkLayer?.shouldRasterize = true

        self.layer.addSublayer(checkMarkLayer!)

    }

    func addOnAnimation() {
        if self.animationDuration == 0.0 {
            return
        }

        switch self.onAnimationType {
        case AnimationType.stroke:
            let animation = self.animationManager.strokeAnimationReverse(false)
            self.onBoxLayer.add(animation, forKey: "strokeEnd")

            animation.delegate = self
            self.checkMarkLayer?.add(animation, forKey: "strokeEnd")

            break

        case AnimationType.fill:
            let wiggle = self.animationManager.fillAnimationWithBounces(1, amplitude: 0.18, reverse: false)
            let opacityAnimation = self.animationManager.opacityAnimationReverse(false)
            opacityAnimation.delegate = self
            self.onBoxLayer.add(wiggle, forKey: "transform")
            self.checkMarkLayer?.add(opacityAnimation, forKey: "opacity")

            break

        case .bounce:
            let amplitude = (self.boxType == BoxType.square) ? CGFloat( 0.20) : CGFloat(0.35)
            let wiggle = self.animationManager.fillAnimationWithBounces(1, amplitude: amplitude, reverse: false)
            wiggle.delegate = self

            let opacity = self.animationManager.opacityAnimationReverse(false)
            opacity.duration = self.animationDuration / 1.4

            self.onBoxLayer.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(wiggle, forKey: "transform")

            break

        case .flat:
            let morphAnimation = self.animationManager.morphAnimationFromPath(self.pathManager.pathForFlatCheckMark(), toPath: self.pathManager.pathForCheckMark())
            morphAnimation.delegate = self

            let opacity =  self.animationManager.opacityAnimationReverse(false)
            opacity.duration = self.animationDuration / 5

            onBoxLayer.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(morphAnimation, forKey: "path")
            checkMarkLayer?.add(opacity, forKey: "opacity")

            break

        case .stroke:
            // Temporary set the path of the checkmarl to the long checkmarl
            checkMarkLayer?.path = pathManager.pathForLongCheckMark().reversing().cgPath


            let boxStrokeAnimation = animationManager.strokeAnimationReverse(false)
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2
            onBoxLayer.add(boxStrokeAnimation, forKey: "strokeEnd")


            let checkStrokeAnimation = animationManager.strokeAnimationReverse(false)
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3
            checkStrokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkStrokeAnimation.fillMode = kCAFillModeBackwards
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration
            checkMarkLayer?.add(checkStrokeAnimation, forKey: "strokeEnd")


            let checkMorphAnimation = animationManager.morphAnimationFromPath(pathManager.pathForLongCheckMark(), toPath: pathManager.pathForCheckMark())
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6
            checkMorphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            checkMorphAnimation.beginTime = CACurrentMediaTime() + boxStrokeAnimation.duration + checkStrokeAnimation.duration
            checkMorphAnimation.isRemovedOnCompletion = false
            checkMorphAnimation.fillMode = kCAFillModeForwards
            checkMorphAnimation.delegate = self
            checkMarkLayer?.add(checkMorphAnimation, forKey: "path")

            break

        default:
            let animation = animationManager.opacityAnimationReverse(false)
            onBoxLayer.add(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "opacity")
            break
        }
    }

    func addOffAnimation() {
        if self.animationDuration == 0.0 {
            onBoxLayer.removeFromSuperlayer()
            checkMarkLayer?.removeFromSuperlayer()
        }

        switch self.offAnimationType {
        case .stroke:
            let animation = animationManager.strokeAnimationReverse(true)
            onBoxLayer.add(animation, forKey: "strokeEnd")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "strokeEnd")
            break

        case .fill:
            let wiggle = animationManager.fillAnimationWithBounces(1, amplitude: 0.18, reverse: true)
            wiggle.duration = self.animationDuration
            wiggle.delegate = self
            onBoxLayer.add(wiggle, forKey: "transform")
            checkMarkLayer?.add(animationManager.opacityAnimationReverse(true), forKey: "opacity")

            break

        case .bounce:
            let amplitude = (self.boxType == BoxType.square) ? CGFloat(0.20) : CGFloat(0.35)
            let wiggle = animationManager.fillAnimationWithBounces(1, amplitude: amplitude, reverse: true)
            wiggle.duration = self.animationDuration / 1.1
            let opacity = animationManager.opacityAnimationReverse(true)
            opacity.delegate = self
            onBoxLayer.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(wiggle, forKey: "transform")

            break

        case .flat:
            let animation = animationManager.morphAnimationFromPath(pathManager.pathForCheckMark(), toPath: pathManager.pathForFlatCheckMark())
            animation.delegate = self

            let opacity = animationManager.opacityAnimationReverse(true)
            opacity.duration = self.animationDuration

            onBoxLayer.add(opacity, forKey: "opacity")
            checkMarkLayer?.add(animation, forKey: "path")
            checkMarkLayer?.add(opacity, forKey: "opacity")

            break

        case .stroke:
            self.checkMarkLayer?.path = pathManager.pathForLongCheckMark().reversing().cgPath

            let checkMorphAnimation = animationManager.morphAnimationFromPath(pathManager.pathForCheckMark(), toPath: pathManager.pathForLongCheckMark())
            checkMorphAnimation.delegate = nil
            checkMorphAnimation.duration = checkMorphAnimation.duration / 6
            checkMarkLayer?.add(checkMorphAnimation, forKey: "path")


            let checkStrokeAnimation = self.animationManager.strokeAnimationReverse(true)
            checkStrokeAnimation.delegate = nil
            checkStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration
            checkStrokeAnimation.duration = checkStrokeAnimation.duration / 3
            checkMarkLayer?.add(checkStrokeAnimation, forKey: "strokeEnd")


            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self.checkMarkLayer?.lineCap = kCALineCapButt
            })

            let boxStrokeAnimation = animationManager.strokeAnimationReverse(true)
            boxStrokeAnimation.beginTime = CACurrentMediaTime() + checkMorphAnimation.duration + checkStrokeAnimation.duration
            boxStrokeAnimation.duration = boxStrokeAnimation.duration / 2
            boxStrokeAnimation.delegate = self
            onBoxLayer.add(boxStrokeAnimation, forKey: "strokeEnd")

            break

        default:
            let animation = animationManager.opacityAnimationReverse(true)
            onBoxLayer.add(animation, forKey: "opacity")
            animation.delegate = self
            checkMarkLayer?.add(animation, forKey: "opacity")
            break
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
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
        boxType = BoxType.square
    }

    func pathForBox() -> UIBezierPath {
        let path: UIBezierPath

        switch self.boxType {
        case .square:
            path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: 3.0)
            path.apply(CGAffineTransform.identity.rotated(by: CGFloat( M_PI * 2.5)))
            path.apply(CGAffineTransform(translationX: size, y: 0))

            break

        default:
            let radius: CGFloat = self.size / 2
            path = UIBezierPath.init(arcCenter: CGPoint(x: size/2, y: size/2), radius: radius, startAngle: CGFloat(-M_PI / 4), endAngle: CGFloat(2 * M_PI - M_PI / 4), clockwise: true)


            break
        }
        return path
    }

    func pathForCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()

        checkMarkPath.move(to: CGPoint(x: self.size/3.1578, y: self.size/2))
        checkMarkPath.addLine(to: CGPoint(x: self.size/2.0618, y: self.size/1.57894))
        checkMarkPath.addLine(to: CGPoint(x: self.size/1.3953, y: self.size/2.7272))


        if self.boxType == .square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
            checkMarkPath.apply(CGAffineTransform(translationX: -self.size/4, y: -self.size/4))

        }

        return checkMarkPath
    }

    func pathForLongCheckMark() -> UIBezierPath {
        let checkMarkPath = UIBezierPath()

        checkMarkPath.move(to: CGPoint(x: self.size/3.1578, y: self.size/2))
        checkMarkPath.addLine(to: CGPoint(x: self.size/2.0618, y: self.size/1.57894))

        if self.boxType == .square {
            // If we use a square box, the check mark should be a little bit bigger
            checkMarkPath.addLine(to: CGPoint(x: self.size/1.2053, y: self.size/4.5272))
            checkMarkPath.apply(CGAffineTransform(scaleX: 1.5, y: 1.5))
            checkMarkPath.apply(CGAffineTransform(translationX: -self.size/4, y: -self.size/4))


        } else {
            checkMarkPath.addLine(to: CGPoint(x: self.size/1.1553, y: self.size/5.9272))
        }

        return checkMarkPath
    }

    func pathForFlatCheckMark() -> UIBezierPath {
        let flatCheckMarkPath = UIBezierPath()
        flatCheckMarkPath.move(to: CGPoint(x: self.size/4, y: self.size/2))
        flatCheckMarkPath.addLine(to: CGPoint(x: self.size/2, y: self.size/2))
        flatCheckMarkPath.addLine(to: CGPoint(x: self.size/1.2, y: self.size/2))

        return flatCheckMarkPath
    }
}

enum BoxType {
    /** Circled box.
     */
    case circle

    /** Squared box.
     */
    case square
}

enum AnimationType {
    /** Animates the box and the check as if they were drawn.
     *  Should be used with a clear colored onFillColor property.
     */
    case stroke

    /** When tapped, the checkbox is filled from its center.
     * Should be used with a colored onFillColor property.
     */
    case fill

    /** Animates the check mark with a bouncy effect.
     */
    case bounce

    /** Morphs the checkmark from a line.
     * Should be used with a colored onFillColor property.
     */
    case flat

    /** Animates the box and check as if they were drawn in one continuous line.
     * Should be used with a clear colored onFillColor property.
     */
    case oneStroke

    /** When tapped, the checkbox is fading in or out (opacity).
     */
    case fade
}


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

    func morphAnimationFromPath(_ fromPath: UIBezierPath, toPath: UIBezierPath ) -> CABasicAnimation {
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
            let scale = (i.truncatingRemainder(dividingBy: 2) != 0) ? (1 + amplitude/i) : (1 - amplitude/i)
            let time = i * 1.0/CGFloat(bounces + 1)

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
