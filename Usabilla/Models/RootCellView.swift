//
//  RootCellModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 02/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class RootCellView: UITableViewCell {

    // containterView: the main view that contains the `titleLabel`, `errorLabel` and the `componentView`
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = false

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var componentView: UIView!
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
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

    var errorLabelDismissConstraint: NSLayoutConstraint!
    var titleLabelDismissConstraint: NSLayoutConstraint!
    var errorLabelTopConstraint: NSLayoutConstraint!
    var componentViewTopConstraint: NSLayoutConstraint!

    //Layout config
    let sideMargin: CGFloat = 16
    let verticalMargin: CGFloat = 16
    let errorLabelTopMargin: CGFloat = 5
    let componentViewTopMargin: CGFloat = 13

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        componentView = UIView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
        setupConstraints()
    }

    func setupView() {
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(errorLabel)
        containerView.addSubview(componentView)

        // design
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func setupConstraints() {
        errorLabelDismissConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorLabelDismissConstraint.isActive = true
        titleLabelDismissConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 0)

        // containerView
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideMargin).activate()
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideMargin).activate()
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: sideMargin / 2).activate()
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -sideMargin / 2).activate()

        // titleLabel
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: verticalMargin).prioritize(UILayoutPriorityDefaultHigh).activate()

        // errorLabel
        errorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideMargin).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideMargin).isActive = true
        errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).activate()

        // componentView
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: sideMargin).isActive = true
        componentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -sideMargin).isActive = true
        componentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -verticalMargin).prioritize(UILayoutPriorityDefaultHigh).isActive = true
        componentViewTopConstraint = componentView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor).prioritize(UILayoutPriorityDefaultHigh).activate()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateView() {
        setupAccessiblity()
        component?.removeFromSuperview()
        if let componentViewModel = cellViewModel.componentViewModel {
            component = ComponentFactory.component(viewModel: componentViewModel)
            if let comp = component {
                comp.translatesAutoresizingMaskIntoConstraints = false
                componentView.addSubview(comp)
                comp.leadingAnchor.constraint(equalTo: componentView.leadingAnchor).withID("RootCellView component left constraint").activate()
                comp.trailingAnchor.constraint(equalTo: componentView.trailingAnchor).withID("RootCellView component right constraint").activate()
                comp.topAnchor.constraint(equalTo: componentView.topAnchor).withID("RootCellView component top constraint").activate()
                comp.bottomAnchor.constraint(equalTo: componentView.bottomAnchor).withID("RootCellView component bottom constraint").activate()
                comp.addTarget(self, action: #selector(RootCellView.componentValueChanged), for: .valueChanged)
            }
        }
        titleLabel.text = cellViewModel.title
        titleLabel.numberOfLines = 5
        titleLabel.sizeToFit()

        let isTitleDefined = !cellViewModel.title.isEmpty
        titleLabelDismissConstraint.isActive = !isTitleDefined
        errorLabelTopConstraint.constant = isTitleDefined ? errorLabelTopMargin : 0
        componentViewTopConstraint.constant = isTitleDefined ? componentViewTopMargin : 0

        if cellViewModel.required {
            let requiredTitle = String(format: "%@ *", cellViewModel.title) as String
            titleLabel.text = requiredTitle
            if let attributedText = self.titleLabel.attributedText {
                let text = NSMutableAttributedString(attributedString: attributedText)
                text.addAttribute(NSForegroundColorAttributeName, value: cellViewModel.theme.colors.hint,
                                  range: NSRange.init(location: requiredTitle.characters.count - 1, length: 1))
                titleLabel.attributedText = text
            }
            return
        }
        self.titleLabel.text = cellViewModel.title
    }

    private func setupAccessiblity() {
        var accessibilityLabelDetails = ""
        if let accessibilityLabel = cellViewModel.componentViewModel?.accessibilityExtraInfo {
            accessibilityLabelDetails = ", " + accessibilityLabel
        }
        guard cellViewModel.required else {
            accessibilityLabel = "\(cellViewModel.title)\(accessibilityLabelDetails)"
            return
        }
        let requiredLabel = LocalisationHandler.getLocalisedStringForKey("usa_accessibility_field_required")
        accessibilityLabel = "\(cellViewModel.title)\(accessibilityLabelDetails), \(requiredLabel)"
    }

    private func applyCustomisations() {
        let theme = cellViewModel.theme
        titleLabel.textColor = theme.colors.title
        errorLabel.textColor = theme.colors.error
        titleLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.boldFont)
        errorLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        containerView.backgroundColor = theme.colors.cardColor

        errorLabel.text = cellViewModel.copy.requiredFieldError
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
