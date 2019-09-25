//
//  ParagraphComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit
class ParagraphComponentViewModel: BaseStringComponentViewModel<ParagraphFieldModel> {
    override var value: String? {
        get {
            return model.immutableParagraphValue
        }
        set {
            _ = newValue
        }
    }

    var attributedValue: NSAttributedString? {
        get {
            return model.immutableParagraphValue?.parseHTMLString(font: theme.fonts.font.withSize(theme.fonts.textSize))
        }
        set {
            _ = newValue
        }
    }

    override var cardBackGroundColor: UIColor? {
        get {
            return .clear
        }
        set {
            _ = newValue
        }
    }}
