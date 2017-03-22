//
//  IntroPageModel.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

enum IntroPageDisplayMode: String {
    case alert
    case bannerBottom
    case bannerTop
}

class IntroPageModel: PageModel {
    var hasContinueButton: Bool = false
    var displayMode: IntroPageDisplayMode = .bannerBottom
    
}
