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
    var ratioConstraint: NSLayoutConstraint!

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
        let editIconSize: CGFloat = 48
        let iconSpacing: CGFloat = 12

        addConstraintToFillContainerView(view: screenShotView, withMargin: 12)

        iconContainerView.trailingAnchor.constraint(equalTo: screenShotView.trailingAnchor, constant: -16).isActive = true
        iconContainerView.topAnchor.constraint(equalTo: screenShotView.topAnchor, constant: 16).isActive = true
        iconContainerView.heightAnchor.constraint(equalToConstant: iconSpacing * 2 + editIconSize).isActive = true
        iconContainerView.widthAnchor.constraint(equalToConstant: iconSpacing * 5 + editIconSize * 2).isActive = true

        deleteIcon.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -iconSpacing).isActive = true
        deleteIcon.heightAnchor.constraint(equalToConstant: editIconSize).isActive = true
        deleteIcon.widthAnchor.constraint(equalToConstant: editIconSize).isActive = true
        deleteIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true

        editIcon.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: iconSpacing).isActive = true
        editIcon.widthAnchor.constraint(equalToConstant: editIconSize).isActive = true
        editIcon.heightAnchor.constraint(equalToConstant: editIconSize).isActive = true
        editIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true

        addIcon.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true
        addIcon.centerYAnchor.constraint(equalTo: rootCellContainerView.centerYAnchor).isActive = true
        addIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        addScreenshotLabel.centerYAnchor.constraint(equalTo: addIcon.centerYAnchor).isActive = true
        addScreenshotLabel.leadingAnchor.constraint(equalTo: addIcon.trailingAnchor, constant: 4).isActive = true

        addScreenshotLine.topAnchor.constraint(equalTo: addScreenshotLabel.bottomAnchor, constant: 3).isActive = true
        addScreenshotLine.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true
        addScreenshotLine.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).isActive = true
        addScreenshotLine.heightAnchor.constraint(equalToConstant: 1).isActive = true

        SwiftEventBus.onMainThread(self, name: "imagePicked") { result in
            if let image = result.object as? UIImage {
                self.imagePicked(image)
            }
        }

        SwiftEventBus.onMainThread(self, name: "kill") { _ in
            SwiftEventBus.unregister(self)
        }


    }

    func setupRatioConstraint(imageSize: CGSize?) {
        ratioConstraint?.isActive = false
        if let s = imageSize {
            let ratio = s.width / s.height
            ratioConstraint = screenShotView.widthAnchor.constraint(equalTo: screenShotView.heightAnchor, multiplier: ratio)
            ratioConstraint.priority = 999
            ratioConstraint.isActive = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func applyCustomisations() {
        super.applyCustomisations()
        deleteIcon.setImage(Icons.imageOfArtboard(color: UIColor.white), for: UIControlState())
        editIcon.setImage(Icons.imageOfEdit(color: UIColor.white), for: UIControlState())
        addIcon.setImage(Icons.imageOfAddImage2(color: themeConfig.textColor), for: UIControlState())
        addScreenshotLabel.setTitleColor(themeConfig.titleColor, for: .normal)
        addScreenshotLabel.titleLabel?.font = themeConfig.font.withSize(themeConfig.titleFontSize)
        addScreenshotLine.backgroundColor = themeConfig.hintColor
        screenShotView.layer.borderColor = themeConfig.hintColor.cgColor

    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? ScreenshotModel else {
            return
        }
        screenshotModel = item
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
        setupRatioConstraint(imageSize: image?.size)
    }

    func imagePicked(_ image: UIImage) {
        setImage(image: image)
        updateUI()
    }

}
