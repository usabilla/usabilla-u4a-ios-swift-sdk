//
//  CheckBoxComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 15/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CheckBoxComponentViewModel: BaseOptionsComponentViewModel<CheckboxFieldModel> {

    override var accessibilityExtraInfo: String? {
        get {
            let formattedString = String(format: LocalisationHandler.getLocalisedStringForKey("usa_choose_from_options") + ", " + LocalisationHandler.getLocalisedStringForKey("usa_multiple_options_possible"), model.options.count)
            return formattedString
        }
        set {
            self.accessibilityExtraInfo = newValue
        }
    }
}
