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
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return resultImage
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

        if let imageRef: CGImage = contextImage.cgImage?.cropping(to: rect) {

            let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            UIGraphicsBeginImageContextWithOptions(toSize, true, self.scale)
            cropped.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
            let resized = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resized ?? self
        }
        return self
    }

    /// maskWithColor: 
    func maskWithColor(color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard  let context = UIGraphicsGetCurrentContext() else { return self }

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.sourceIn)
        context.fill(rect)

        if let resultImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return resultImage
        }
        UIGraphicsEndImageContext()
        return self
    }

    func cropAlpha() -> UIImage {

        let cgImage = self.cgImage!

        let width = cgImage.width
        let height = cgImage.height

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel: Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }

        context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))

        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0

        for xrow in 1 ..< width {
            for yrow in 1 ..< height {

                let integer = bytesPerRow * Int(yrow) + bytesPerPixel * Int(xrow)
                let alpha = CGFloat(ptr[integer + 3]) / 255.0

                if alpha > 0 {
                    if xrow < minX { minX = xrow }
                    if xrow > maxX { maxX = xrow }
                    if yrow < minY { minY = yrow }
                    if yrow > maxY { maxY = yrow }
                }
            }
        }

        let rect = CGRect(x: CGFloat(minX), y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale: CGFloat = self.scale
        let croppedImage =  self.cgImage!.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        return ret
    }

}
