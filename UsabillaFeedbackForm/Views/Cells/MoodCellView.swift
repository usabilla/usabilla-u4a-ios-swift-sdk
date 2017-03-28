//
//  MoodCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 09/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class MoodCellView: RootCellView, IntFieldHandlerProtocol {

    var fieldValue: Int = 0 {
        didSet {
            moodModel.fieldValue = self.fieldValue
        }
    }
    var moodModel: MoodFieldModel!
    var moodControl: RatingControl

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        moodControl = RatingControl()
        moodControl.mode = .selection

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        moodControl.translatesAutoresizingMaskIntoConstraints = false
        rootCellContainerView.addSubview(moodControl)

        moodControl.addTarget(self, action: #selector(MoodCellView.pickMood(sender:)), for: [.valueChanged])
        addConstraintToFillContainerView(view: moodControl)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? MoodFieldModel else {
            return
        }
        moodModel = item
        moodControl.backgroundColor = themeConfig.backgroundColor
        moodControl.maxValue = moodModel.points
        moodControl.selectedImages = item.themeConfig.emoticons(size: moodModel.points, emoticons: item.themeConfig.enabledEmoticons)
        moodControl.unselectedImages = item.themeConfig.emoticons(size: moodModel.points, emoticons: item.themeConfig.disabledEmoticons)
        moodControl.rating = reverseEmoticonValue(fieldValue: moodModel.fieldValue, maxMoods: moodModel.points)
    }

    func pickMood(sender: RatingControl) {
        let selectedIndex = emoticonValue(index: moodControl.rating!, maxMoods: moodModel.points)
        moodModel.fieldValue = selectedIndex
        loggingPrint("You picked the state \(selectedIndex)")
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
