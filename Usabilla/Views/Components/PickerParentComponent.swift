//
//  PickerParentComponent.swift
//  Usabilla
//
//  Created by Adil Bougamza on 19/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class PickerParentComponent: UBComponent<PickerComponentViewModel>, UIPickerViewDataSource, UIPickerViewDelegate {
    var picker = UIPickerView()

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

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 33.0
    }
}
