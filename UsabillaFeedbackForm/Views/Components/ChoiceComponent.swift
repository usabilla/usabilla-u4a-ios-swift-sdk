//
//  ChoiceComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ChoiceComponent: UBComponent<ChoiceComponentViewModel>, UIPickerViewDataSource, UIPickerViewDelegate {

    var picker = UIPickerView()
    var pickerButton = UIButton(type: .custom)
    var topBorder = UIView()
    var bottomBorder = UIView()
    var pickerHeightConstraint: NSLayoutConstraint!

    override func build() {

        topBorder.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false

        addSubview(topBorder)
        addSubview(pickerButton)
        addSubview(bottomBorder)
        addSubview(picker)

        //top border
        topBorder.topAnchor.constraint(equalTo: topAnchor).withID("ChoiceComponent top border top constraint").activate()
        topBorder.trailingAnchor.constraint(equalTo: trailingAnchor).withID("ChoiceComponent top border right constraint").activate()
        topBorder.leadingAnchor.constraint(equalTo: leadingAnchor).withID("ChoiceComponent top border left constraint").activate()
        topBorder.heightAnchor.constraint(equalToConstant: 1).withID("ChoiceComponent top border heigt constraint").activate()

        // button
        pickerButton.topAnchor.constraint(equalTo: topBorder.bottomAnchor).withID("ChoiceComponent button top constraint").activate()
        pickerButton.trailingAnchor.constraint(equalTo: trailingAnchor).withID("ChoiceComponent button right constraint").activate()
        pickerButton.leadingAnchor.constraint(equalTo: leadingAnchor).withID("ChoiceComponent button left constraint").activate()

        // bottom border
        bottomBorder.topAnchor.constraint(equalTo: pickerButton.bottomAnchor).withID("ChoiceComponent bottom border top constraint").activate()
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).withID("ChoiceComponent bottom border right constraint").activate()
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).withID("ChoiceComponent bottom border left constraint").activate()
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).withID("ChoiceComponent bottom border height constraint").activate()

        // picker
        picker.dataSource = self
        picker.delegate = self

        picker.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor).withID("ChoiceComponent picker top constraint").activate()
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).withID("ChoiceComponent picker bottom constraint").activate()
        picker.trailingAnchor.constraint(equalTo: trailingAnchor).withID("ChoiceComponent picker right constraint").activate()
        picker.leadingAnchor.constraint(equalTo: leadingAnchor).withID("ChoiceComponent picker left constraint").activate()

        pickerHeightConstraint = picker.heightAnchor.constraint(equalToConstant: 0).activate()
        updateHeightConstraint()

        // configuration
        pickerButton.addTarget(self, action: #selector(ChoiceComponent.pickerButtonClicked), for: .touchUpInside)

        // customization

        let theme = viewModel.theme
        pickerButton.setTitleColor(theme.colors.text, for: .normal)
        pickerButton.titleLabel?.font = theme.fonts.font

        picker.backgroundColor = theme.colors.background
        picker.tintColor = theme.colors.text

        bottomBorder.backgroundColor = theme.colors.hint
        topBorder.backgroundColor = theme.colors.hint

        configure()
    }

    func configure() {
        if let buttonTitle = viewModel.pickerButtonTitle {
            pickerButton.setTitle(buttonTitle, for: .normal)
        }
        if let selectedIndex = viewModel.indexOfSelectedOption {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
    }

    func pickerButtonClicked() {
        viewModel.expanded = !viewModel.expanded
        updateHeightConstraint()
        SwiftEventBus.postToMainThread("updateMySize")
    }

    func updateHeightConstraint() {
        pickerHeightConstraint.constant = !viewModel.expanded ? 0 : 100
    }

    // MARK: Delegate

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = viewModel.options[row]
        viewModel.value = item.value
        pickerButton.setTitle(item.title, for: .normal)
        valueChanged()
    }

    // MARK: Datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.options.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.font = viewModel.theme.fonts.font.withSize(viewModel.theme.fonts.titleSize + 2)
            pickerLabel?.textColor = viewModel.theme.colors.text
        }

        pickerLabel?.text = viewModel.options[row].title
        //swiftlint:disable:next force_unwrapping
        return pickerLabel!
    }
}
