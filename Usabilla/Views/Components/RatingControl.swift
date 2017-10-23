//
//  RatingControl.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

enum RatingMode {
    case emoticon
    case star
}

class RatingControl: UIControl {

    private let contentView = UIStackView()
    private var selectedIndex = -1

    private let size: CGFloat = 44
    private let spacing: CGFloat = 22

    private var initialTouchIndex = -1
    var maxValue = 5 {
        didSet {
            reload()
        }
    }

    var selectedImages: [UIImage]? {
        didSet {
            reload()
        }
    }
    var unselectedImages: [UIImage]? {
        didSet {
            reload()
        }
    }

    var mode: RatingMode = .star {
        didSet {
            reload()
        }
    }

    var rating: Int? {
        get {
            return selectedIndex > -1 ? selectedIndex + 1: nil
        }
        set {
            guard let v = newValue, v > 0 && v <= maxValue else {
                selectedIndex = -1
                refreshSelection()
                return
            }
            selectedIndex = v - 1
            refreshSelection()
        }
    }

    var centered = false {
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

    private func internalInit() {
        accessibilityIdentifier = "ratingControl"
        addSubview(contentView)
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: size).isActive = true
        contentView.distribution = .fillEqually
        contentView.isMultipleTouchEnabled = false
        if !centered {
            contentView.distribution = .fill
            contentView.spacing = spacing
        }
        reload()
    }

    private func imageForButton(_ index: Int, selected: Bool) -> UIImage? {
        switch mode {
        case .star:
            return selected ? selectedImages?.first : unselectedImages?.first
        case .emoticon:
            return selected ? selectedImages?[index] : unselectedImages?[index]
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reload()
    }

    private func reload() {
        isExclusiveTouch = true
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var prevbutton: UIButton?

        for i in 0..<maxValue {

            let button = UIButton()

            button.contentMode = .scaleAspectFill
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            let selected = imageForButton(i, selected: true)
            let unselected = imageForButton(i, selected: false) ?? selected?.alpha(value: 0.4)
            button.setImage(unselected, for: .normal)
            button.setImage(selected, for: .selected)
            button.isUserInteractionEnabled = false
            contentView.addArrangedSubview(button)

            button.setContentHuggingPriority(999, for: .horizontal)
            if let prev = prevbutton {
                button.widthAnchor.constraint(equalTo: prev.widthAnchor).isActive = true
            }
            prevbutton = button
        }

        if !centered { // add blank view to fill stackview
            let stretchingView = UIView()
            stretchingView.setContentHuggingPriority(1, for: .horizontal)
            stretchingView.backgroundColor = .clear
            contentView.addArrangedSubview(stretchingView)
        }
        refreshSelection()
    }

    private func refreshSelection() {
        for (index, subView) in contentView.arrangedSubviews.enumerated() {
            let button = (subView as? UIButton)
            switch mode {
            case .star:
                button?.isSelected = index <= selectedIndex
            case .emoticon:
                button?.isSelected = selectedIndex > -1 ? index == selectedIndex: true
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialTouchIndex = selectedIndex
        handleTouches(touches: touches, withEvent: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches, withEvent: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches, withEvent: event)
        if initialTouchIndex != selectedIndex {
            sendActions(for: .valueChanged)
        }
    }

    private func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            let maxX = centered ? frame.width : contentView.arrangedSubviews[contentView.arrangedSubviews.count - 2].frame.maxX

            if position.x >= 0 && position.x < maxX {
                ratingButtonSelected(position: position)
            }
        }
    }

    private func ratingButtonSelected(position: CGPoint) {
        let newIndex = contentView.arrangedSubviews.index {
            position.x >= $0.frame.minX && position.x < $0.frame.maxX
        } ?? selectedIndex

        guard newIndex != selectedIndex else {
            return
        }
        selectedIndex = newIndex
        refreshSelection()
    }
}
