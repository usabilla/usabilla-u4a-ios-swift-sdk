//
//  IntroPageModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

enum IntroPageDisplayMode: String {
    case alert
    case bannerBottom = "bottom"
    case bannerTop = "top"
}

class IntroPageModel: PageModel {
    var hasContinueButton: Bool = false
    var displayMode: IntroPageDisplayMode = .bannerBottom
}
