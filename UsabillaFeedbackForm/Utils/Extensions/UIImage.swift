//
//  UIImageExtension.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

extension UIImage {

    func alpha(value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func fixSizeAndOrientation() -> UIImage {
        let currentWidth = self.size.width
        let currentHeight = self.size.height
        var scaleFactor: CGFloat = 1

        if currentWidth > 800 || currentHeight > 1200 {
            if currentHeight > currentWidth {
                scaleFactor = 1200 / currentHeight
            } else {
                scaleFactor = 800 / currentWidth
            }

            let newHeight = Int(currentHeight * scaleFactor)
            let newWidth = Int(currentWidth * scaleFactor)

            UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
            draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }

        return self
    }

    func toBase64() -> String? {
        let data = UIImageJPEGRepresentation(self.fixSizeAndOrientation(), 0.5)
        return data?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
}
