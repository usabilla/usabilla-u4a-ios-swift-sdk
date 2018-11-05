//
//  NPSComponent.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class NPSComponent: UBComponent<NPSComponentViewModel> {

    var nps = NPSControl()
    var leftLabel = UILabel()
    var rightLabel = UILabel()

    override func build() {
        setupView()
        setupLayout()
        customizeView()
        nps.addTarget(self, action: #selector(NPSComponent.pickValue(sender:)), for: [.valueChanged])
        nps.rating = viewModel.value
    }

    func pickValue(sender: RatingControl) {
        viewModel.value = nps.rating
        valueChanged()
    }

    private func setupView() {
        addSubviews(nps, leftLabel, rightLabel)
        leftLabel.text = viewModel.lowLabel
        rightLabel.text = viewModel.highLabel
    }

    private func setupLayout() {
        nps.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nps.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nps.rightAnchor.constraint(equalTo: rightAnchor).prioritize(UILayoutPriorityDefaultHigh).isActive = true

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.topAnchor.constraint(equalTo: nps.bottomAnchor, constant: 6).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        leftLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        leftLabel.numberOfLines = 0

        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.topAnchor.constraint(equalTo: nps.bottomAnchor, constant: 6).isActive = true
        rightLabel.trailingAnchor.constraint(equalTo: nps.trailingAnchor).isActive = true
        rightLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).prioritize(UILayoutPriorityDefaultLow).isActive = true
        rightLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        rightLabel.numberOfLines = 0
        rightLabel.textAlignment = .right
    }

    private func customizeView() {
        let theme = viewModel.theme
        nps.font = theme.fonts.boldFont
        nps.tintColor = theme.colors.accent
        nps.toolTipTextColor = theme.colors.textOnAccent

        leftLabel.textColor = theme.colors.text.withAlphaComponent(0.5)
        leftLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
        rightLabel.textColor = viewModel.theme.colors.text.withAlphaComponent(0.5)
        rightLabel.applyFontWithDynamicTypeEnabled(font: theme.fonts.font.withSize(theme.fonts.miniSize))
    }
}
