//
//  ScreenshotCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit
 
class ScreenshotCellView: RootCellView {
    
    var screenshotModel: ScreenshotModel!
    var screenShotView: UIImageView
    var iconView: UIButton
    var fullHeight: NSLayoutConstraint
    var zeroHeight: NSLayoutConstraint
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        screenShotView = UIImageView()
        iconView = UIButton(type: UIButtonType.Custom)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.userInteractionEnabled = true
        fullHeight = NSLayoutConstraint(item: self.screenShotView, attribute: .Height, relatedBy: .Equal, toItem: self.screenShotView, attribute: .Width, multiplier: 1, constant: 0)
        fullHeight.priority = 750
        fullHeight.active = true
        
        zeroHeight = NSLayoutConstraint(item: self.screenShotView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: 0)
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(screenShotView)
        self.contentView.addSubview(iconView)
        self.dividerLine?.hidden = false

        iconView.addTarget(self, action: #selector(ScreenshotCellView.buttonPressed), forControlEvents: .TouchUpInside)
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(ScreenshotCellView.pickImage))
        screenShotView.addGestureRecognizer(tapRecogniser)
       
        
        //NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -1).active = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -6).active = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 24).active = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.iconView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0).active = true
        //NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 0).active = true
        
        
        NSLayoutConstraint(item: screenShotView, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -3).active = true
        NSLayoutConstraint(item: screenShotView, attribute: .Top, relatedBy: .Equal, toItem: self.dividerLine, attribute: .Bottom, multiplier: 1, constant: 10).active = true
        NSLayoutConstraint(item: screenShotView, attribute: .Leading, relatedBy: .Equal, toItem: self.contentView, attribute: .Leading, multiplier: 1, constant: 8).active = true
        NSLayoutConstraint(item: screenShotView, attribute: .Trailing, relatedBy: .Equal, toItem: self.contentView, attribute: .TrailingMargin, multiplier: 1, constant: 8).active = true
        
        
        SwiftEventBus.onMainThread(self, name: "imagePicked") { result in
            self.imagePicked(result.object as! UIImage)
        }
        
        SwiftEventBus.onMainThread(self, name: "kill") { _ in
            SwiftEventBus.unregister(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        screenshotModel = item as! ScreenshotModel
        screenShotView.image = screenshotModel.screenshot
        updateUI()
        applyCustomisations()
    }
    
    func updateUI() {
        if screenshotModel.screenshot == nil {
            fullHeight.active = false
            zeroHeight.active = true
            iconView.setImage(StyleKit.imageOfPlus(size: CGSize(width: 24, height: 24), themeConfig: screenshotModel.themeConfig), forState: .Normal)
        } else {
            zeroHeight.active = false
            fullHeight.active = true
            iconView.setImage(StyleKit.imageOfTrash(size: CGSize(width: 24, height: 24), themeConfig: screenshotModel.themeConfig), forState: .Normal)
        }
        SwiftEventBus.post("updateScreenshotHeight", sender: nil)
    }
    
    func buttonPressed() {
        if screenshotModel.screenshot != nil {
            screenshotModel.screenshot = nil
            screenShotView.image = nil
            updateUI()
        } else {
            pickImage()
        }
    }
    
    func pickImage() {
        SwiftEventBus.post("pick", sender: nil)
    }
    
    func imagePicked(image: UIImage) {
        screenShotView.image = image
        screenshotModel.screenshot = image
        updateUI()
    }
    
//    deinit {
//        print("deinit screnshot")
//    }
}
