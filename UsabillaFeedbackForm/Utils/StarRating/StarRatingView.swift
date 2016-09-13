//
//  StarRatingView.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 19/08/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class StarRatingiView: UIControl {
    
    var shouldBecomeFirstResponder: Bool
    var minimumValue: Int
    var maximumValue: Int
    var currentValue: Int
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
    var opaque: Bool
    
    override init(frame: CGRect) {
        customInit()
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        customInit()
        super.init(coder: aDecoder)
    }
    
    func customInit() {
        self.exclusiveTouch = true
        minimumValue = 0
        maximumValue = 5
        spacing = 5
        continuous = true
        updateAppearanceForState(enabled)
    }
    
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
            self.backgroundColor = newValue
        }
    }
    
    
    
    func setValue(newValue: Int, sendValueChangedAction: Bool) {
        //[self willChangeValueForKey:NSStringFromSelector(@selector(value))];
        willChangeValueForKey("currentValue")
        if (newValue >= minimumValue && newValue <= maximumValue) {
            currentValue = newValue
            if sendAction {
                sendActionsForControlEvents(UIControlEvents.ValueChanged)
            }
            setNeedsDisplay()
        }
        //[self didChangeValueForKey:NSStringFromSelector(@selector(value))];
        didChangeValueForKey("currentValue")
    }
    
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
            return self.emptyStarImage != nil && self.filledStarImage != nil
            
        }
    }
    
    
    override var enabled:Bool{
        didSet{
            updateAppearanceForState(enabled)
        }
    }
    
    func updateAppearanceForState(enabled: Bool){
        self.alpha = enabled ? 1.0 : 0.5
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
        [self _drawAccurateHalfStarShapeWithFrame:frame tintColor:tintColor progress:highlighted ? 1.f : 0.f];
    }
    
    func drawHalfStarShapeWithFrame(frame: CGRect, tintColor:UIColor) {
        [self _drawAccurateHalfStarShapeWithFrame:frame tintColor:tintColor progress:.5f];
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
        
        let availableWidth = rect.size.width - (spacing * Float(maximumValue - 1)) - 2
        let cellWidth = availableWidth / maximumValue
        let starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height;
        
        for idx in 0...Int(maximumValue) {
            
            let center = CGPointMake(cellWidth * idx + cellWidth/2 + spacing * idx + 1, rect.size.height/2)
            let frame = CGRectMake(center.x - starSide/2, center.y - starSide/2, starSide, starSide);
            let highlighted = (idx + 1 <= ceilf(currentValue))
            
            [self _drawStarWithFrame:frame tintColor:self.tintColor highlighted:highlighted];
            
        }
    }
    
    func drawStarWithFrame(Cframe: GRect, tintColor:UIColor, highlighted:Bool) {
        if self.shouldUseImages {
            drawStarImageWithFrame(frame, tintColor: tintColor, highlighted: highlighted)
            
        } else {
            drawstarsh
            [self _drawStarShapeWithFrame:frame tintColor:tintColor highlighted:highlighted];
        }
    }
    
    - (void)_drawHalfStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
    if (self.shouldUseImages) {
    [self _drawHalfStarImageWithFrame:frame tintColor:tintColor];
    } else {
    [self _drawHalfStarShapeWithFrame:frame tintColor:tintColor];
    }
    }
    - (void)_drawAccurateStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    if (self.shouldUseImages) {
    [self _drawAccurateHalfStarImageWithFrame:frame tintColor:tintColor progress:progress];
    } else {
    [self _drawAccurateHalfStarShapeWithFrame:frame tintColor:tintColor progress:progress];
    }
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent:UIEvent ) -> Bool{
        if enabled {
            super.beginTrackingWithTouch(touch, withEvent: withEvent)
            if shouldBecomeFirstResponder && !isFirstResponder {
                becomeFirstResponder()
            }
            handleTouch(touch)
            
            return true
        } else {
            return false
        }
    }
    
    func continueTrackingWithTouch(touch :UITouch, withEvent:UIEvent) ->Bool {
        if enabled{
            super.continueTrackingWithTouch(touch, withEvent: withEvent)
            handleTouch(touch)
            return true
        } else {
            return false
        }
    }
    
    
    func endTrackingWithTouch(touch :UITouch, withEvent :UIEvent ) {
        super.endTrackingWithTouch(touch, withEvent: withEvent)
        
        if (shouldBecomeFirstResponder && self.isFirstResponder()) {
            resignFirstResponder()
        }
        handleTouch(touch)
        if !continuous {
            
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    
    func cancelTrackingWithEvent(event :UIEvent ) {
        [super cancelTrackingWithEvent:event];
        
        if (shouldBecomeFirstResponder && isFirstResponder()) {
            resignFirstResponder()
        }
    }
    
    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self]) {
    return !self.isUserInteractionEnabled;
    }
    return self.shouldBeginGestureRecognizerBlock ? self.shouldBeginGestureRecognizerBlock(gestureRecognizer) : NO;
    }
    
    func handleTouch( touch:UITouch ) {
        let cellWidth = self.bounds.size.width / maximumValue;
        let location = touch.locationInView(self)
        let value = location.x / cellWidth
        
        currentValue = ceilf(currentValue);
        
        setValue(currentValue, sendValueChangedAction: continuous)
        
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return shouldBecomeFirstResponder
    }
    
    override func intrinsicContentSize() -> CGSize {
        let height = 44.0
        return CGSizeMake(maximumValue * height + (maximumValue - 1) * spacing, height)
    }
    
}
