//
//  String.swift
//  Usabilla
//
//  Created by Benjamin Grima on 24/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }

    func parseHTMLString(font: UIFont) -> NSAttributedString {
        let modifiedFont = NSString(format: "<span style=\"font-family: '\(font.fontName)'; font-size: \(font.pointSize)\">%@</span>" as NSString, self) as String

        do {
            let attrStr = try NSAttributedString(
                                                // swiftlint:disable:next force_unwrapping
                                                 data: modifiedFont.data(using: String.Encoding.utf8, allowLossyConversion: true)!,
                                                 options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
                return attrStr
        } catch {
            return NSAttributedString(string: self)
        }
    }

    var dateFromRFC3339: Date? {
        return self.contains(".") ? Date.RFC3339FractionalSecondsFormatter.date(from: self) : Date.RFC3339Formatter.date(from: self)
    }
}
