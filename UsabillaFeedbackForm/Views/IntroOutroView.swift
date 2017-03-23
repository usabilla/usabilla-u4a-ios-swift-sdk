//
//  IntroOutroView.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol IntroViewDelegate: class {
    func introViewDidCancel(introView: IntroOutroView)
    func introViewDidContinue(introView: IntroOutroView)
}

class IntroOutroView: UIView {

    var viewModel: IntroPageViewModel!
    weak var delegate: IntroViewDelegate?
    var display: UBIntroOutroDisplay.Type {
        switch viewModel.displayMode {
        case .alert:
            return UBBannerDisplay.self
        default:
            return UBBannerDisplay.self
        }
    }
    
    // UI elements
    var continueButton: UIButton?
    var cancelButton: UIButton!

    var titleLabel: UILabel!
    var componentView: UIView?
    var buttonsWrapper: UIStackView!

    var buttonsWrapperBottomContraint: NSLayoutConstraint?
    var titleTopConstraint: NSLayoutConstraint!

    // constants
    let sidesMargin: CGFloat = 16
    let outsideVerticalMargin: CGFloat = 20
    let marginBetweenComponentAndTitle: CGFloat = 10

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
        buttonsWrapper = UIStackView()
        buttonsWrapper?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonsWrapper!)

        buttonsWrapper?.leftAnchor.constraint(equalTo: leftAnchor).activate()
        buttonsWrapper?.rightAnchor.constraint(equalTo: rightAnchor).activate()
        buttonsWrapperBottomContraint = buttonsWrapper?.bottomAnchor.constraint(equalTo: bottomAnchor).activate()

        buttonsWrapper?.axis = .horizontal
        buttonsWrapper?.distribution = .fillEqually

        // buttons
        cancelButton = UIButton()
        cancelButton.setTitle(viewModel.cancelLabelText, for: .normal)
        buttonsWrapper.addArrangedSubview(cancelButton)

        if viewModel.hasContinueButton {
            continueButton = UIButton()
            buttonsWrapper.addArrangedSubview(continueButton!)
        }

        // component
        if let componentViewModel = viewModel.componentViewModel {
            let component = ComponentFactory.component(viewModel: componentViewModel)
            addSubview(component)
            component.translatesAutoresizingMaskIntoConstraints = false
            component.leftAnchor.constraint(equalTo: leftAnchor, constant: sidesMargin).isActive = true
            component.rightAnchor.constraint(equalTo: rightAnchor, constant: -sidesMargin).isActive = true
            component.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: marginBetweenComponentAndTitle).isActive = true
            buttonsWrapper?.topAnchor.constraint(equalTo: component.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        } else {
            buttonsWrapper?.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: outsideVerticalMargin).isActive = true
        }

        // customization
        backgroundColor = viewModel.backgroundColor

        // TO DO font custimization
        let heightAnchor = titleLabel?.heightAnchor.constraint(equalToConstant: 80)
        heightAnchor?.priority = 249
        heightAnchor?.isActive = true

        display.build(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
