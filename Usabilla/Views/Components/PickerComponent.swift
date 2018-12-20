//
//  PickerComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 24/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class PickerComponent: PickerParentComponent {

    var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var pickerButton = UIButton(type: .custom)
    var borderViewHeight: NSLayoutConstraint!
    var imageViewArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.getImageFromSDKBundle(name: "picker_arrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let buttonHeight: CGFloat = 42

    override func build() {
        accessibilityIdentifier = "pickerComponent"

        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false

        addSubview(borderView)
        borderView.addSubview(pickerButton)
        borderView.addSubview(picker)
        pickerButton.addSubview(imageViewArrow)

        // borderView
        borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        borderView.topAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        borderViewHeight = borderView.heightAnchor.constraint(equalToConstant: buttonHeight).activate()

        // button
        pickerButton.topAnchor.constraint(equalTo: borderView.topAnchor).withID("PickerComponent button top constraint").activate()
        pickerButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -11).withID("PickerComponent button right constraint").activate()
        pickerButton.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 11).withID("PickerComponent button left constraint").activate()
        pickerButton.heightAnchor.constraint(equalToConstant: buttonHeight).activate()

        // arrow
        imageViewArrow.widthAnchor.constraint(equalToConstant: 10).activate()
        imageViewArrow.heightAnchor.constraint(equalToConstant: 6).activate()
        imageViewArrow.rightAnchor.constraint(equalTo: pickerButton.rightAnchor).activate()
        imageViewArrow.centerYAnchor.constraint(equalTo: pickerButton.centerYAnchor).activate()

        // picker
        picker.dataSource = self
        picker.delegate = self

        picker.topAnchor.constraint(equalTo: borderView.topAnchor, constant: buttonHeight).withID("PickerComponent picker top constraint").activate()
        picker.bottomAnchor.constraint(equalTo: borderView.bottomAnchor).withID("PickerComponent picker bottom constraint").activate()
        picker.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 8).withID("PickerComponent picker right constraint").activate()
        picker.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -8).withID("PickerComponent picker right constraint").activate()
        updatePickerStatus(isExpanded: false)

        // configuration
        pickerButton.addTarget(self, action: #selector(PickerComponent.pickerButtonClicked), for: .touchUpInside)

        customizeView()
    }

    func customizeView() {
        let theme = viewModel.theme
        pickerButton.setTitleColor(theme.colors.text, for: .normal)
        pickerButton.titleLabel?.lineBreakMode = .byTruncatingTail
        pickerButton.titleLabel?.applyFontWithDynamicTypeEnabled(font: theme.fonts.font)
        pickerButton.contentHorizontalAlignment = .left

        picker.backgroundColor = theme.colors.cardColor
        picker.tintColor = theme.colors.text

        borderView.layer.borderColor = theme.colors.hint.cgColor
        imageViewArrow.tintWithColor(color: theme.colors.text)

        let spacing: CGFloat = 10; // the amount of spacing to appear between image and title
        pickerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        pickerButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        configure()
    }

    func configure() {
        if let buttonTitle = viewModel.pickerButtonTitle {
            pickerButton.setTitle(buttonTitle, for: .normal)
        }

        guard !DeviceInfo.isIPad() else {
            picker.isHidden = true
            return
        }

        if let selectedIndex = viewModel.indexOfSelectedOption {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }

    func pickerButtonClicked() {
        if DeviceInfo.isIPad() {
            SwiftEventBus.postToMainThread("iPadPickerButtonTapped", sender: self)
            return
        }
        let isPickerExpanded = viewModel.expanded
        viewModel.expanded = !isPickerExpanded
        updatePickerStatus(isExpanded: isPickerExpanded)
        SwiftEventBus.postToMainThread("updateMySize")
    }

    func updatePickerStatus(isExpanded: Bool) {
        borderViewHeight.constant = isExpanded ? 150 : buttonHeight
        picker.isHidden = !isExpanded
        updateAccessibility(isExpanded: isExpanded)
    }

    func updateAccessibility(isExpanded: Bool) {
        picker.isAccessibilityElement = isExpanded
        self.accessibilityElements = isExpanded ? [pickerButton, picker] : [pickerButton]
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, isExpanded ? picker : nil)
    }

    // MARK: Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = viewModel.options[row]
        viewModel.value = item.value
        pickerButton.setTitle(item.title, for: .normal)
        valueChanged()
    }
}
