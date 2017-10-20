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

    var pickerButton = UIButton(type: .custom)
    var topBorder = UIView()
    var bottomBorder = UIView()
    var pickerHeightConstraint: NSLayoutConstraint!
    var imageViewArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.getImageFromSDKBundle(name: "picker_arrow")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func build() {

        topBorder.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pickerButton)
        addSubview(topBorder)
        addSubview(picker)
        addSubview(bottomBorder)
        pickerButton.addSubview(imageViewArrow)

        // button
        pickerButton.topAnchor.constraint(equalTo: topAnchor).withID("PickerComponent button top constraint").activate()
        pickerButton.trailingAnchor.constraint(equalTo: trailingAnchor).withID("PickerComponent button right constraint").activate()
        pickerButton.leadingAnchor.constraint(equalTo: leadingAnchor).withID("PickerComponent button left constraint").activate()
        pickerButton.heightAnchor.constraint(equalToConstant: 42).activate()

        // arrow
        imageViewArrow.widthAnchor.constraint(equalToConstant: 10).activate()
        imageViewArrow.heightAnchor.constraint(equalToConstant: 6).activate()
        imageViewArrow.rightAnchor.constraint(equalTo: pickerButton.rightAnchor).activate()
        imageViewArrow.centerYAnchor.constraint(equalTo: pickerButton.centerYAnchor).activate()

        //top border
        topBorder.topAnchor.constraint(equalTo: pickerButton.bottomAnchor).withID("PickerComponent bottom border top constraint").activate()
        topBorder.trailingAnchor.constraint(equalTo: trailingAnchor).withID("PickerComponent bottom border right constraint").activate()
        topBorder.leadingAnchor.constraint(equalTo: leadingAnchor).withID("PickerComponent bottom border left constraint").activate()
        topBorder.heightAnchor.constraint(equalToConstant: 1).withID("PickerComponent bottom border height constraint").activate()

        // picker
        picker.dataSource = self
        picker.delegate = self

        picker.topAnchor.constraint(equalTo: topBorder.bottomAnchor).withID("PickerComponent picker top constraint").activate()
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).withID("PickerComponent picker bottom constraint").activate()
        picker.leftAnchor.constraint(equalTo: leftAnchor, constant: -16).withID("PickerComponent picker right constraint").activate()
        picker.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).withID("PickerComponent picker right constraint").activate()

        // bottom border
        bottomBorder.bottomAnchor.constraint(equalTo: picker.bottomAnchor).activate()
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).activate()

        pickerHeightConstraint = picker.heightAnchor.constraint(equalToConstant: 0).activate()
        updateHeightConstraint()

        // configuration
        pickerButton.addTarget(self, action: #selector(PickerComponent.pickerButtonClicked), for: .touchUpInside)

        customizeView()
    }

    func customizeView() {
        let theme = viewModel.theme
        pickerButton.setTitleColor(theme.colors.text, for: .normal)
        pickerButton.titleLabel?.font = theme.fonts.font
        pickerButton.contentHorizontalAlignment = .left

        picker.backgroundColor = theme.colors.background
        picker.tintColor = theme.colors.text

        bottomBorder.backgroundColor = theme.colors.hint
        topBorder.backgroundColor = theme.colors.hint

        imageViewArrow.tintWithColor(color: theme.colors.text)

        configure()
    }

    func configure() {
        bottomBorder.isHidden = true

        guard !DeviceInfo.isIPad() else {
            picker.isHidden = true
            return
        }
        if let buttonTitle = viewModel.pickerButtonTitle {
            pickerButton.setTitle(buttonTitle, for: .normal)
        }
        if let selectedIndex = viewModel.indexOfSelectedOption {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }

    func pickerButtonClicked() {
        if DeviceInfo.isIPad() {
            SwiftEventBus.postToMainThread("pickerButtonTapped", sender: self)
            return
        }
        viewModel.expanded = !viewModel.expanded
        bottomBorder.isHidden = !viewModel.expanded
        updateHeightConstraint()
        SwiftEventBus.postToMainThread("updateMySize")
    }

    func updateHeightConstraint() {
        pickerHeightConstraint.constant = !viewModel.expanded ? 0 : 150
    }

    // MARK: Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = viewModel.options[row]
        viewModel.value = item.value
        pickerButton.setTitle(item.title, for: .normal)
        valueChanged()
    }
}
