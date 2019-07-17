//
//  Date.swift
//  Usabilla
//
//  Created by Benjamin Grima on 08/08/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

extension Date {
    private struct RFC3339Formats {
        static let `default` = "yyyy'-'MM'-'dd'T'HH':'mm':'ssXXXXX"
        static let fractionalSeconds = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSSSSXXXXX"
    }

    static let RFC3339Formatter: DateFormatter = {
        return buildRFC3339(format: Date.RFC3339Formats.default)
    }()

    static let RFC3339FractionalSecondsFormatter: DateFormatter = {
        return buildRFC3339(format: Date.RFC3339Formats.fractionalSeconds)
    }()

    static func buildRFC3339(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter
    }

    func toRFC3339Format() -> String {
        let formatter = Date.RFC3339Formatter
        return formatter.string(from: self)
    }

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        if let date = Calendar.current.date(from: components) {
            return date
        }
        return self
    }

    func relativeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium

        let dateString: String = dateFormatter.string(from: self)
        return dateString
    }
}
