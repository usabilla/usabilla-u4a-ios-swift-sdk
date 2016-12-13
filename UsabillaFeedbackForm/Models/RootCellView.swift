//
//  RootCellModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit


class RootCellView: UITableViewCell {

    var titleLabel: UILabel!
    var item: BaseFieldModel!
    var isValid: Bool = true {
        didSet {
            updateValidStatus()
        }
    }
    var isCurrentlyDisplayed = false {
        didSet {
            isCurrentlyDisplayedChanged()
        }
    }
    var themeConfig: UsabillaThemeConfigurator {
        get {
            return item.themeConfig
        }
    }


    func isCurrentlyDisplayedChanged() {
        item.isViewCurrentlyVisible = isCurrentlyDisplayed
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.titleLabel = createTitleLabel()

        //titleLabel?.sizeToFit()
        self.contentView.addSubview(titleLabel)

        NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 8).isActive = true

        NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1, constant: 8).isActive = true

        NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.topMargin, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.topMargin, multiplier: 1, constant: 10).isActive = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func shoudlAppear() -> Bool? {
        return item.shouldAppear()
    }

    func setFeedbackItem(_ item: FieldModelProtocol) {
        self.item = item as! BaseFieldModel
        titleLabel.text = item.fieldTitle
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()
        titleLabel.textColor = item.themeConfig.titleColor

        if item.required {

            titleLabel.text = String(format: "@ *", item.fieldTitle) as String

            let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)

            text.addAttribute(NSForegroundColorAttributeName, value: item.themeConfig.hintColor,
                              range: NSRange.init(location: (self.titleLabel?.text?.characters.count)!-1, length: 1))

            titleLabel.attributedText = text

        } else {
            self.titleLabel.text = item.fieldTitle
        }

        isValid = item.isModelValid
    }

    func applyCustomisations() {
        if let customFont = themeConfig.font.withSize(themeConfig.titleFontSize).withTraits(.traitBold) {
            titleLabel.font = customFont
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: themeConfig.titleFontSize).withTraits(.traitBold)
        }
        backgroundColor = item.themeConfig.backgroundColor
    }

    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        
        //titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //titleLabel.textColor = item.themeConfig.primaryTextColor
        return titleLabel
    }

    func createSecondaryLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.right
        titleLabel.numberOfLines = 0
        //titleLabel.textColor = item.themeConfig.primaryTextColor
        return titleLabel
    }

    func createDividerLine() -> UIView {
        let dividerLine = UIView()
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        return dividerLine
    }


    func updateValidStatus() {
        if item!.required {
            if !isValid {
                titleLabel?.text = String(format: "%@ *", item!.fieldTitle) as String

                let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)

                text.addAttribute(NSForegroundColorAttributeName, value: item.themeConfig.errorColor,
                                  range: NSRange.init(location: (self.titleLabel?.text?.characters.count)!-1, length: 1))

                titleLabel?.attributedText = text
            } else {
                titleLabel?.text = String(format: "%@ *", item!.fieldTitle) as String
                titleLabel.textColor = themeConfig.titleColor
            }
        }
    }
}
