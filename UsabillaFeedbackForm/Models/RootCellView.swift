//
//  RootCellModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit


class RootCellView: UITableViewCell {

    var rootCellContainerView: UIView
    var titleLabel: UILabel!
    var errorLabel: UILabel!
    var item: BaseFieldModel!
    var showErrorMessage = false

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
        return item.themeConfig
    }


    func isCurrentlyDisplayedChanged() {
        item.isViewCurrentlyVisible = isCurrentlyDisplayed
    }

    let errorLabelHeightConstraint: NSLayoutConstraint

    //Layout config
    let sideMargin: CGFloat = 16
    let verticalMargin: CGFloat = 20

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        rootCellContainerView = UIView()
        errorLabel = UILabel()
        
        errorLabelHeightConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorLabelHeightConstraint.isActive = true
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = createTitleLabel()

        contentView.addSubview(titleLabel)
        contentView.addSubview(errorLabel)
        contentView.addSubview(rootCellContainerView)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        rootCellContainerView.translatesAutoresizingMaskIntoConstraints = false


        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalMargin).isActive = true

        errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true

        rootCellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        rootCellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        rootCellContainerView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: verticalMargin * 2 / 3).isActive = true
        rootCellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalMargin).isActive = true
    }

    func addConstraintToFillContainerView(view: UIView, withMargin: CGFloat = 0) {
        NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .bottom, multiplier: 1, constant: -withMargin).isActive = true
        NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .top, multiplier: 1, constant: withMargin).isActive = true
        NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .leading, multiplier: 1, constant: withMargin).isActive = true
        NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self.rootCellContainerView, attribute: .trailing, multiplier: 1, constant: -withMargin).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func shoudlAppear() -> Bool? {
        return item.shouldAppear()
    }

    func setFeedbackItem(_ item: FieldModelProtocol) {
        guard let item = item as? BaseFieldModel else {
            return
        }
        self.item = item
        titleLabel.text = item.fieldTitle
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()
        titleLabel.textColor = item.themeConfig.titleColor

        if item.required {
            titleLabel.text = String(format: "%@ *", item.fieldTitle) as String

            let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)

            text.addAttribute(NSForegroundColorAttributeName, value: item.themeConfig.hintColor,
                              range: NSRange.init(location: (self.titleLabel?.text?.characters.count)! - 1, length: 1))

            titleLabel.attributedText = text

        } else {
            self.titleLabel.text = item.fieldTitle
        }

        isValid = item.isModelValid
    }

    func applyCustomisations() {
        titleLabel.font = themeConfig.font.withSize(themeConfig.titleFontSize)
        errorLabel.font = themeConfig.font.withSize(themeConfig.titleFontSize)
        errorLabel.textColor = themeConfig.errorColor
        errorLabel.text = item.pageModel.copy?.requiredFieldError
        if themeConfig.setTitlesInBold {
            if let boldVersion = titleLabel.font.withTraits(.traitBold) {
                titleLabel.font = boldVersion
            }
        }

        backgroundColor = item.themeConfig.backgroundColor
    }

    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        return titleLabel
    }

    func createSecondaryLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = NSTextAlignment.right
        titleLabel.numberOfLines = 0
        return titleLabel
    }


    func createDividerLine() -> UIView {
        let dividerLine = UIView()
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        return dividerLine
    }

    func updateValidStatus() {
        guard let required = item?.required else {
            return
        }
        errorLabelHeightConstraint.isActive = !(required && !isValid)
    }
}
