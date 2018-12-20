//
//  SliderComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class SliderComponent: UBComponent<SliderComponentViewModel> {

    lazy var slider: UBSlider = {
        let slider = UBSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
        return slider
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        return label
    }()

    override func build() {
        slider.addTarget(self, action: #selector(SliderComponent.barChangedValue), for: .valueChanged)

        // positioning
        slider.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        slider.rightAnchor.constraint(equalTo: rightAnchor, constant: -57).isActive = true
        //valueLabel.leftAnchor.constraint(equalTo: slider.rightAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        valueLabel.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 15).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        valueLabel.textAlignment = .right

        leftLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: slider.widthAnchor, multiplier: 0.5).isActive = true
        leftLabel.numberOfLines = 1

        rightLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: slider.rightAnchor, constant: 0).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: slider.widthAnchor, multiplier: 0.5).isActive = true
        rightLabel.numberOfLines = 1
        rightLabel.textAlignment = .right

        // configuration
        if let scale = viewModel.scale {
            slider.maximumValue = Float(scale)
            valueLabel.text = "1/\(scale)"
        } else {
            slider.maximumValue = 10
            valueLabel.text = "0/10"
        }
        slider.minimumValue = 1

        if let fieldValue = viewModel.value {
            if let scale = viewModel.scale {
                valueLabel.text = "\(fieldValue)/\(scale)"
            } else {
                valueLabel.text = "\(fieldValue)/10"
            }
        }

        leftLabel.text = viewModel.lowLabel
        rightLabel.text = viewModel.highLabel

        if let val = viewModel.value {
            slider.setValue(Float(Int(val)), animated: false)
        } else {
            slider.setValue(0, animated: false)
        }

        // customization
        let theme = viewModel.theme
        slider.minimumTrackTintColor = theme.colors.accent
        slider.maximumTrackTintColor = theme.colors.accent.withAlphaComponent(0.2)

        let image = Icons.imageOfCircle(color: theme.colors.accent)
        slider.setThumbImage(image, for: UIControlState.normal)
        slider.setThumbImage(image, for: UIControlState.selected)

        valueLabel.font = theme.fonts.font.withSize(theme.fonts.titleSize)
        valueLabel.textColor = theme.colors.text
        rightLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        rightLabel.textColor = theme.colors.text.withAlphaComponent(0.5)
        leftLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        leftLabel.textColor = theme.colors.text.withAlphaComponent(0.5)
    }

    func barChangedValue() {
        // rounded value
        let fieldValue: Int = Int(slider.value)
        // snap the slider value to the rounded value
        slider.value = Float(fieldValue)

        if let scale = viewModel?.scale {
            valueLabel.text = "\(fieldValue)/\(scale)"
        } else {
            valueLabel.text = "\(fieldValue)/10"
        }

        viewModel.value = fieldValue
        valueChanged()
    }
}
