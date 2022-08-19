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

    func attributedStringWithWritingDirections() -> NSAttributedString {
        if self.count == 0 {
            return NSAttributedString(string: self)
        }
        let locale = NSLocale.autoupdatingCurrent
        var direction: NSLocale.LanguageDirection = .leftToRight
        if let lang = locale.languageCode {
            direction = NSLocale.characterDirection(forLanguage: lang)
        }
        if direction == .leftToRight {
            let number: [NSNumber] = [0]
            return  NSAttributedString(string: self,
                                       attributes: [.writingDirection: number])
        } else {
            let number: [NSNumber] = [1]
            return  NSAttributedString(string: self,
                                       attributes: [.writingDirection: number])
        }
    }

    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }

    func parseHTMLString(font: UIFont) -> NSAttributedString {
        let modifiedFont = NSString(format: "<span style=\"font-family: '-apple-system','HelveticaNeue'; font-size: \(font.pointSize)\">%@</span>" as NSString, self) as String

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

    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)

        while versionComponents.count < targetComponents.count {
            versionComponents.append("0")
        }

        while targetComponents.count < versionComponents.count {
            targetComponents.append("0")
        }

        for (version, target) in zip(versionComponents, targetComponents) {
            result = version.compare(target, options: .numeric)
            if result != .orderedSame {
                break
            }
        }

        return result
    }
    func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }

    func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }

    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }

    func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }

    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }

    static func == (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedSame }

    static func < (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedAscending }

    static func <= (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedDescending }

    static func > (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) == .orderedDescending }

    static func >= (lhs: String, rhs: String) -> Bool { lhs.compare(toVersion: rhs) != .orderedAscending }

}
