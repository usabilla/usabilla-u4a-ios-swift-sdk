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
        iconView = UIButton(type: UIButtonType.custom)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.isUserInteractionEnabled = true
        fullHeight = NSLayoutConstraint(item: self.screenShotView, attribute: .height, relatedBy: .equal, toItem: self.screenShotView, attribute: .width, multiplier: 1, constant: 0)
        fullHeight.priority = 750
        fullHeight.isActive = true

        zeroHeight = NSLayoutConstraint(item: self.screenShotView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)


        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(screenShotView)
        self.contentView.addSubview(iconView)
        self.dividerLine?.isHidden = false

        iconView.addTarget(self, action: #selector(ScreenshotCellView.buttonPressed), for: .touchUpInside)

        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(ScreenshotCellView.pickImage))
        screenShotView.addGestureRecognizer(tapRecogniser)


        //NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -1).active = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -6).isActive = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.iconView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 0).active = true


        NSLayoutConstraint(item: screenShotView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -3).isActive = true
        NSLayoutConstraint(item: screenShotView, attribute: .top, relatedBy: .equal, toItem: self.dividerLine, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: screenShotView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: screenShotView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailingMargin, multiplier: 1, constant: 8).isActive = true


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

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        screenshotModel = item as! ScreenshotModel
        screenShotView.image = screenshotModel.screenshot
        updateUI()
    }

    func updateUI() {
        if screenshotModel.screenshot == nil {
            fullHeight.isActive = false
            zeroHeight.isActive = true
            iconView.setImage(StyleKit.imageOfPlus(size: CGSize(width: 24, height: 24), themeConfig: screenshotModel.themeConfig), for: UIControlState())
        } else {
            zeroHeight.isActive = false
            fullHeight.isActive = true
            iconView.setImage(StyleKit.imageOfTrash(size: CGSize(width: 24, height: 24), themeConfig: screenshotModel.themeConfig), for: UIControlState())
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

    func imagePicked(_ image: UIImage) {
        screenShotView.image = image
        screenshotModel.screenshot = image
        updateUI()
    }

//    deinit {
//        print("deinit screnshot")
//    }
}
