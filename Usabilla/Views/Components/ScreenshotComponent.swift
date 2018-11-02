//
//  ScreenshotComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotComponent: UBComponent<ScreenshotComponentViewModel> {

    var screenShotView: UIImageView!
    var addIcon: UIButton!
    var editIcon: UIButton!
    var deleteIcon: UIButton!
    var addScreenshotLabel: UIButton!
    var iconContainerView: UIView!
    var ratioConstraint: NSLayoutConstraint!
    var hasScreenShootTopConstraint: NSLayoutConstraint!
    var noScreenShootTopConstraint: NSLayoutConstraint!
    var hasScreenShootBottomConstraint: NSLayoutConstraint!
    var noScreenShootBottomConstraint: NSLayoutConstraint!

    var editIconBackGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = false
        view.backgroundColor = UIColor.blue
        view.alpha = 0.50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var deleteIconBackGroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.layer.masksToBounds = false
        view.backgroundColor = UIColor.blue
        view.alpha = 0.50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func build() {
        //View init
        screenShotView = UIImageView()
        screenShotView.translatesAutoresizingMaskIntoConstraints = false
        screenShotView.isUserInteractionEnabled = true
        screenShotView.contentMode = .scaleAspectFit
        screenShotView.layer.cornerRadius = 5
        screenShotView.layer.masksToBounds = true
        screenShotView.layer.borderWidth = 1

        iconContainerView = UIView()
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.layer.cornerRadius = 5
        iconContainerView.layer.masksToBounds = true

        //Buttons
        deleteIcon = UIButton(type: UIButtonType.custom)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        deleteIcon.addTarget(self, action: #selector(ScreenshotComponent.deleteScreenshot), for: .touchUpInside)
        deleteIcon.isAccessibilityElement = true
        deleteIcon.accessibilityLabel = "\(LocalisationHandler.getLocalisedStringForKey("usa_delete_screenshot"))"

        editIcon = UIButton(type: UIButtonType.custom)
        editIcon.translatesAutoresizingMaskIntoConstraints = false
        editIcon.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)
        editIcon.isAccessibilityElement = true
        editIcon.accessibilityLabel = "\(LocalisationHandler.getLocalisedStringForKey("usa_edit_screenshot"))"

        addIcon = UIButton(type: UIButtonType.custom)
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        addIcon.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)
        addIcon.isAccessibilityElement = false

        addScreenshotLabel = UIButton(type: UIButtonType.system)
        addScreenshotLabel.translatesAutoresizingMaskIntoConstraints = false
        addScreenshotLabel.contentHorizontalAlignment = .left
        addScreenshotLabel.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)
        addScreenshotLabel.setTitle(viewModel.screenshotPlaceHolder, for: .normal)

        addSubview(screenShotView)
        addSubview(addIcon)
        addSubview(addScreenshotLabel)

        screenShotView.addSubview(iconContainerView)

//        editIconBackGroundView.addSubview(editIcon)
//        deleteIconBackGroundView.addSubview(deleteIcon)

        iconContainerView.addSubview(editIconBackGroundView)
        iconContainerView.addSubview(deleteIconBackGroundView)
        iconContainerView.addSubview(editIcon)
        iconContainerView.addSubview(deleteIcon)

        addConstraints()

        SwiftEventBus.onMainThread(self, name: "imagePicked") { result in
            if let image = result?.object as? UIImage {
                self.imagePicked(image)
            }
        }

        SwiftEventBus.onMainThread(self, name: "kill") { _ in
            SwiftEventBus.unregister(self)
        }
        applyCustomisations()

        setImage(image: viewModel.value, updateUI: false, updateModel: false)
    }

    func addConstraints() {
        let editIconSize: CGFloat = 48

        screenShotView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).activate()
        screenShotView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).activate()
        hasScreenShootTopConstraint = screenShotView.topAnchor.constraint(equalTo: topAnchor, constant: -4)
        noScreenShootTopConstraint  = screenShotView.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        hasScreenShootBottomConstraint = screenShotView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        noScreenShootBottomConstraint  = screenShotView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)

        iconContainerView.trailingAnchor.constraint(equalTo: screenShotView.trailingAnchor, constant: -16).isActive = true
        iconContainerView.topAnchor.constraint(equalTo: screenShotView.topAnchor, constant: 17).isActive = true
        iconContainerView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iconContainerView.widthAnchor.constraint(equalToConstant: 16 + 64 * 2).isActive = true

        deleteIconBackGroundView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 0).isActive = true
        deleteIconBackGroundView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        deleteIconBackGroundView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        deleteIconBackGroundView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true

        deleteIcon.centerYAnchor.constraint(equalTo: deleteIconBackGroundView.centerYAnchor).isActive = true
        deleteIcon.centerXAnchor.constraint(equalTo: deleteIconBackGroundView.centerXAnchor).isActive = true
        deleteIcon.heightAnchor.constraint(equalToConstant: editIconSize).isActive = true
        deleteIcon.widthAnchor.constraint(equalToConstant: editIconSize).isActive = true

        editIconBackGroundView.trailingAnchor.constraint(equalTo: deleteIconBackGroundView.leadingAnchor, constant: -16).isActive = true
        editIconBackGroundView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        editIconBackGroundView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        editIconBackGroundView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor).isActive = true

        editIcon.centerYAnchor.constraint(equalTo: editIconBackGroundView.centerYAnchor).isActive = true
        editIcon.centerXAnchor.constraint(equalTo: editIconBackGroundView.centerXAnchor).isActive = true
        editIcon.widthAnchor.constraint(equalToConstant: editIconSize).isActive = true
        editIcon.heightAnchor.constraint(equalToConstant: editIconSize).isActive = true

        addIcon.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        addScreenshotLabel.centerYAnchor.constraint(equalTo: addIcon.centerYAnchor).isActive = true
        addScreenshotLabel.leadingAnchor.constraint(equalTo: addIcon.trailingAnchor, constant: 16).isActive = true
        addScreenshotLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).activate()
    }

    func setupRatioConstraint(imageSize: CGSize?) {
        ratioConstraint?.isActive = false
        if let size = imageSize {
            let ratio = size.width / size.height
            ratioConstraint = screenShotView.widthAnchor.constraint(equalTo: screenShotView.heightAnchor, multiplier: ratio)
            ratioConstraint.priority = 999
            ratioConstraint.isActive = true
        }
    }

    func applyCustomisations() {
        let theme = viewModel.theme
        deleteIconBackGroundView.backgroundColor = theme.colors.accent.withAlphaComponent(0.5)
        deleteIcon.setImage(Icons.imageOfArtboard(color: theme.colors.textOnAccent), for: UIControlState())
        editIconBackGroundView.backgroundColor = theme.colors.accent.withAlphaComponent(0.5)
        editIcon.setImage(Icons.imageOfEdit(color: theme.colors.textOnAccent), for: UIControlState())
        addIcon.setImage(Icons.imageOfAddImage(color: theme.colors.accent), for: UIControlState())
        addScreenshotLabel.setTitleColor(theme.colors.title, for: .normal)
        addScreenshotLabel.titleLabel?.applyFontWithDynamicTypeEnabled(font: theme.fonts.font)
        addScreenshotLabel.titleLabel?.lineBreakMode = .byTruncatingTail
        screenShotView.layer.borderColor = theme.colors.hint.cgColor
    }

    func updateUI() {
        let hasScreenShot = viewModel.value != nil
        addIcon.isHidden = hasScreenShot
        addScreenshotLabel.isHidden = hasScreenShot
        screenShotView.isHidden = !hasScreenShot
        self.accessibilityElements = hasScreenShot ? [editIcon, deleteIcon] : [addScreenshotLabel]
        if hasScreenShot {
            noScreenShootTopConstraint.isActive = false
            hasScreenShootTopConstraint.isActive = true
            noScreenShootBottomConstraint.isActive = false
            hasScreenShootBottomConstraint.isActive = true
        } else {
            hasScreenShootTopConstraint.isActive = false
            noScreenShootTopConstraint.isActive = true
            hasScreenShootBottomConstraint.isActive = false
            noScreenShootBottomConstraint.isActive = true
        }
    }

    func deleteScreenshot() {
        setImage(image: nil)
    }

    func pickImage() {
        SwiftEventBus.post("pick", sender: nil)
    }

    func setImage(image: UIImage?, updateUI: Bool = true, updateModel: Bool = true) {
        screenShotView.image = image

        if updateModel {
            viewModel.value = image
            valueChanged()
        }

        setupRatioConstraint(imageSize: image?.size)
        self.updateUI()

        if updateUI {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self)
            SwiftEventBus.post("updateMySize")
        }
    }

    func imagePicked(_ image: UIImage) {
        setImage(image: image)
    }
}
