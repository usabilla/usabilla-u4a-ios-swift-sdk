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
        moodControl.rating = moodModel.fieldValue
    }

    func pickMood(sender: RatingControl) {
        let selectedIndex = emoticonValue(index: moodControl.rating!)
        moodModel.fieldValue = selectedIndex
        print("You picked the state \(selectedIndex)")
    }
    
    func emoticonValue(index: Int) -> Int {
        switch moodModel.points {
        case 2:
            return (index - 1) * 4 + 1
        case 3:
            return (index - 1) * 2 + 1
        default:
            return index
        }
    }

}
