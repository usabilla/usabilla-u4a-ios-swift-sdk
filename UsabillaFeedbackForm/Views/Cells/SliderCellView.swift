//
//  SliderCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 11/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class SliderCellView: RootCellView {

    var slider: UISlider!
    var sliderModel: RatingFieldModel!
    var valueLabel: UILabel!
    var rightLabel: UILabel!
    var leftLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        valueLabel = createSecondaryLabel()
        leftLabel = createSecondaryLabel()
        rightLabel = createSecondaryLabel()
        
        slider = UISlider()
        slider.addTarget(self, action: #selector(SliderCellView.barChangedValue), for: .valueChanged)
        self.slider.translatesAutoresizingMaskIntoConstraints = false

        self.rootCellContainerView.addSubview(slider)
        self.rootCellContainerView.addSubview(valueLabel)
        self.rootCellContainerView.addSubview(leftLabel)
        self.rootCellContainerView.addSubview(rightLabel)


        let f = NSLayoutConstraint(item: slider, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 15)
        f.priority = 750
        f.isActive = true
        
        NSLayoutConstraint(item: valueLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 8).isActive = true
        
        NSLayoutConstraint(item: valueLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.slider, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        let views = ["slider": self.slider,
                     "valueLabel": self.valueLabel]

        var allConstraints = [NSLayoutConstraint]()

        let iconVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(8)-[slider]-(6)-[valueLabel(==50)]-(8)-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints

        NSLayoutConstraint.activate(allConstraints)

        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.slider, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 6).isActive = true

        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8).isActive = true

        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: -5).isActive = true

        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.slider, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 6).isActive = true

        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 8).isActive = true

        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: -5).isActive = true



    }

    override func applyCustomisations() {
        super.applyCustomisations()
        slider.tintColor = sliderModel.themeConfig.accentColor
        slider.thumbTintColor = sliderModel.themeConfig.accentColor
        //backgroundColor =  sliderModel.themeConfig.backgroundColor

        valueLabel.font = item.themeConfig.font.withSize(themeConfig.miniFontSize)
        valueLabel.textColor = item.themeConfig.textColor
        rightLabel.font = item.themeConfig.font.withSize(themeConfig.miniFontSize)
        rightLabel.textColor = item.themeConfig.textColor
        leftLabel.font = item.themeConfig.font.withSize(themeConfig.miniFontSize)
        leftLabel.textColor = item.themeConfig.textColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        sliderModel = item as! RatingFieldModel


        if sliderModel.isNPS {
            valueLabel.text = "0/10"
            slider.minimumValue = 0
            slider.maximumValue = 10
        } else {

            if let scale = sliderModel.scale {
                slider.maximumValue = Float(scale)
                valueLabel.text = "1/\(scale)"
            } else {
                slider.maximumValue = 10
                valueLabel.text = "0/10"
            }
            slider.minimumValue = 1
        }

        if let fieldValue = sliderModel.fieldValue {
            if let scale = sliderModel.scale {
                valueLabel.text = "\(fieldValue)/\(scale)"
            } else {
                valueLabel.text = "\(fieldValue)/10"
            }
        }

        leftLabel.text = sliderModel.low
        rightLabel.text = sliderModel.high

        if sliderModel.fieldValue != nil {
            slider.setValue(Float(Int(sliderModel.fieldValue!)), animated: false)
        } else {
            slider.setValue(0, animated: false)
        }

    }


    func barChangedValue() {

        let fieldValue = Int(slider.value)
        if let scale = sliderModel.scale {
            valueLabel.text = "\(fieldValue)/\(scale)"
        } else {
            valueLabel.text = "\(fieldValue)/10"
        }

        sliderModel.fieldValue = fieldValue
    }

//    deinit {
//        print("Slider cell deinit")
//    }

}
