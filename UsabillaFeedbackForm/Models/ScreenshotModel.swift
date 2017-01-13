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

    required init(json: JSON, pageModel: PageModel) {
        fatalError("init(json:pageModel:) has not been implemented")
    }


    func toBase64String() -> String? {
        if let screen = screenshot {
            let data = UIImageJPEGRepresentation(screen.fixSizeAndOrientation(), 0.5)
            return data?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        }
        return nil
    }

    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || screenshot != nil
        return isModelValid
    }
}
