//
//  ColorPickerViewDelegateFlowLayout.swift
//  Usabilla
//
//  Created by Hitesh Jain on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

@objc protocol ColorPickerViewDelegateFlowLayout: class {

    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, sizeForItemAt indexPath: IndexPath) -> CGSize

    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, minimumLineSpacingForSectionAt section: Int) -> CGFloat

    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat

    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, insetForSectionAt section: Int) -> UIEdgeInsets
}
