//
//  ColorPickerViewDelegate.swift
//  Usabilla
//
//  Created by Hitesh Jain on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ColorPickerViewDelegate: class {

    func colorPockerView(_ colorPickerView: ColorPickerView, didSelectColor color: UIColor)

    @objc optional func colorPickerView(_ colorPickerView: ColorPickerView, didDeselectItemAt indexPath: IndexPath)

}
