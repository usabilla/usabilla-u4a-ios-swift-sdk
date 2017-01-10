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
    var moodControl = MoodControl()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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
        moodControl.theme = item.themeConfig
        moodControl.selectedMood = moodModel.fieldValue
    }

    func pickMood(sender: MoodControl) {
        moodModel.fieldValue = moodControl.selectedMood
        print("You pick state \(moodControl.selectedMood)")
    }

}
