//
//  AnyCodable.swift
//  Usabilla
//
//  Created by Anders Liebl on 22/04/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation

enum AnyCodable {
    case string(value: String)
    case int(value: Int)
    case data(value: Data)
    case double(value: Double)
    case bool(value: Bool)

    func toString() -> String? {
        switch self {
        case .string(value: let value):
            return value
        case .int(value: let value):
            return "\(value)"
        case .data(value: let value):
            return String(decoding: value, as: UTF8.self)
        case .double(value: let value):
            return String(value)
        case .bool(value: let value):
            return String(value)
        }
    }

    enum AnyCodableError: Error {
        case missingValue
    }
}

extension AnyCodable: Codable {

    enum CodingKeys: String, CodingKey {
        case string, int, data, double, bool
    }

    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(value: int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(value: string)
            return
        }

        if let data = try? decoder.singleValueContainer().decode(Data.self) {
            self = .data(value: data)
            return
        }

        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(value: double)
            return
        }

        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(value: bool)
            return
        }

        throw AnyCodableError.missingValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .int(let value):
            try container.encode(value, forKey: .int)
        case .data(let value):
            try container.encode(value, forKey: .data)
        case .double(let value):
            try container.encode(value, forKey: .double)
        case .bool(let value):
            try container.encode(value, forKey: .bool)
        }
    }
}
