//
//  StarRatingView.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/08/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol SwiftStarDelegate {
    func starValueChanged(value: Int)
}


class StarRatingiView: UIControl {
    
    var delegate: SwiftStarDelegate?
    var shouldBecomeFirstResponder: Bool
    var minimumValue: Int
    var maximumValue: Int
    var currentValue: Int {
        didSet{
            delegate?.starValueChanged(currentValue)
            setNeedsDisplay()
        }
    }
    var spacing: CGFloat {
        
        //            willSet {
        //                spacing = max(newValue, 0)
        //            }
        //
        didSet{
            setNeedsDisplay()
        }
        
    }
    var continuous: Bool
    
    var allowHalfStars: Bool {
        didSet{
            setNeedsDisplay()
        }
    }
    var accurateHalfStars: Bool {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var emptyStarImage:UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    var halfStarImage:UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var filledStarImage:UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var shouldUseImages:Bool {
        get {
            return emptyStarImage != nil && filledStarImage != nil
        }
    }
    
    
    override var enabled:Bool{
        didSet{
            updateAppearanceForState(enabled)
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
        exclusiveTouch = true
        updateAppearanceForState(enabled)
        
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
        exclusiveTouch = true
        updateAppearanceForState(enabled)
        
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
    
    
    override var backgroundColor :UIColor? {
        get {
            if (super.backgroundColor != nil) {
                return super.backgroundColor
            } else {
                return self.opaque ? UIColor.whiteColor() : UIColor.clearColor()
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
    
    
    
    func updateAppearanceForState(enabled: Bool){
        alpha = enabled ? 1.0 : 0.5
    }
    
    
    func drawStarImageWithFrame(frame :CGRect, tintColor :UIColor, highlighted:Bool) {
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
    func drawImage(image :UIImage, frame:CGRect, tintColor:UIColor) {
        if image.renderingMode == .AlwaysTemplate {
            tintColor.setFill()
        }
        image.drawInRect(frame)
    }
    
    func drawStarShapeWithFrame(frame: CGRect,tintColor:UIColor, highlighted:Bool) {
        drawAccurateHalfStarShapeWithFrame(frame, tintColor: tintColor, progress: highlighted ? 1: 0)
    }
    
    func drawHalfStarShapeWithFrame(frame: CGRect, tintColor:UIColor) {
        drawAccurateHalfStarShapeWithFrame(frame, tintColor: tintColor, progress: 0.5)
    }
    
    func drawAccurateHalfStarShapeWithFrame(frame: CGRect, tintColor:UIColor, progress:CGFloat) {
        let starShapePath = UIBezierPath()
        starShapePath.moveToPoint(CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.79358 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.69501 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.97500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame)))
        starShapePath.addLineToPoint(CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame)))
        starShapePath.closePath()
        starShapePath.miterLimit = 4
        
        let frameWidth = frame.size.width;
        let rightRectOfStar = CGRectMake(frame.origin.x + progress * frameWidth, frame.origin.y, frameWidth - progress * frameWidth, frame.size.height);
        let clipPath = UIBezierPath.init(rect: CGRectInfinite)// [UIBezierPath bezierPathWithRect:CGRectInfinite];
        clipPath.appendPath(UIBezierPath(rect: rightRectOfStar))
        
        clipPath.usesEvenOddFillRule = true
        
        CGContextSaveGState(UIGraphicsGetCurrentContext()!)
        clipPath.addClip()
        tintColor.setFill()
        starShapePath.fill()
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext()!);
        
        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()
    }
    
    
    override func drawRect(rect :CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context!, self.backgroundColor!.CGColor)
        CGContextFillRect(context!, rect)
        
        let availableWidth = rect.size.width - (spacing * CGFloat(maximumValue - 1)) - 2
        let cellWidth = availableWidth / CGFloat(maximumValue)
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height;
        
        for idx in 0...Int(maximumValue) {
            
            let center = CGPointMake(cellWidth * CGFloat(idx) + cellWidth/2 + spacing * CGFloat(idx) + 1, rect.size.height/2)
            let frame = CGRectMake(center.x - starSide/2, center.y - starSide/2, starSide, starSide);
            let highlighted = (idx < currentValue)
            
            drawStarWithFrame(frame, tintColor: tintColor, highlighted: highlighted)
        }
    }
    
    func drawStarWithFrame(frame: CGRect, tintColor:UIColor, highlighted:Bool) {
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
    
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if enabled {
            super.beginTrackingWithTouch(touch, withEvent: event)
            if shouldBecomeFirstResponder && !isFirstResponder() {
                becomeFirstResponder()
            }
            handleTouch(touch)
            
            return true
        } else {
            return false
        }
    }
    
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if enabled{
            super.continueTrackingWithTouch(touch, withEvent: event)
            handleTouch(touch)
            return true
        } else {
            return false
        }
    }
    
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        if (shouldBecomeFirstResponder && self.isFirstResponder()) {
            resignFirstResponder()
        }
        handleTouch(touch)
        if !continuous {
            sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        
        if (shouldBecomeFirstResponder && isFirstResponder()) {
            resignFirstResponder()
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = gestureRecognizer.view {
            if view.isEqual(self) {
                return !self.userInteractionEnabled
            }
        }
        return false
        
    }
    
    
    func handleTouch( touch:UITouch? ) {
        if let touch = touch {
            let cellWidth = self.bounds.size.width / CGFloat(maximumValue)
            let location = touch.locationInView(self)
            let value = location.x / cellWidth
            let touchValue = Int(value + 1)
            if touchValue >= minimumValue && touchValue <= maximumValue {
                currentValue = touchValue
            }
        }
        //setValue(currentValue, sendValueChangedAction: continuous)
        
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return shouldBecomeFirstResponder
    }
    
    override func intrinsicContentSize() -> CGSize {
        let height = 44.0
        return CGSizeMake(CGFloat(maximumValue) * CGFloat(height) + CGFloat(maximumValue - 1) * spacing, CGFloat(height))
    }
    
}
