//
//  IntroOutroView.swift
//  UsabillaFeedbackForm
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
    private func setupTitle() {
        titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: outsideVerticalMargin).activate()
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: sidesMargin).activate()
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -sidesMargin).activate()
    }

    private func setupButtons() {
        buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        //swiftlint:disable:next force_unwrapping
        addSubview(buttonsStackView!)
        buttonsStackView.leftAnchor.constraint(equalTo: leftAnchor).activate()
        buttonsStackView.rightAnchor.constraint(equalTo: rightAnchor).activate()
        buttonsStackViewBottomContraint = buttonsStackView?.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        buttonsStackView.heightAnchor.constraint(equalToConstant: 44).activate()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually

        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(viewModel.cancelLabelText, for: .normal)

        buttonsStackView.addArrangedSubview(cancelButton)

        if viewModel.hasContinueButton {
            continueButton = UIButton(type: .system)
            //swiftlint:disable:next force_unwrapping
            buttonsStackView.addArrangedSubview(continueButton!)
            continueButton?.setTitle(viewModel.continueLabelText, for: .normal)
            continueButton?.addTarget(self, action: #selector(UBIntroOutroView.continueAction), for: .touchUpInside)

        }
        cancelButton.addTarget(self, action: #selector(UBIntroOutroView.dismissAction), for: .touchUpInside)
        updateContinueButton()
    }

    private func setupComponent() {
        if let componentViewModel = viewModel.componentViewModel {
            componentView = ComponentFactory.component(viewModel: componentViewModel)

            if !viewModel.hasContinueButton {
                componentView?.addTarget(self, action: #selector(UBIntroOutroView.componentValueChanged), for: [.valueChanged])
            }
            //swiftlint:disable:next force_unwrapping
            addSubview(componentView!)
            componentView?.translatesAutoresizingMaskIntoConstraints = false
            componentView?.leftAnchor.constraint(equalTo: leftAnchor, constant: sidesMargin).isActive = true
            componentView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -sidesMargin).isActive = true
            componentView?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: marginBetweenComponentAndTitle).isActive = true
        }
    }

    private func setupCustomizations() {
        if DeviceInfo.isIPad() {
            self.layer.cornerRadius = 8.0
        }

        backgroundColor = viewModel.backgroundColor
        cancelButton.setTitleColor(viewModel.buttonColor, for: .normal)
        continueButton?.setTitleColor(viewModel.buttonColor, for: .normal)
        continueButton?.setTitleColor(viewModel.buttonColor.withAlphaComponent(0.5), for: .disabled)

        cancelButton.titleLabel?.font = viewModel.font
        continueButton?.titleLabel?.font = viewModel.boldFont

        titleLabel.font = viewModel.boldFont
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
