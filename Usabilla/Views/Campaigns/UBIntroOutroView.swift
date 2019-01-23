//
//  IntroOutroView.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol UBIntroOutroViewDelegate: class {
    func introViewDidCancel(introView: UBIntroOutroView)
    func introViewDidContinue(introView: UBIntroOutroView)
}

class UBIntroOutroView: UIView {

    var viewModel: IntroPageViewModel!
    weak var delegate: UBIntroOutroViewDelegate?
    var display: UBIntroOutroDisplay.Type {
        switch viewModel.displayMode {
        case .alert:
            return UBAlertDisplay.self
        default:
            return UBBannerDisplay.self
        }
    }

    // UI elements
    var continueButton: UIButton?
    var cancelButton: UIButton!

    var titleLabel: UILabel!
    var componentView: UIControl?
    var buttonsStackView: UIStackView!

    var buttonsStackViewBottomContraint: NSLayoutConstraint?
    var titleTopConstraint: NSLayoutConstraint!

    var wrapper: UIView!
    var wrapperLeftConstraint: NSLayoutConstraint?
    var wrapperRightConstraint: NSLayoutConstraint?

    // constants
    let sidesMargin: CGFloat = 16
    let outsideVerticalMargin: CGFloat = 20
    let marginBetweenComponentAndTitle: CGFloat = 10

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(viewModel: IntroPageViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)

        setupWrapper()
        setupTitle()
        setupComponent()
        setupButtons()

        if let componentView = componentView {
            buttonsStackView?.topAnchor.constraint(equalTo: componentView.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        } else {
            buttonsStackView?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        }

        setupCustomizations()

        SwiftEventBus.onMainThread(self, name: "pageUpdatedValues") { _ in
            self.updateContinueButton()
        }

        display.build(view: self)
    }

    deinit {
        SwiftEventBus.unregister(self)
    }

    private func updateContinueButton() {
        continueButton?.isEnabled = viewModel.canContinue
    }

    override func updateConstraints() {
        super.updateConstraints()
        wrapperRightConstraint?.constant = -UIView.safeAreaEdgeInsets.right
        wrapperLeftConstraint?.constant = UIView.safeAreaEdgeInsets.left

    }

    private func setupWrapper() {
        let bottomDisplay = (viewModel.displayMode == .bannerBottom)
        wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wrapper)
        wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: (bottomDisplay ? 120 : 0)).activate()
        wrapper.topAnchor.constraint(equalTo: topAnchor, constant: (bottomDisplay ? 0 : -120) ).activate()
        wrapperLeftConstraint = wrapper.leftAnchor.constraint(equalTo: leftAnchor).activate()
        wrapperRightConstraint = wrapper.rightAnchor.constraint(equalTo: rightAnchor).activate()
    }

    private func setupTitle() {
        titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        wrapper.addSubview(titleLabel)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: outsideVerticalMargin).activate()
        titleLabel.leftAnchor.constraint(equalTo: wrapper.leftAnchor, constant: sidesMargin).activate()
        titleLabel.rightAnchor.constraint(equalTo: wrapper.rightAnchor, constant: -sidesMargin).activate()
    }

    private func setupButtons() {
        buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        //swiftlint:disable:next force_unwrapping
        wrapper.addSubview(buttonsStackView!)
        buttonsStackView.leftAnchor.constraint(equalTo: wrapper.leftAnchor).activate()
        buttonsStackView.rightAnchor.constraint(equalTo: wrapper.rightAnchor).activate()
        buttonsStackViewBottomContraint = buttonsStackView?.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor).activate()
        buttonsStackView.heightAnchor.constraint(equalToConstant: 44).activate()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillProportionally

        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(viewModel.cancelLabelText, for: .normal)

        buttonsStackView.addArrangedSubview(cancelButton)

        if viewModel.hasContinueButton || UIAccessibilityIsVoiceOverRunning() {
            continueButton = UIButton(type: .system)
            //swiftlint:disable:next force_unwrapping
            buttonsStackView.addArrangedSubview(continueButton!)
            // In case voice over is activated we want to add a continue button even if it does not exist
            var continueText = viewModel.continueLabelText
            if UIAccessibilityIsVoiceOverRunning() && (continueText?.isEmpty)! {
                continueText = LocalisationHandler.getLocalisedStringForKey("usa_accessibility_button_label_continue")
            }
            continueButton?.setTitle(continueText, for: .normal)
            continueButton?.addTarget(self, action: #selector(UBIntroOutroView.continueAction), for: .touchUpInside)
        }
        cancelButton.addTarget(self, action: #selector(UBIntroOutroView.dismissAction), for: .touchUpInside)
        updateContinueButton()
    }

    private func setupComponent() {
        if let componentViewModel = viewModel.componentViewModel {
            componentView = ComponentFactory.component(viewModel: componentViewModel)

            if !viewModel.hasContinueButton && !UIAccessibilityIsVoiceOverRunning() {
                componentView?.addTarget(self, action: #selector(UBIntroOutroView.componentValueChanged), for: [.valueChanged])
            }
            //swiftlint:disable:next force_unwrapping
            wrapper.addSubview(componentView!)
            componentView?.translatesAutoresizingMaskIntoConstraints = false
            componentView?.leftAnchor.constraint(equalTo: wrapper.leftAnchor, constant: sidesMargin).isActive = true
            componentView?.rightAnchor.constraint(equalTo: wrapper.rightAnchor, constant: -sidesMargin).isActive = true
            componentView?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: marginBetweenComponentAndTitle).isActive = true
        }
    }

    private func setupCustomizations() {
        if DeviceInfo.isIPad() {
            self.layer.cornerRadius = 8.0
        }
        self.layer.cornerRadius = 8.0
        backgroundColor = viewModel.backgroundColor
        cancelButton.setTitleColor(viewModel.cancelButtonColor, for: .normal)
        continueButton?.setTitleColor(viewModel.buttonColor, for: .normal)
        continueButton?.setTitleColor(viewModel.buttonColor.withAlphaComponent(0.5), for: .disabled)

        cancelButton.titleLabel?.font = viewModel.font
        continueButton?.titleLabel?.font = viewModel.font

        titleLabel.font = viewModel.boldFont.getDynamicTypeFont()
        titleLabel.textColor = viewModel.titleColor

        let heightAnchor = titleLabel?.heightAnchor.constraint(equalToConstant: 80)
        heightAnchor?.priority = 249
        heightAnchor?.isActive = true
    }

    func dismissAction() {
        delegate?.introViewDidCancel(introView: self)
    }

    func continueAction() {
        delegate?.introViewDidContinue(introView: self)
    }

    func componentValueChanged() {
        delegate?.introViewDidContinue(introView: self)
    }
}
