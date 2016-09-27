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
    //var icon: UIImage
    var base64Value: String? {
        get {
            return toBase64String()
        }
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
            //let data: NSData? = UIImagePNGRepresentation(screen.fixSizeAndOrientation())
            let data = UIImageJPEGRepresentation(screen.fixSizeAndOrientation(), 0.5)
            return data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
    
    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || screenshot != nil
        return isModelValid
    }
    
    deinit {
        print("screenshot field model")
    }
    
  
}
