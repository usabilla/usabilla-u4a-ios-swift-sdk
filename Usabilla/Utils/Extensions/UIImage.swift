//
//  UIImageExtension.swift
//  Usabilla
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

extension UIImage {

    static func getImageFromSDKBundle(name: String) -> UIImage? {
        let bundle = Bundle(identifier: "com.usabilla.Usabilla")
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    func alpha(value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // swiftlint:disable:next force_unwrapping
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
            // swiftlint:disable:next force_unwrapping
            return img!
        }

        return self
    }

    func toBase64() -> String? {
        let data = UIImageJPEGRepresentation(self.fixSizeAndOrientation(), 0.5)
        return data?.base64EncodedString()
    }

    func crop(_ toSize: CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = toSize.width / toSize.height

        var cropWidth: CGFloat = toSize.width
        var cropHeight: CGFloat = toSize.height

        if toSize.width > toSize.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if toSize.width < toSize.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            } else { //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        UIGraphicsBeginImageContextWithOptions(toSize, true, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resized!
    }
}
