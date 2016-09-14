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
        //removeOldViews()
        //sliderModel = item as! RatingFieldModel
        valueLabel = createSecondaryLabel()
        slider = UISlider()
        
        slider.tintColor = UsabillaThemeConfigurator.sharedInstance.accentColor
        slider.thumbTintColor = UsabillaThemeConfigurator.sharedInstance.accentColor
        
        slider.addTarget(self, action: #selector(SliderCellView.barChangedValue), forControlEvents: .ValueChanged)
        self.contentView.addSubview(slider)
        self.contentView.addSubview(valueLabel)
        
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        leftLabel = createSecondaryLabel()
        rightLabel = createSecondaryLabel()
        
        
        
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightLabel)
        
        
        let f = NSLayoutConstraint(item: slider, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 15)
        
        let a = NSLayoutConstraint(item: slider, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let v = NSLayoutConstraint(item: slider, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0)
        
        NSLayoutConstraint(item: valueLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -4).active = true
        
        trailingTitleLabelConstraint.active = false
        
        let views = ["titleLabel": super.titleLabel!,
                     "valueLabel": self.valueLabel]
        
        var allConstraints = [NSLayoutConstraint]()
        
        let iconVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(8)-[titleLabel]-(6)-[valueLabel(>=50)]-(8)-|",
            options: [],
            metrics: nil,
            views: views)
        allConstraints += iconVerticalConstraints
        
        NSLayoutConstraint.activateConstraints(allConstraints)
        
        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.slider, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 6).active = true
        
        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 8).active = true
        
        NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: -5).active = true
        
        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.slider, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 6).active = true
        
        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 8).active = true
        
        NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: -5).active = true
        
        contentView.addConstraints([f, a, v])
        
        
        setNeedsLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        sliderModel = item as! RatingFieldModel
        
        
        if sliderModel.fieldValue != nil {
            slider.value = Float(sliderModel.fieldValue!)
        } else {
            slider.value = 0
        }
        
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
    
}
