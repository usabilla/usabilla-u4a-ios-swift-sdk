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
        
        let currentWidht = self.size.width
        let currentHeight = self.size.height
        var scaleFactor: CGFloat = 1
        
        if currentWidht > 800 || currentHeight > 1200 {
            if currentHeight > currentWidht {
                scaleFactor = 1200 / currentHeight
            } else {
                scaleFactor = 800 / currentWidht
            }
            
            let newHeight = Int(currentHeight * scaleFactor)
            let newWidth = Int(currentWidht * scaleFactor)
            
            UIGraphicsBeginImageContext(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)))
            draw(in: CGRect(x: 0, y: 0, width: CGFloat(newWidth), height: CGFloat(newHeight)))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
        
        return self
    }
    
    
    func renderInColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: rect, mask: self.cgImage!)
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: img!.cgImage!, scale: 1, orientation: UIImageOrientation.downMirrored)
    }
    
}
