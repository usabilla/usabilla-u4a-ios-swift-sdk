//
//  ChoiceCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ChoiceCellView: RootCellView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var choiceModel: ChoiceFieldModel!
    let picker: UIPickerView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        picker = UIPickerView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        picker.dataSource = self
        picker.delegate = self
        self.contentView.addSubview(picker)
      
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        let f = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        let a = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let v = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0)
        
        let z = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 8)
        
        contentView.addConstraints([f, a, v, z])
        
        setNeedsLayout()
    }
    
    override func applyCustomisations() {
        super.applyCustomisations()
        picker.backgroundColor = choiceModel.themeConfig.backgroundColor
        picker.tintColor = choiceModel.themeConfig.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        
        choiceModel = item as! ChoiceFieldModel
        if choiceModel.fieldValue.isEmpty {
            choiceModel.fieldValue = [choiceModel.options[0].value]
        } else {
            for (index, option) in choiceModel.options.enumerate() {
                if option.value == choiceModel.fieldValue[0] {
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
        
        if choiceModel.options.count < 4 {
            let a = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
                a.priority = 750
                a.active = true
        }
        setNeedsLayout()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choiceModel.options.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: choiceModel.options[row].title, attributes: [NSForegroundColorAttributeName: choiceModel.themeConfig.textColor])
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceModel.fieldValue = [choiceModel.options[row].value]
        Swift.debugPrint("picked \(choiceModel.fieldValue)")
        
    }
    
//    deinit {
//        print("choice cell deinit")
//    }
}
