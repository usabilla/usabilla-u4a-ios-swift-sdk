//
//  RootCellModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit


class RootCellView: UITableViewCell {
    
    var trailingTitleLabelConstraint: NSLayoutConstraint!
    var titleLabel: UILabel!
    var dividerLine: UIView?
    var item: BaseFieldModel!
    var isValid: Bool = true {
        didSet {
            updateValidStatus()
        }
    }
    var isCurrentlyDisplayed = false {
        didSet {
            if oldValue != isCurrentlyDisplayed {
                isCurrentlyDisplayedChanged()
            }
        }
    }
    
    
    func isCurrentlyDisplayedChanged(){
        item.isViewCurrentlyVisible = isCurrentlyDisplayed
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.titleLabel = createTitleLabel()
        self.dividerLine = createDividerLine()
        self.dividerLine?.hidden = true

        //titleLabel?.sizeToFit()
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dividerLine!)
        self.backgroundColor = UsabillaThemeConfigurator.sharedInstance.backgroundColor
        
        let leadingC = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 8)
        
        trailingTitleLabelConstraint = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 8)
        
        trailingTitleLabelConstraint.active = true
        
        let topC = NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.TopMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TopMargin, multiplier: 1, constant: 10)
        
        let dividerTop = NSLayoutConstraint(item: dividerLine!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        
        let dividerHeight = NSLayoutConstraint(item: dividerLine!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 1)
        
        let dividerMarginLeft = NSLayoutConstraint(item: dividerLine!, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 8)
        
        let dividerMarginRight = NSLayoutConstraint(item: dividerLine!, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 8)
        
        contentView.addConstraints([leadingC, topC, dividerTop, dividerHeight, dividerMarginLeft, dividerMarginRight])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func shoudlAppear() -> Bool? {
        return item.shouldAppear()
    }
    
    func setFeedbackItem(item: FieldModelProtocol) {
        self.item = item as! BaseFieldModel
        titleLabel.text = item.fieldTitle
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()
        if item.required {
            
            titleLabel.text = String(format: "@ *", item.fieldTitle) as String
            
            let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)
            
            text.addAttribute(NSForegroundColorAttributeName, value: UsabillaThemeConfigurator.sharedInstance.hintColor,
                range: NSRange.init(location: (self.titleLabel?.text?.characters.count)!-1, length: 1))
            
            titleLabel.attributedText = text
            
        } else {
            self.titleLabel.text = item.fieldTitle
        }
        self.dividerLine!.backgroundColor = UsabillaThemeConfigurator.sharedInstance.hintColor
        
        isValid = item.isModelValid
    }
    
    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        //titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.font = UsabillaThemeConfigurator.sharedInstance.customFont?.fontWithSize(17.0)
        titleLabel.textColor = UsabillaThemeConfigurator.sharedInstance.primaryTextColor
        return titleLabel
    }
    
    func createSecondaryLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.Right
        titleLabel.numberOfLines = 0
        titleLabel.font = UsabillaThemeConfigurator.sharedInstance.customFont?.fontWithSize(14.0)
        titleLabel.textColor = UsabillaThemeConfigurator.sharedInstance.primaryTextColor
        return titleLabel
    }
    
    func createDividerLine() -> UIView {
        let dividerLine = UIView()
        dividerLine.backgroundColor = UsabillaThemeConfigurator.sharedInstance.hintColor
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        return dividerLine
    }
    
    
    func updateValidStatus() {
        if item!.required {
            if !isValid {
                titleLabel?.text = String(format: "%@ *", item!.fieldTitle) as String
                
                let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)
                
                text.addAttribute(NSForegroundColorAttributeName, value: UsabillaThemeConfigurator.sharedInstance.errorColor,
                    range: NSRange.init(location: (self.titleLabel?.text?.characters.count)!-1, length: 1))
                
                titleLabel?.attributedText = text
                
                self.dividerLine!.backgroundColor = UsabillaThemeConfigurator.sharedInstance.errorColor
            } else {
                titleLabel?.text = String(format: "%@ *", item!.fieldTitle) as String
                
                let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)
                
                text.addAttribute(NSForegroundColorAttributeName, value: UsabillaThemeConfigurator.sharedInstance.hintColor,
                    range: NSRange.init(location: (self.titleLabel?.text?.characters.count)!-1, length: 1))
                
                titleLabel?.attributedText = text
                
                self.dividerLine!.backgroundColor = UsabillaThemeConfigurator.sharedInstance.hintColor
                
            }
        }
    }
}
