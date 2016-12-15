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

        setBoundsToFillContainerView(view: picker)

    }

    override func applyCustomisations() {
        super.applyCustomisations()
        picker.backgroundColor = choiceModel.themeConfig.backgroundColor
        picker.tintColor = choiceModel.themeConfig.textColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)

        choiceModel = item as! ChoiceFieldModel
        if choiceModel.fieldValue.isEmpty {
            choiceModel.fieldValue = [choiceModel.options[0].value]
        } else {
            for (index, option) in choiceModel.options.enumerated() {
                if option.value == choiceModel.fieldValue[0] {
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }

        if choiceModel.options.count < 5 {
            let a = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
                a.priority = 750
                a.isActive = true
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choiceModel.options.count
    }

//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let asd = NSAttributedString(string: choiceModel.options[row].title, attributes: [NSForegroundColorAttributeName: choiceModel.themeConfig.textColor, NSFontAttributeName: themeConfig.font.withSize(30)])
//        return asd
//    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel = view as? UILabel
        
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = NSTextAlignment.center
            pickerLabel?.font = themeConfig.font.withSize(themeConfig.titleFontSize + 2)
            pickerLabel?.textColor = themeConfig.textColor
        }
        
        pickerLabel?.text = choiceModel.options[row].title
        //pickerLabel?.sizeToFit()
        
        return pickerLabel!
    }



    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceModel.fieldValue = [choiceModel.options[row].value]
        Swift.debugPrint("picked \(choiceModel.fieldValue)")

    }

//    deinit {
//        print("choice cell deinit")
//    }
}
