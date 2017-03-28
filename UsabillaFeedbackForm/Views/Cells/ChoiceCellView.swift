//
//  ChoiceCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ChoiceCellView: RootCellView {

    var choiceModel: ChoiceFieldModel?
    let picker = UIPickerView()
    let pickerButton = UIButton()
    let topBorder = UIView()
    let bottomBorder = UIView()
    let pickerHeightConstraint: NSLayoutConstraint

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        pickerHeightConstraint = picker.heightAnchor.constraint(equalToConstant: 0)
        pickerHeightConstraint.isActive = true

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        rootCellContainerView.addSubview(topBorder)
        rootCellContainerView.addSubview(pickerButton)
        rootCellContainerView.addSubview(bottomBorder)
        rootCellContainerView.addSubview(picker)

        //top border
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.topAnchor.constraint(equalTo: rootCellContainerView.topAnchor).isActive = true
        topBorder.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).isActive = true
        topBorder.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true
        topBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // button
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.topAnchor.constraint(equalTo: topBorder.bottomAnchor).isActive = true
        pickerButton.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).isActive = true
        pickerButton.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true

        pickerButton.addTarget(self, action: #selector(ChoiceCellView.pickerButtonClicked), for: .touchUpInside)

        // bottom border
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.topAnchor.constraint(equalTo: pickerButton.bottomAnchor).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true


        // picker
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.translatesAutoresizingMaskIntoConstraints = false

        picker.topAnchor.constraint(equalTo: bottomBorder.bottomAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: rootCellContainerView.bottomAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).isActive = true
        picker.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).isActive = true


    }

    override func applyCustomisations() {
        super.applyCustomisations()
        guard let theme = choiceModel?.themeConfig else {
            return
        }
        pickerButton.setTitleColor(theme.textColor, for: .normal)
        pickerButton.titleLabel?.font = theme.font.withSize(theme.titleFontSize)

        picker.backgroundColor = theme.backgroundColor
        picker.tintColor = theme.textColor
        bottomBorder.backgroundColor = theme.hintColor
        topBorder.backgroundColor = theme.hintColor


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func pickerButtonClicked() {
        if let choiceModel = choiceModel {
            choiceModel.expanded = !choiceModel.expanded
        }
        SwiftEventBus.postToMainThread("reloadCellForModel", userInfo: ["model": choiceModel as Any])
    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)

        choiceModel = item as? ChoiceFieldModel
        guard let model = choiceModel else {
            return
        }
        pickerHeightConstraint.isActive = !model.expanded
        if model.fieldValue.isEmpty {
            model.fieldValue = [model.options[0].value]
            pickerButton.setTitle(model.options[0].title, for: .normal)
            picker.selectRow(0, inComponent: 0, animated: true)
        } else {
            for (index, option) in model.options.enumerated() {
                if option.value == model.fieldValue[0] {
                    pickerButton.setTitle(option.title, for: .normal)
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }

        if model.options.count < 5 {
            let a = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
            a.priority = 750
            a.isActive = true
        }

    }

}

extension ChoiceCellView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choiceModel?.options.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel

        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.font = themeConfig.font.withSize(themeConfig.titleFontSize + 2)
            pickerLabel?.textColor = themeConfig.textColor
        }

        pickerLabel?.text = choiceModel?.options[row].title
        return pickerLabel!
    }

}

extension ChoiceCellView: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let item = choiceModel?.options[row] {
            choiceModel?.fieldValue = [item.value]
            pickerButton.setTitle(item.title, for: .normal)
            loggingPrint("picked \(item.value)")
        }
    }
}
