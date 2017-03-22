//
//  ScreenshotModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 06/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ScreenshotModel: BaseFieldModel, ImageComponentModel {
    var image: UIImage?
    var base64Value: String? {
        return toBase64String()
    }

    required init(json: JSON, pageModel: PageModel, screenShot: UIImage? = nil) {
        super.init(json: json, pageModel: pageModel)
        self.image = screenShot
    }

    func toBase64String() -> String? {
        return image?.toBase64()
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || image != nil
        return isModelValid
    }
}
