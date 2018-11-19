//
//  MoodComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 16/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class MoodComponent: UBComponent<MoodComponentViewModel> {

    var moodControl: RatingControl!
    let moodComponentOffset: CGFloat = 7
    let starComponentOffset: CGFloat = 0

    override func build() {
        moodControl = RatingControl()
        moodControl.maxValue = viewModel.maxValue
        moodControl.mode = viewModel.ratingMode
        moodControl.centered = viewModel.isCentered
        moodControl.accessibilityLabels = viewModel.accessibilityLabels
        moodControl.translatesAutoresizingMaskIntoConstraints = false
        moodControl.addTarget(self, action: #selector(MoodComponent.pickMood(sender:)), for: [.valueChanged])
        moodControl.centered = true
        addSubview(moodControl)

        // positioning

        let offset: CGFloat = (viewModel.ratingMode == .emoticon) ? moodComponentOffset : starComponentOffset
        moodControl.leftAnchor.constraint(equalTo: leftAnchor, constant: offset).isActive = true
        moodControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset).isActive = true
        moodControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        moodControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // customization
        moodControl?.backgroundColor = viewModel.backgroundColor
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
