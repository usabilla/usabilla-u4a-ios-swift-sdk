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
    let screenShotView: UIImageView
    var addIcon: UIButton!
    var editIcon: UIButton!
    var deleteIcon: UIButton!
    var addScreenshotLabel: UIButton!
    let iconContainerView: UIView
    let addScreenshotLine: UIView
    var heightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        //View init
        screenShotView = UIImageView()
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.isUserInteractionEnabled = true
        screenShotView.contentMode = .scaleAspectFit
        screenShotView.layer.cornerRadius = 5
        screenShotView.layer.masksToBounds = true
        screenShotView.layer.borderWidth = 2

        addScreenshotLine = UIView()
        addScreenshotLine.translatesAutoresizingMaskIntoConstraints = false

        iconContainerView = UIView()
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        iconContainerView.layer.cornerRadius = 5
        iconContainerView.layer.masksToBounds = true

        super.init(style: style, reuseIdentifier: reuseIdentifier)

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



        addScreenshotLabel = UIButton(type: UIButtonType.system)
        addScreenshotLabel.translatesAutoresizingMaskIntoConstraints = false
        addScreenshotLabel.setTitle("placeholder", for: .normal)
        addScreenshotLabel.addTarget(self, action: #selector(ScreenshotCellView.pickImage), for: .touchUpInside)


        rootCellContainerView.addSubview(screenShotView)
        rootCellContainerView.addSubview(addIcon)
        rootCellContainerView.addSubview(addScreenshotLabel)
        rootCellContainerView.addSubview(addScreenshotLine)

        screenShotView.addSubview(iconContainerView)
        iconContainerView.addSubview(deleteIcon)
        iconContainerView.addSubview(editIcon)

        //Constraints

        addConstraintToFillContainerView(view: screenShotView, withMargin: 12)

        let editIconSize: CGFloat = 48
        let iconSpacing: CGFloat = 12

        heightConstraint = screenShotView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.screenShotView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.screenShotView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (iconSpacing * 2 + editIconSize)).isActive = true
        NSLayoutConstraint(item: iconContainerView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (iconSpacing * 5 + editIconSize * 2)).isActive = true


        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -iconSpacing).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        NSLayoutConstraint(item: deleteIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true

        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.deleteIcon, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: -iconSpacing * 3).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.iconContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: iconSpacing).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true
        NSLayoutConstraint(item: editIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: editIconSize).isActive = true

        NSLayoutConstraint(item: addIcon, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .centerY, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: addIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25).isActive = true

        NSLayoutConstraint(item: addScreenshotLabel, attribute: .centerY, relatedBy: .equal, toItem: self.addIcon, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addScreenshotLabel, attribute: .leading, relatedBy: .equal, toItem: self.addIcon, attribute: .trailing, multiplier: 1, constant: 4).isActive = true

        NSLayoutConstraint(item: addScreenshotLine, attribute: .top, relatedBy: .equal, toItem: self.addScreenshotLabel, attribute: .bottom, multiplier: 1, constant: 3).isActive = true
        NSLayoutConstraint(item: addScreenshotLine, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addScreenshotLine, attribute: .trailing, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addScreenshotLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1).isActive = true

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
        deleteIcon.setImage(Icons.imageOfArtboard(color: UIColor.white), for: UIControlState())
        editIcon.setImage(Icons.imageOfEdit(color: UIColor.white), for: UIControlState())
        addIcon.setImage(Icons.imageOfAddImage(color: UIColor.black), for: UIControlState())
        addScreenshotLabel.setTitleColor(themeConfig.titleColor, for: .normal)
        addScreenshotLabel.titleLabel?.font = themeConfig.font.withSize(themeConfig.titleFontSize)
        addScreenshotLine.backgroundColor = themeConfig.hintColor
        screenShotView.layer.borderColor = themeConfig.hintColor.cgColor

    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        screenshotModel = item as! ScreenshotModel
        setImage(image: screenshotModel.screenshot)
        updateUI()
    }

    func updateUI() {
        if screenshotModel.screenshot == nil {
            addIcon.isHidden = false
            addScreenshotLabel.isHidden = false
            addScreenshotLine.isHidden = false
            screenShotView.isHidden = true
        } else {
            screenShotView.isHidden = false
            addIcon.isHidden = true
            addScreenshotLabel.isHidden = true
            addScreenshotLine.isHidden = true
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

    func setImage(image: UIImage?) {
        screenShotView.image = image
        screenshotModel.screenshot = image

        if let image = image {
            let fixedWidth = self.frame.width
            var ratio: CGFloat = 1
            if fixedWidth < image.size.width {
                ratio = fixedWidth / image.size.width
            } else {
                ratio = image.size.width / fixedWidth
            }

            heightConstraint.constant = image.size.height * ratio
        } else {
            heightConstraint.constant = 0
        }
    }

    func imagePicked(_ image: UIImage) {
        setImage(image: image)
        updateUI()
    }

}
