//
//  ChoiceComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ChoiceComponent: UBComponent<ChoiceComponentViewModel>, UIPickerViewDataSource, UIPickerViewDelegate {

    var picker = UIPickerView()
    var pickerButton = UIButton()
    var topBorder = UIView()
    var bottomBorder = UIView()
    var pickerDismissConstraint: NSLayoutConstraint!

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
        topBorder.topAnchor.constraint(equalTo: topAnchor).withId("ChoiceComponent top border top constraint").activate()
        topBorder.trailingAnchor.constraint(equalTo: trailingAnchor).withId("ChoiceComponent top border right constraint").activate()
        topBorder.leadingAnchor.constraint(equalTo: leadingAnchor).withId("ChoiceComponent top border left constraint").activate()
        topBorder.heightAnchor.constraint(equalToConstant: 1).withId("ChoiceComponent top border heigt constraint").activate()

        // button
        pickerButton.topAnchor.constraint(equalTo: topBorder.bottomAnchor).withId("ChoiceComponent button top constraint").activate()
        pickerButton.trailingAnchor.constraint(equalTo: trailingAnchor).withId("ChoiceComponent button right constraint").activate()
        pickerButton.leadingAnchor.constraint(equalTo: leadingAnchor).withId("ChoiceComponent button left constraint").activate()

        pickerButton.setTitle("hello", for: .normal)
        // bottom border
        bottomBorder.topAnchor.constraint(equalTo: pickerButton.bottomAnchor).withId("ChoiceComponent bottom border top constraint").activate()
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor).withId("ChoiceComponent bottom border right constraint").activate()
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor).withId("ChoiceComponent bottom border left constraint").activate()
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).withId("ChoiceComponent bottom border height constraint").activate()

        // picker
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true

        picker.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor).withId("ChoiceComponent picker top constraint").activate()
        picker.bottomAnchor.constraint(equalTo: bottomAnchor).withId("ChoiceComponent picker bottom constraint").activate()
        picker.trailingAnchor.constraint(equalTo: trailingAnchor).withId("ChoiceComponent picker right constraint").activate()
        picker.leadingAnchor.constraint(equalTo: leadingAnchor).withId("ChoiceComponent picker left constraint").activate()

        pickerDismissConstraint = picker.heightAnchor.constraint(equalToConstant: 0)

        // configuration
        pickerDismissConstraint.isActive = !viewModel.expanded
        picker.isHidden = false
        pickerButton.addTarget(self, action: #selector(ChoiceComponent.pickerButtonClicked), for: .touchUpInside)

        // customization

        let theme = viewModel.theme
        pickerButton.setTitleColor(theme.textColor, for: .normal)
        pickerButton.titleLabel?.font = theme.font.withSize(theme.titleFontSize)

        picker.backgroundColor = theme.backgroundColor
        picker.tintColor = theme.textColor

        bottomBorder.backgroundColor = theme.hintColor
        topBorder.backgroundColor = theme.hintColor

        configure()
    }

    func configure() {

        guard viewModel.options.count > 0 else {
            return
        }
        guard let tmpValue = viewModel.value else {
            return
        }

        if tmpValue.isEmpty {
            pickerButton.setTitle(viewModel.options[0].title, for: .normal)
            picker.selectRow(0, inComponent: 0, animated: true)
        } else {
            for (index, option) in viewModel.options.enumerated() where option.value == tmpValue {
                pickerButton.setTitle(option.title, for: .normal)
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }

        if viewModel.options.count < 5 {
            picker.heightAnchor.constraint(equalToConstant: 100).prioritize(750).activate()
        }

    }

    func pickerButtonClicked() {
        viewModel.expanded = !viewModel.expanded
        pickerDismissConstraint.isActive = !viewModel.expanded
        SwiftEventBus.postToMainThread("updateMySize")
    }

    // Delegate

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = viewModel.options[row]
        viewModel.value = item.value
        pickerButton.setTitle(item.title, for: .normal)
        valueChanged()
    }

    // Datasource

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
            pickerLabel?.font = viewModel.theme.font.withSize(viewModel.theme.titleFontSize + 2)
            pickerLabel?.textColor = viewModel.theme.textColor
        }

        pickerLabel?.text = viewModel.options[row].title
        return pickerLabel!
    }
}
