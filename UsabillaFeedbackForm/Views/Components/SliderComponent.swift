//
//  SliderComponent.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 22/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


class SliderComponent: UBComponent<SliderComponentViewModel> {

    var slider: UISlider!
    var valueLabel: UILabel!
    var rightLabel: UILabel!
    var leftLabel: UILabel!

    override func build() {

        valueLabel = UILabel()
        leftLabel = UILabel()
        rightLabel = UILabel()
        slider = UISlider()

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(SliderComponent.barChangedValue), for: .valueChanged)
        self.slider.translatesAutoresizingMaskIntoConstraints = false

        addSubview(slider)
        addSubview(valueLabel)
        addSubview(leftLabel)
        addSubview(rightLabel)

        slider.topAnchor.constraint(equalTo: topAnchor, constant: 15).activate()
        slider.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        slider.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -6).isActive = true

        valueLabel.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true

        leftLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        rightLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 6).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: slider.rightAnchor, constant: 0).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true

        if viewModel.isNPS {
            valueLabel.text = "0/10"
            slider.minimumValue = 0
            slider.maximumValue = 10
        } else {

            if let scale = viewModel.scale {
                slider.maximumValue = Float(scale)
                valueLabel.text = "1/\(scale)"
            } else {
                slider.maximumValue = 10
                valueLabel.text = "0/10"
            }
            slider.minimumValue = 1
        }

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

    }

    func barChangedValue() {
        let fieldValue = Int(slider.value)
        if let scale = viewModel?.scale {
            valueLabel.text = "\(fieldValue)/\(scale)"
        } else {
            valueLabel.text = "\(fieldValue)/10"
        }
        viewModel.value = fieldValue
    }
}
