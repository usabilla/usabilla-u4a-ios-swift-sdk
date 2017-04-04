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
    var component: UIControl?

    var cellViewModel: CellViewModel! {
        didSet {
            let visible = cellViewModel.shouldAppear
            isHidden = !visible
            isUserInteractionEnabled = visible
            isCurrentlyDisplayed = visible
            updateView()
            applyCustomisations()
            updateValidStatus()
        }
    }

    var isCurrentlyDisplayed = false {
        didSet {
            isCurrentlyDisplayedChanged()
        }
    }

    func isCurrentlyDisplayedChanged() {
        cellViewModel.isViewCurrentlyVisible = isCurrentlyDisplayed
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateView() {
        component?.removeFromSuperview()
        if let componentViewModel = cellViewModel.componentViewModel {
            component = ComponentFactory.component(viewModel: componentViewModel)
            if let comp = component {
                comp.translatesAutoresizingMaskIntoConstraints = false
                rootCellContainerView.addSubview(comp)
                comp.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).withId("RootCellView component left constraint").activate()
                comp.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).withId("RootCellView component right constraint").activate()
                comp.topAnchor.constraint(equalTo: rootCellContainerView.topAnchor).withId("RootCellView component top constraint").activate()
                comp.bottomAnchor.constraint(equalTo: rootCellContainerView.bottomAnchor).withId("RootCellView component bottom constraint").activate()
                comp.addTarget(self, action: #selector(RootCellView.componentValueChanged), for: .valueChanged)
            }
        }
        titleLabel.text = cellViewModel.title
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()

        if cellViewModel.required {
            titleLabel.text = String(format: "%@ *", cellViewModel.title) as String

            let text = NSMutableAttributedString(attributedString: (self.titleLabel?.attributedText)!)

            text.addAttribute(NSForegroundColorAttributeName, value: cellViewModel.theme.hintColor,
                              range: NSRange.init(location: (self.titleLabel?.text?.characters.count)! - 1, length: 1))

            titleLabel.attributedText = text

        } else {
            self.titleLabel.text = cellViewModel.title
        }
    }

    private func applyCustomisations() {
        let theme = cellViewModel.theme
        let copy = cellViewModel.copy
        titleLabel.textColor = theme.titleColor
        titleLabel.font = theme.boldFont
        errorLabel.font = theme.font.withSize(theme.miniFontSize)
        errorLabel.textColor = theme.errorColor
        errorLabel.text = copy.requiredFieldError
        backgroundColor = theme.backgroundColor
    }

    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        return titleLabel
    }

    @discardableResult func updateValidStatus() -> Bool {
        if !cellViewModel.showErrorLabel != errorLabelHeightConstraint.isActive {
            errorLabelHeightConstraint.isActive = !cellViewModel.showErrorLabel
            return true
        }
        return false
    }

    func componentValueChanged() {
        cellViewModel.updateErrorLabel()
        if updateValidStatus() {
            SwiftEventBus.postToMainThread("updateMySize")
        }
    }
}
