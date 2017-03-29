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
        moodControl.mode = .selection
        moodControl.centered = viewModel.isCentered
        moodControl.translatesAutoresizingMaskIntoConstraints = false
        moodControl.addTarget(self, action: #selector(MoodComponent.pickMood(sender:)), for: [.valueChanged])

        addSubview(moodControl)

        // positioning
        moodControl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        moodControl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        moodControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        moodControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customizaiton
        moodControl.backgroundColor = viewModel.theme.backgroundColor
        moodControl.selectedImages = viewModel.theme.enabledEmoticons
        moodControl.unselectedImages = viewModel.theme.disabledEmoticons
        
        moodControl?.rating = viewModel.value
    }

    func pickMood(sender: RatingControl) {
        viewModel.value = moodControl.rating
        print("You pick state \(String(describing: viewModel.value))")
        valueChanged()
    }
}
