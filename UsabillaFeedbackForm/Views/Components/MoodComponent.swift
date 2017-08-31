//
//  MoodComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 16/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class MoodComponent: UBComponent<MoodComponentViewModel> {

    var moodControl: RatingControl!

    override func build() {
        moodControl = RatingControl()
        moodControl.mode = viewModel.ratingMode
        moodControl.centered = viewModel.isCentered
        moodControl.translatesAutoresizingMaskIntoConstraints = false
        moodControl.addTarget(self, action: #selector(MoodComponent.pickMood(sender:)), for: [.valueChanged])

        addSubview(moodControl)

        // positioning
        moodControl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        moodControl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        moodControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        moodControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customization
        moodControl?.backgroundColor = viewModel.backgroundColor
        moodControl?.maxValue = viewModel.maxValue
        moodControl?.selectedImages = viewModel.selectedImages
        moodControl?.unselectedImages = viewModel.unselectedImages
        moodControl?.rating = viewModel.value
        moodControl?.tintColor = viewModel.tintColor
    }

    func pickMood(sender: RatingControl) {
        viewModel.value = moodControl.rating
        PLog("You pick state \(String(describing: viewModel.value))")

        valueChanged()
    }
}
