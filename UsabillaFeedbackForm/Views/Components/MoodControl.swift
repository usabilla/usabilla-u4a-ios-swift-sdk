//
//  MoodControl.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 06/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class MoodControl: UIControl {

    private let contentView = UIStackView()
    private var selectedIndex = -1
    private let numberOfMood = 5
    var selectedMood: Int? {
        get {
            return selectedIndex > -1 ? selectedIndex + 1: nil
        }
        set {
            guard let v = newValue, v > 0 && v <= numberOfMood else {
                return
            }
            selectedIndex = v - 1
            refreshSelected()
        }
    }
    var theme: UsabillaThemeConfigurator? {
        didSet {
            reload()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }

    private func internalInit() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.distribution = .fillEqually
        contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    private func reload() {
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let enabled = theme?.enabledEmoticons else {
            return
        }

        let disabled = theme?.disabledEmoticons

        for i in 0..<numberOfMood {
            let button = UIButton()
            let disabledImage = disabled != nil ? disabled![i] : enabled[i].alpha(value: 0.4)
            button.setImage(disabledImage, for: .normal)
            button.setImage(enabled[i], for: .selected)
            button.addTarget(self, action: #selector(MoodControl.didTouchUpInsideSmiley(_:)), for: .touchUpInside)
            contentView.addArrangedSubview(button)
        }
        refreshSelected()
    }

    func didTouchUpInsideSmiley(_ sender: UIButton) {
        guard let index = contentView.arrangedSubviews.index(of: sender), index != selectedIndex else {
            return
        }
        selectedIndex = index
        refreshSelected()
        sendActions(for: [.valueChanged])
    }

    private func refreshSelected() {
        for (index, s) in contentView.arrangedSubviews.enumerated() {
            (s as? UIButton)?.isSelected = index == selectedIndex
        }
    }

}
