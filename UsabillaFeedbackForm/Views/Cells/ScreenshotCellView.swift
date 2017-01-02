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
    var screenShotView: UIImageView!
    var addIcon: UIButton!
    var editIcon: UIButton!
    var deleteIcon: UIButton!
    var addScreenshotLabel: UIButton!
    var iconContainerView: UIView!
    var heightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //View init
        screenShotView = UIImageView()
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.isUserInteractionEnabled = true
        //screenShotView.contentMode = .scaleAspectFit
        
        //Buttons
        deleteIcon = UIButton(type: UIButtonType.custom)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        deleteIcon.addTarget(self, action: #selector(ScreenshotCellView.deleteScreenshot), for: .touchUpInside)
        
        editIcon = UIButton(type: UIButtonType.custom)
        editIcon.translatesAutoresizingMaskIntoConstraints = false
        editIcon.addTarget(self, action: #selector(ScreenshotCellView.pickImage), for: .touchUpInside)
        
        addIcon = UIButton(type: UIButtonType.custom)
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        addIcon.addTarget(self, action: #selector(ScreenshotCellView.pickImage), for: .touchUpInside)
        
        
        iconContainerView = UIView()
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        iconContainerView.layer.cornerRadius = 5
        iconContainerView.layer.masksToBounds = true
        
        addScreenshotLabel = UIButton(type: UIButtonType.system)
        addScreenshotLabel.translatesAutoresizingMaskIntoConstraints = false
        addScreenshotLabel.setTitle("placeholder", for: .normal)
        addScreenshotLabel.addTarget(self, action: #selector(ScreenshotCellView.pickImage), for: .touchUpInside)
        
        rootCellContainerView.addSubview(screenShotView)
        rootCellContainerView.addSubview(addIcon)
        rootCellContainerView.addSubview(addScreenshotLabel)
        
        screenShotView.addSubview(iconContainerView)
        iconContainerView.addSubview(deleteIcon)
        iconContainerView.addSubview(editIcon)
        
        
        //Constraints
        
        addConstraintToFillContainerView(view: screenShotView, withMargin: 12)
        
        
        let editIconSize: CGFloat = 48
        let iconSpacing: CGFloat = 12
        
        
        heightConstraint = NSLayoutConstraint(item: screenShotView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: screenShotView, attribute: .width, multiplier: 1, constant: 0)
        
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.screenShotView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.screenShotView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (iconSpacing * 2 + editIconSize)).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (iconSpacing * 4 + editIconSize * 2)).isActive = true
        
        
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.deleteIcon, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: -iconSpacing * 2).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: iconSpacing).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        
        
        
        //NSLayoutConstraint(item: addIcon, attribute: .bottom, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: addIcon, attribute: .top, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .centerY, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        
        NSLayoutConstraint(item: addScreenshotLabel, attribute: .centerY, relatedBy: .equal, toItem: self.addIcon, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addScreenshotLabel, attribute: .leading, relatedBy: .equal, toItem: self.addIcon, attribute: .trailing, multiplier: 1, constant: 4).isActive = true
        //NSLayoutConstraint(item: addScreenshotLabel, attribute: .bottom, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        //NSLayoutConstraint(item: addScreenshotLabel, attribute: .top, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        
        
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
    
    override func applyCustomisations() {
        super.applyCustomisations()
        deleteIcon.setImage(Icons.imageOfArtboard(), for: UIControlState())
        editIcon.setImage(Icons.imageOfEdit(color: UIColor.white), for: UIControlState())
        addIcon.setImage(Icons.imageOfAddImage(color: UIColor.black), for: UIControlState())
        addScreenshotLabel.setTitleColor(themeConfig.titleColor, for: .normal)
        addScreenshotLabel.titleLabel?.font =  themeConfig.font.withSize(themeConfig.titleFontSize)
    }
    
    
    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        screenshotModel = item as! ScreenshotModel
        screenShotView.image = screenshotModel.screenshot
        updateUI()
    }
    
    func updateUI() {
        if screenshotModel.screenshot == nil {
            //There is no screenshot
            //screenShotPlaceholder.isHidden = false
            heightConstraint.isActive = false
            addIcon.isHidden = false
            addScreenshotLabel.isHidden = false
            screenShotView.isHidden = true
        } else {
            //screenShotPlaceholder.isHidden = true
            heightConstraint.isActive = true
            screenShotView.isHidden = false
            addIcon.isHidden = true
            addScreenshotLabel.isHidden = true
        }
        
        SwiftEventBus.post("updateScreenshotHeight", sender: nil)
    }
    
    func deleteScreenshot() {
        screenshotModel.screenshot = nil
        screenShotView.image = nil
        updateUI()
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
