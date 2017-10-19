//
//  PickerIPadComponent.swift
//  Usabilla
//
//  Created by Adil Bougamza on 19/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class PickerIPadComponent: PickerParentComponent {
    weak var delegate: PickerComponent!

    override func build() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(picker)

        // picker
        picker.dataSource = self
        picker.delegate = self

        picker.topAnchor.constraint(equalTo: topAnchor).withID("PickerComponent picker top constraint").activate()
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).withID("PickerComponent picker bottom constraint").activate()
        picker.leftAnchor.constraint(equalTo: leftAnchor, constant: -16).withID("PickerComponent picker right constraint").activate()
        picker.rightAnchor.constraint(equalTo: rightAnchor, constant: 16).withID("PickerComponent picker right constraint").activate()

        customizeView()
    }

    func customizeView() {
        let theme = viewModel.theme

        picker.backgroundColor = theme.colors.background
        picker.tintColor = theme.colors.text

        configure()
    }

    func configure() {
        guard viewModel.value != nil else {
            return
        }
        if let selectedIndex = viewModel.indexOfSelectedOption {
            picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = viewModel.options[row]
        viewModel.value = item.value
        delegate.pickerButton.setTitle(item.title, for: .normal)
        valueChanged()
    }
}
