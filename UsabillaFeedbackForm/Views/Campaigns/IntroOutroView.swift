//
//  IntroOutroView.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

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

        // title
        titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = viewModel.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightMedium)
        titleLabel.numberOfLines = 0

        addSubview(titleLabel)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: outsideVerticalMargin).activate()
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: sidesMargin).activate()
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -sidesMargin).activate()

        // buttons container
        buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsStackView!)
        buttonsStackView.leftAnchor.constraint(equalTo: leftAnchor).activate()
        buttonsStackView.rightAnchor.constraint(equalTo: rightAnchor).activate()
        buttonsStackViewBottomContraint = buttonsStackView?.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        buttonsStackView.heightAnchor.constraint(equalToConstant: 44).activate()
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually

        // buttons
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle(viewModel.cancelLabelText, for: .normal)

        buttonsStackView.addArrangedSubview(cancelButton)

        if viewModel.hasContinueButton {
            continueButton = UIButton()
            buttonsStackView.addArrangedSubview(continueButton!)
            continueButton!.setTitle(viewModel.coninueLabelText, for: .normal)
            continueButton!.addTarget(self, action: #selector(UBIntroOutroView.continueAction), for: .touchUpInside)

        }

        cancelButton.addTarget(self, action: #selector(UBIntroOutroView.dismissAction), for: .touchUpInside)

        // component
        if let componentViewModel = viewModel.componentViewModel {
            let component = ComponentFactory.component(viewModel: componentViewModel)
            addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
            component.leftAnchor.constraint(equalTo: leftAnchor, constant: sidesMargin).isActive = true
            component.rightAnchor.constraint(equalTo: rightAnchor, constant: -sidesMargin).isActive = true
            component.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: marginBetweenComponentAndTitle).isActive = true
            buttonsStackView?.topAnchor.constraint(equalTo: component.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        } else {
            buttonsStackView?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        }

        // customization
        backgroundColor = viewModel.backgroundColor
        cancelButton.setTitleColor(viewModel.buttonsColor, for: .normal)
        continueButton?.setTitleColor(viewModel.buttonsColor, for: .normal)
        cancelButton.titleLabel?.font = viewModel.cancelButtonFont
        continueButton!.titleLabel?.font = viewModel.continueButtonFont

        
        // TO DO font custimization
        let heightAnchor = titleLabel?.heightAnchor.constraint(equalToConstant: 80)
        heightAnchor?.priority = 249
        heightAnchor?.isActive = true

        display.build(view: self)
    }

    func dismissAction() {
        delegate?.introViewDidCancel(introView: self)
    }

    func continueAction() {
        delegate?.introViewDidContinue(introView: self)
    }



}
