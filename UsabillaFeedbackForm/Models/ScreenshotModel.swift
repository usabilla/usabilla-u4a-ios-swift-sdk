//
//  ScreenshotModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 06/04/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

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
    
    
    func fixSizeAndOrientation() -> UIImage? {
        
        if let screen = screenshot {
            let currentWidht = screen.size.width
            let currentHeight = screen.size.height
            var scaleFactor: CGFloat = 1
            
            if currentWidht > 800 || currentHeight > 1200 {
                if currentHeight > currentWidht {
                    scaleFactor = 1200 / currentHeight
                } else {
                    scaleFactor = 800 / currentWidht
                }
                
                let newHeight = currentHeight * scaleFactor
                let newWidth = currentWidht * scaleFactor
                
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
                UIImage().drawInRect(CGRectMake(0, 0, newWidth, newHeight))
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return img
            }
            
            return screen
            
        }
        
        return nil
        
    }
    
    
    func toBase64String() -> String? {
        if let screen = screenshot {
            let data: NSData? = UIImagePNGRepresentation(screen.fixSizeAndOrientation())
            return data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        return nil
    }
    
    override func isValid() -> Bool {
        isModelValid = !isViewCurrentlyVisible || !required || screenshot != nil
        return isModelValid
    }
  
}
