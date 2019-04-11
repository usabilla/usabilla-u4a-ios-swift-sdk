//
//  MaskModel.swift
//  Usabilla
//
//  Created by Anders Liebl on 03/04/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

struct MaskModel {
    let maskCharacter: Character
    let masks: [String]

    func toMaskText(_ textToMask: String?) -> String? {
        if let text = textToMask {
            return mask(text)
        }
        return textToMask
    }

    private func mask(_ text: String) -> String {
        var newText = text
        for pattern in masks {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                for match in regex.matches(in: newText, range: NSRange(0..<newText.count)) {
                    if let range = Range(match.range, in: newText) {
                        let string = String(repeating: maskCharacter, count: match.range.length)
                        newText.replaceSubrange(range, with: string)
                    }
                }
            }
        }
        return newText
    }
}
