//
//  RootCellModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class RootCellView: UITableViewCell {

    let rootCellContainerView: UIView
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    let errorLabel: UILabel = UILabel()
    var component: UIControl?

    var cellViewModel: CellViewModel! {
        didSet {
            let visible = cellViewModel.isViewCurrentlyVisible
            isHidden = !visible
            isUserInteractionEnabled = visible
            updateView()
            applyCustomisations()
            updateValidStatus()
        }
    }

    let errorLabelDismissConstraint: NSLayoutConstraint
    let titleLabelDismissConstraint: NSLayoutConstraint
    var errorLabelTopConstraint: NSLayoutConstraint!
    var containerTopConstraint: NSLayoutConstraint!

    //Layout config
    let sideMargin: CGFloat = 16
    let verticalMargin: CGFloat = 20
    let errorLabelTopMargin: CGFloat = 5
    let containerTopMargin: CGFloat = 13

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        rootCellContainerView = UIView()
        errorLabelDismissConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorLabelDismissConstraint.isActive = true

        titleLabelDismissConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(errorLabel)
        contentView.addSubview(rootCellContainerView)

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        rootCellContainerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalMargin).prioritize(UILayoutPriorityDefaultHigh).activate()

        errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()

        rootCellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).isActive = true
        rootCellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).isActive = true
        containerTopConstraint = rootCellContainerView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).prioritize(UILayoutPriorityDefaultHigh).activate()
        rootCellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalMargin).prioritize(UILayoutPriorityDefaultHigh).isActive = true
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
                comp.leadingAnchor.constraint(equalTo: rootCellContainerView.leadingAnchor).withID("RootCellView component left constraint").activate()
                comp.trailingAnchor.constraint(equalTo: rootCellContainerView.trailingAnchor).withID("RootCellView component right constraint").activate()
                comp.topAnchor.constraint(equalTo: rootCellContainerView.topAnchor).withID("RootCellView component top constraint").activate()
                comp.bottomAnchor.constraint(equalTo: rootCellContainerView.bottomAnchor).withID("RootCellView component bottom constraint").activate()
                comp.addTarget(self, action: #selector(RootCellView.componentValueChanged), for: .valueChanged)
            }
        }
        titleLabel.text = cellViewModel.title
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()

        let isTitleDefined = !cellViewModel.title.isEmpty
        titleLabelDismissConstraint.isActive = !isTitleDefined
        errorLabelTopConstraint.constant = isTitleDefined ? errorLabelTopMargin : 0
        containerTopConstraint.constant = isTitleDefined ? containerTopMargin : 0

        if cellViewModel.required {
            let requiredTitle = String(format: "%@ *", cellViewModel.title) as String
            titleLabel.text = requiredTitle
            if let attributedText = self.titleLabel.attributedText {
                let text = NSMutableAttributedString(attributedString: attributedText)
                text.addAttribute(NSForegroundColorAttributeName, value: cellViewModel.theme.hintColor,
                                  range: NSRange.init(location: requiredTitle.characters.count - 1, length: 1))
                titleLabel.attributedText = text
            }
            return
        }
        self.titleLabel.text = cellViewModel.title
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

    @discardableResult func updateValidStatus() -> Bool {
        if !cellViewModel.showErrorLabel != errorLabelDismissConstraint.isActive {
            errorLabelDismissConstraint.isActive = !cellViewModel.showErrorLabel
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
