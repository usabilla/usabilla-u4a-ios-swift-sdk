//
//  UIImage+CSExtension.swift
//  UsabillaCS
//
//  Created by Anders Liebl on 23/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func getImageFromUnit(name: String) -> UIImage? {
        guard let bundlename = Bundle.main.bundleIdentifier, let frameworkBundle = Bundle(identifier: bundlename) else { return nil }
        let path = frameworkBundle.bundlePath + "/Data/Raw/"
        let file = path + name
        return UIImage(contentsOfFile: file)
    }
}
