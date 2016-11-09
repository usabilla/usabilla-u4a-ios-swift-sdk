//
//  StarRatingView.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/08/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol SwiftStarDelegate: class {
    func starValueChanged(_ value: Int)
}


class StarRatingiView: UIControl {

    weak var delegate: SwiftStarDelegate?
    var shouldBecomeFirstResponder: Bool
    var minimumValue: Int
    var maximumValue: Int
    var currentValue: Int {
        didSet {
            delegate?.starValueChanged(currentValue)
            setNeedsDisplay()
        }
    }
    var spacing: CGFloat {

        //            willSet {
        //                spacing = max(newValue, 0)
        //            }
        //
        didSet {
            setNeedsDisplay()
        }

    }
    var continuous: Bool

    var allowHalfStars: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    var accurateHalfStars: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    var emptyStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }


    var halfStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    var filledStarImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }

    var shouldUseImages: Bool {
        get {
            return emptyStarImage != nil && filledStarImage != nil
        }
    }


    override var isEnabled: Bool {
        didSet {
            updateAppearanceForState(isEnabled)
        }
    }

    override init(frame: CGRect) {

        minimumValue = 0
        maximumValue = 5
        currentValue = 0
        spacing = 5
        continuous = true
        shouldBecomeFirstResponder = false
        allowHalfStars = false
        accurateHalfStars = true
        super.init(frame: frame)
        isExclusiveTouch = true
        updateAppearanceForState(isEnabled)

    }

    required init?(coder aDecoder: NSCoder) {
        minimumValue = 0
        maximumValue = 5
        currentValue = 0
        spacing = 5
        continuous = true
        shouldBecomeFirstResponder = false
        allowHalfStars = false
        accurateHalfStars = true
        super.init(coder: aDecoder)
        isExclusiveTouch = true
        updateAppearanceForState(isEnabled)

    }

    //    init() {
    //        exclusiveTouch = true
    //        minimumValue = 0
    //        maximumValue = 5
    //        currentValue = 0
    //        spacing = 5
    //        continuous = true
    //        updateAppearanceForState(enabled)
    //        shouldBecomeFirstResponder = false
    //        allowHalfStars = false
    //        accurateHalfStars = true
    //
    //    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
        setNeedsDisplay()
    }


    override var backgroundColor: UIColor? {
        get {
            if (super.backgroundColor != nil) {
                return super.backgroundColor
            } else {
                return self.isOpaque ? UIColor.white : UIColor.clear
            }
        }

        set {
            super.backgroundColor = newValue
        }
    }



    //    func setValue(newValue: Int, sendValueChangedAction: Bool) {
    //        //[self willChangeValueForKey:NSStringFromSelector(@selector(value))];
    //        willChangeValueForKey("currentValue")
    //        if (newValue >= minimumValue && newValue <= maximumValue) {
    //            currentValue = newValue
    //            if sendAction {
    //                sendActionsForControlEvents(UIControlEvents.ValueChanged)
    //            }
    //            setNeedsDisplay()
    //        }
    //        //[self didChangeValueForKey:NSStringFromSelector(@selector(value))];
    //        didChangeValueForKey("currentValue")
    //    }



    func updateAppearanceForState(_ enabled: Bool) {
        alpha = enabled ? 1.0 : 0.5
    }


    func drawStarImageWithFrame(_ frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        let image = highlighted ? self.filledStarImage : self.emptyStarImage
        drawImage(image!, frame: frame, tintColor: tintColor)
    }



    //    func drawHalfStarImageWithFrame(frame :CGRect, tintColor:UIColor ) {
    //        [self _drawAccurateHalfStarImageWithFrame:frame tintColor:tintColor progress:.5f];
    //    }
    //
    //    func drawAccurateHalfStarImageWithFrame(frame :CGRect, tintColor:UIColor, progress:CGFloat) {
    //        var image = self.halfStarImage;
    //        if image == nil {
    //            // first draw star outline
    //            [self _drawStarImageWithFrame:frame tintColor:tintColor highlighted:NO];
    //
    //            image = self.filledStarImage
    //            let imageFrame = CGRectMake(0, 0, image!.size.width * image!.scale * progress, image!.size.height * image!.scale);
    //            frame.size.width = frame.size.width * progress
    //            let imageRef = CGImageCreateWithImageInRect(image.CGImage, imageFrame);
    //            let halfImage = UIImage(CGImage: imageRef, scale: image?.scale, orientation: image?.imageOrientation)
    //            image = UIImage(CGImage: halfImage).imageWithRenderingMode(image?.renderingMode) // [halfImage imageWithRenderingMode:image.renderingMode];
    //            CGImageRelease(imageRef)
    //        }
    //        [self _drawImage:image frame:frame tintColor:tintColor];
    //    }
    //
    func drawImage(_ image: UIImage, frame: CGRect, tintColor: UIColor) {
        if image.renderingMode == .alwaysTemplate {
            tintColor.setFill()
        }
        image.draw(in: frame)
    }

    func drawStarShapeWithFrame(_ frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        drawAccurateHalfStarShapeWithFrame(frame, tintColor: tintColor, progress: highlighted ? 1: 0)
    }

    func drawHalfStarShapeWithFrame(_ frame: CGRect, tintColor: UIColor) {
        drawAccurateHalfStarShapeWithFrame(frame, tintColor: tintColor, progress: 0.5)
    }

    func drawAccurateHalfStarShapeWithFrame(_ frame: CGRect, tintColor: UIColor, progress: CGFloat) {
        let starShapePath = UIBezierPath()
        starShapePath.move(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.02500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.37292 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.02500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.30504 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.20642 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.78265 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.79358 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.69501 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.97500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.close()
        starShapePath.miterLimit = 4

        let frameWidth = frame.size.width
        let rightRectOfStar = CGRect(x: frame.origin.x + progress * frameWidth, y: frame.origin.y, width: frameWidth - progress * frameWidth, height: frame.size.height)
        let clipPath = UIBezierPath.init(rect: CGRect.infinite)// [UIBezierPath bezierPathWithRect:CGRectInfinite];
        clipPath.append(UIBezierPath(rect: rightRectOfStar))

        clipPath.usesEvenOddFillRule = true

        UIGraphicsGetCurrentContext()!.saveGState()
        clipPath.addClip()
        tintColor.setFill()
        starShapePath.fill()

        UIGraphicsGetCurrentContext()!.restoreGState()

        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()
    }


    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.backgroundColor!.cgColor)
        context!.fill(rect)

        let availableWidth = rect.size.width - (spacing * CGFloat(maximumValue - 1)) - 2
        let cellWidth = availableWidth / CGFloat(maximumValue)
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height

        for idx in 0...Int(maximumValue) {

            let center = CGPoint(x: cellWidth * CGFloat(idx) + cellWidth/2 + spacing * CGFloat(idx) + 1, y: rect.size.height/2)
            let frame = CGRect(x: center.x - starSide/2, y: center.y - starSide/2, width: starSide, height: starSide)
            let highlighted = (idx < currentValue)

            drawStarWithFrame(frame, tintColor: tintColor, highlighted: highlighted)
        }
    }

    func drawStarWithFrame(_ frame: CGRect, tintColor: UIColor, highlighted: Bool) {
        if shouldUseImages {
            drawStarImageWithFrame(frame, tintColor: tintColor, highlighted: highlighted)
        } else {
            drawStarShapeWithFrame(frame, tintColor: tintColor, highlighted: highlighted)

        }
    }

    //    - (void)_drawHalfStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
    //    if (self.shouldUseImages) {
    //    [self _drawHalfStarImageWithFrame:frame tintColor:tintColor];
    //    } else {
    //    [self _drawHalfStarShapeWithFrame:frame tintColor:tintColor];
    //    }
    //    }
    //    - (void)_drawAccurateStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    //    if (self.shouldUseImages) {
    //    [self _drawAccurateHalfStarImageWithFrame:frame tintColor:tintColor progress:progress];
    //    } else {
    //    [self _drawAccurateHalfStarShapeWithFrame:frame tintColor:tintColor progress:progress];
    //    }
    //    }


    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.beginTracking(touch, with: event)
            if shouldBecomeFirstResponder && !isFirstResponder {
                becomeFirstResponder()
            }
            handleTouch(touch)

            return true
        } else {
            return false
        }
    }


    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if isEnabled {
            super.continueTracking(touch, with: event)
            handleTouch(touch)
            return true
        } else {
            return false
        }
    }


    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)

        if (shouldBecomeFirstResponder && self.isFirstResponder) {
            resignFirstResponder()
        }
        handleTouch(touch)
        if !continuous {
            sendActions(for: .valueChanged)
        }
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)

        if (shouldBecomeFirstResponder && isFirstResponder) {
            resignFirstResponder()
        }
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = gestureRecognizer.view {
            if view.isEqual(self) {
                return !self.isUserInteractionEnabled
            }
        }
        return false

    }


    func handleTouch( _ touch: UITouch? ) {
        if let touch = touch {
            let cellWidth = self.bounds.size.width / CGFloat(maximumValue)
            let location = touch.location(in: self)
            let value = location.x / cellWidth
            let touchValue = Int(value + 1)
            if touchValue >= minimumValue && touchValue <= maximumValue {
                currentValue = touchValue
            }
        }
        //setValue(currentValue, sendValueChangedAction: continuous)

    }


    override var canBecomeFirstResponder : Bool {
        return shouldBecomeFirstResponder
    }

    override var intrinsicContentSize : CGSize {
        let height = 44.0
        return CGSize(width: CGFloat(maximumValue) * CGFloat(height) + CGFloat(maximumValue - 1) * spacing, height: CGFloat(height))
    }

}
