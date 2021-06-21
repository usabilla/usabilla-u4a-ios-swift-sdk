//
//  UBEndPageViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 03/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit
class UBEndPageViewModel {

    private var model: UBEndPageModel
    private(set) var theme: UsabillaTheme

    var formRating: Int = 0

    var thankyouText: String?
    var thankyouFont: UIFont?
    var thankyouColor: UIColor?

    var headerText: String?
    var headerFont: UIFont?
    var headerColor: UIColor?
    
    var headerAttributedText: NSAttributedString?
    var thankyouAttributedText: NSAttributedString?

    fileprivate func setHeaderText(_ field: BaseFieldModel) {
        if  let aField = field as? HeaderFieldModel {
            headerText = aField.fieldValue
            headerFont = theme.fonts.boldFont
            headerColor = theme.colors.title
        } else if let aField = field as? ParagraphFieldModel {
            if aField.isHTML {
                headerAttributedText = aField.immutableParagraphValue?.parseHTMLString(font: theme.fonts.font.withSize(theme.fonts.textSize))
            } else {
                headerText = aField.fieldValue
            }
            headerFont = theme.fonts.font
            headerColor = theme.colors.text
        }
    }

    fileprivate func setThankyouText(_ field: BaseFieldModel) {
        if  let aField = field as? HeaderFieldModel {
            thankyouText = aField.fieldValue
            thankyouFont = theme.fonts.boldFont
            thankyouColor = theme.colors.title
        } else if let aField = field as? ParagraphFieldModel {
            if aField.isHTML {
                thankyouAttributedText = aField.immutableParagraphValue?.parseHTMLString(font: theme.fonts.font.withSize(theme.fonts.textSize))
            } else {
                thankyouText = aField.fieldValue
            }
            thankyouFont = theme.fonts.font
            thankyouColor = theme.colors.text
        }
    }

    init(model: UBEndPageModel, theme: UsabillaTheme) {
        self.model = model
        self.theme = theme
        /*
            Endpage can hold 2 types of elements, Header and paragraph
            The first object shown is HeaderText, the second is ThankyouText
            Set the to properties for both depeding on type in the formmodel
         */

        // If only one field we use the ThankYouText, as it could be a campaing, but format it right
        // the toast, takes no formating properties
        if model.fields.count == 1 {
            setThankyouText(model.fields[0])
            return
        }

        // we only have the abilty to show 2 fields on the endpage, so discard fields more than 2.....
        if model.fields.count > 1 {
            setHeaderText(model.fields[0])
            setThankyouText(model.fields[1])
        }
    }
}
