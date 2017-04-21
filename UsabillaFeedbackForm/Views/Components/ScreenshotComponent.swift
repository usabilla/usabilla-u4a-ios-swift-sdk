//
//  ScreenshotComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ScreenshotComponent: UBComponent<ScreenshotComponentViewModel> {

    var screenShotView: UIImageView!
    var addIcon: UIButton!
    var editIcon: UIButton!
    var deleteIcon: UIButton!
    var addScreenshotLabel: UIButton!
    var iconContainerView: UIView!
    var addScreenshotLine: UIView!
    var ratioConstraint: NSLayoutConstraint!

    override func build() {
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

        //Buttons
        deleteIcon = UIButton(type: UIButtonType.custom)
        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        deleteIcon.addTarget(self, action: #selector(ScreenshotComponent.deleteScreenshot), for: .touchUpInside)

        editIcon = UIButton(type: UIButtonType.custom)
        editIcon.translatesAutoresizingMaskIntoConstraints = false
        editIcon.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)

        addIcon = UIButton(type: UIButtonType.custom)
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        addIcon.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)
        addScreenshotLabel = UIButton(type: UIButtonType.system)
        addScreenshotLabel.translatesAutoresizingMaskIntoConstraints = false
        addScreenshotLabel.addTarget(self, action: #selector(ScreenshotComponent.pickImage), for: .touchUpInside)

        addSubview(screenShotView)
        addSubview(addIcon)
        addSubview(addScreenshotLabel)
        addSubview(addScreenshotLine)

        screenShotView.addSubview(iconContainerView)
        iconContainerView.addSubview(deleteIcon)
        iconContainerView.addSubview(editIcon)

        makeConstraints()

        SwiftEventBus.onMainThread(self, name: "imagePicked") { result in
            if let image = result.object as? UIImage {
                self.imagePicked(image)
            }
        }

        SwiftEventBus.onMainThread(self, name: "kill") { _ in
            SwiftEventBus.unregister(self)
        }
        applyCustomisations()

        setImage(image: viewModel.value, updateUI: false, updateModel: false)
    }

    func makeConstraints() {
        let editIconSize: CGFloat = 48
        let iconSpacing: CGFloat = 12

        screenShotView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).activate()
        screenShotView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).activate()
        screenShotView.topAnchor.constraint(equalTo: topAnchor, constant: 12).activate()
        screenShotView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).activate()

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

        addIcon.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        addIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true

        addScreenshotLabel.centerYAnchor.constraint(equalTo: addIcon.centerYAnchor).isActive = true
        addScreenshotLabel.leadingAnchor.constraint(equalTo: addIcon.trailingAnchor, constant: 4).isActive = true

        addScreenshotLine.topAnchor.constraint(equalTo: addScreenshotLabel.bottomAnchor, constant: 3).isActive = true
        addScreenshotLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        addScreenshotLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addScreenshotLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
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

    func applyCustomisations() {
        let theme = viewModel.theme
        deleteIcon.setImage(Icons.imageOfArtboard(color: UIColor.white), for: UIControlState())
        editIcon.setImage(Icons.imageOfEdit(color: UIColor.white), for: UIControlState())
        addIcon.setImage(Icons.imageOfAddImage(color: theme.textColor), for: UIControlState())
        addScreenshotLabel.setTitleColor(theme.titleColor, for: .normal)
        addScreenshotLabel.titleLabel?.font = theme.boldFont
        addScreenshotLine.backgroundColor = theme.hintColor
        screenShotView.layer.borderColor = theme.hintColor.cgColor
    }

    func updateUI() {
        let hasScreeenShot = viewModel.value != nil
        addIcon.isHidden = hasScreeenShot
        addScreenshotLabel.isHidden = hasScreeenShot
        addScreenshotLine.isHidden = hasScreeenShot
        screenShotView.isHidden = !hasScreeenShot
    }

    func deleteScreenshot() {
        setImage(image: nil)
    }

    func pickImage() {
        SwiftEventBus.post("pick", sender: nil)
    }

    func setImage(image: UIImage?, updateUI: Bool = true, updateModel: Bool = true) {
        screenShotView.image = image

        if updateModel == true {
            viewModel.value = image
            valueChanged()
        }

        setupRatioConstraint(imageSize: image?.size)
        self.updateUI()

        if updateUI == true {
            SwiftEventBus.post("updateMySize")
        }
    }

    func imagePicked(_ image: UIImage) {
        setImage(image: image)
    }
}
