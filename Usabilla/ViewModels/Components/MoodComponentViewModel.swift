//
//  MoodComponentViewModel.swift
//  Usabilla
//
//  Created by Benjamin Grima on 14/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class MoodComponentViewModel: BaseIntComponentViewModel<MoodFieldModel>, Centerable {

    var isCentered: Bool = false

    override var value: Int? {
        get {
            return reverseEmoticonValue(fieldValue: model.fieldValue, maxMoods: model.points)
        }
        set {
            defer {
                delegate?.valueDidChange()
            }
            if let val = newValue {
                model.fieldValue = emoticonValue(index: val, maxMoods: model.points)
                return
            }
            model.fieldValue = nil
        }
    }

    var ratingMode: RatingMode {
        return model.mode
    }

    var maxValue: Int {
        return model.points
    }

    var selectedImages: [UIImage]? {
        if model.mode == .star {
            return [theme.images.star]
        }
        return theme.emoticons(size: model.points, emoticons: theme.images.enabledEmoticons)
    }

    var unselectedImages: [UIImage]? {
        if model.mode == .star {
            return [theme.images.starOutline]
        }
        return theme.emoticons(size: model.points, emoticons: theme.images.disabledEmoticons)
    }

    var accessibilityLabels: [String] {
        if model.mode == .star {
            return UBAccessibility.starLabels
        }

        // for emoticons only return labels based on the number of emoticons
        var labels = [String]()
        switch model.points {
        case 3:
            labels = UBAccessibility.emoticonLabels
                .enumerated()
                .filter { $0.offset % 2 == 0 }
                .map { $0.element }
        case 2:
            labels = UBAccessibility.emoticonLabels
                .enumerated()
                .filter { $0.offset % 4 == 0 }
                .map { $0.element }
        default:
            labels = UBAccessibility.emoticonLabels
        }

        return labels
    }

    var backgroundColor: UIColor {
        return theme.colors.background
    }

    var tintColor: UIColor {
        return theme.colors.accent
    }

    /**
     Get the real value of the emoticon selected. Ex if there are only two moods : converts index 0 to 1 and index 1 to 5
     to reflect the real values of the emoticons
     - parameter index: the selected index
     - parameter maxMoods: maximum moods visible in the mood control
     
     - return Int: the real value of the emoticon selected
     */
    func emoticonValue(index: Int, maxMoods: Int) -> Int {
        guard index >= 1 && index <= maxMoods else {
            return 0
        }

        switch maxMoods {
        case 2:
            return (index - 1) * 4 + 1
        case 3:
            return (index - 1) * 2 + 1
        default:
            return index
        }
    }

    /**
     Reverese of what "func emoticonValue(..)" does. Convert the value of the emoticon seleced to the real index to be selected in the mood control
     - parameter fieldValue: the value of the selected mood
     - parameter maxMoods: maximum moods visible in the mood control
     
     - return Int: the real index of the selected mood
     */
    func reverseEmoticonValue(fieldValue: Int?, maxMoods: Int) -> Int {
        guard let index = fieldValue, fieldValue != nil && index <= 5 else {
            return 0
        }

        switch maxMoods {
        case 2:
            return (index - 1) / 4 + 1
        case 3:
            return (index - 1) / 2 + 1
        default:
            return index
        }
    }
}
