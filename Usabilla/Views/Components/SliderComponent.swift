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
        slider.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        slider.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -6).isActive = true

        valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true

        leftLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: slider.widthAnchor, multiplier: 0.5).isActive = true
        leftLabel.numberOfLines = 0

        rightLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: slider.rightAnchor, constant: 0).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: slider.widthAnchor, multiplier: 0.5).isActive = true
        rightLabel.numberOfLines = 0
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

        slider.tintColor = theme.colors.accent
        slider.thumbTintColor = theme.colors.accent

        valueLabel.font = theme.fonts.font.withSize(theme.fonts.miniSize)
        valueLabel.textColor = theme.colors.text
        rightLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        rightLabel.textColor = theme.colors.text
        leftLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        leftLabel.textColor = theme.colors.text
    }

    func barChangedValue() {
        // rounded value
        let fieldValue: Int = Int(slider.value)
        // actual value
        let offset: Float = slider.value - Float(fieldValue)
        // snap the slider value the nearest round value
        let selectedValue: Int = (offset >= 0.5) ? fieldValue + 1 : fieldValue
        slider.value = Float(selectedValue)

        if let scale = viewModel?.scale {
            valueLabel.text = "\(selectedValue)/\(scale)"
        } else {
            valueLabel.text = "\(selectedValue)/10"
        }

        viewModel.value = Int(selectedValue)
        valueChanged()
    }
}
