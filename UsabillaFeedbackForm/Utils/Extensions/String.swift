//
//  String.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func divideInChunksOfSize(_ chuckSize: Int) -> [String] {
        var arrayToReturn: [String] = []
        let screenshotCharacterCount = self.characters.count
        let numberOfChunks = screenshotCharacterCount / chuckSize
        let lastChunk = screenshotCharacterCount % chuckSize

        if numberOfChunks > 0 {
            for chunk in 0...numberOfChunks - 1 {
                let start = chunk * chuckSize
                let range = NSRange(location: start, length: chuckSize)
                let section = (self as NSString).substring(with: range)
                arrayToReturn.append(section)
            }
        }
        if lastChunk > 0 {
            let lastRange = NSRange(location: numberOfChunks * chuckSize, length: lastChunk)
            let section = (self as NSString).substring(with: lastRange)
            arrayToReturn.append(section)
        }

        return arrayToReturn
    }

    func parseHTMLString(font: UIFont) -> NSAttributedString {
        let modifiedFont = NSString(format: "<span style=\"font-family: '\(font.fontName)'; font-size: \(font.pointSize)\">%@</span>" as NSString, self) as String

        do {
            let attrStr = try NSAttributedString(
                            data: modifiedFont.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                            documentAttributes: nil)
            return attrStr
        } catch {
            return NSAttributedString(string: self)
        }
    }
}
