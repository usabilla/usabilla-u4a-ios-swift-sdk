//
//  ScreenshotModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 06/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotModel: BaseFieldModel {

    var screenshot: UIImage?
    var base64Value: String? {
        return toBase64String()
    }

    required init(json: JSON, pageModel: PageModel, screenShot: UIImage? = nil) {
        super.init(json: json, pageModel: pageModel)
        self.screenshot = screenShot
    }

    func toBase64String() -> String? {
        return screenshot?.toBase64()
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || screenshot != nil
        return isModelValid
    }

    override func reset() {
        screenshot = nil
    }
}
