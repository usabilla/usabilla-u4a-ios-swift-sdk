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

    private let size: CGFloat = 44
    private let spacing: CGFloat = 22
    private let moodZoomScale: CGFloat = 1.3
    private let starZoomScale: CGFloat = 1.0

    private var initialTouchIndex = -1
    private var selectedIndex = -1 {
        didSet {
            guard let rating = rating else {
                return
            }

            let index = rating > 0 ? rating - 1: 0
            accessibilityValue = accessibilityLabels[index]
            refreshSelection()
        }
    }
    var accessibilityLabels: [String] = []
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
            return selectedIndex > -1 ? selectedIndex + 1 : nil
        }
        set {
            guard let v = newValue, v > 0 && v <= maxValue else {
                selectedIndex = -1
                return
            }
            selectedIndex = v - 1
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
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraitAdjustable
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
        accessibilityLabel = "\(LocalisationHandler.getLocalisedStringForKey("usa_mood_select_a_rating_out_of")) \(maxValue)"
        contentView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var prevbutton: UIButton?

        for index in 0..<maxValue {

            let button = UIButton()
            button.contentMode = .scaleAspectFill
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            let selected = imageForButton(index, selected: true)
            let unselected = imageForButton(index, selected: false) ?? selected?.alpha(value: 0.4)
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

    private func refreshSelection(animated: Bool = true) {
        for (index, subView) in contentView.arrangedSubviews.enumerated() {
            let button = (subView as? UIButton)
            var state: Bool = false

            state = mode == .star ? index <= selectedIndex: index == selectedIndex
            let zoomScale = mode == .star ? starZoomScale : moodZoomScale

            if selectedIndex > -1 {
                if animated {
                    animateMood(button: button, canBeZoomed: state, startScale: 0.8, endScale: zoomScale)
                }
                button?.isSelected = state
            }
        }
    }

    // MARK: UIResponder methods
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

    // MARK: Handle touch events
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
    }

    private func animateMood(button: UIButton?, canBeZoomed: Bool, startScale: CGFloat, endScale: CGFloat) {
        guard let button = button else {
            return
        }

        if canBeZoomed {
            button.transform = CGAffineTransform(scaleX: startScale, y: startScale)
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                               button.transform = CGAffineTransform(scaleX: endScale, y: endScale)
                           },
                           completion: nil)
        } else {
            button.transform = CGAffineTransform.identity
        }
    }

    // MARK: Accessibility

    override func accessibilityElementCount() -> Int {
        return maxValue
    }

    override func accessibilityIncrement() {
        guard selectedIndex < maxValue - 1 else {
            return
        }
        selectedIndex += 1
        sendActions(for: .valueChanged)
    }

    override func accessibilityDecrement() {
        guard selectedIndex > 0 else {
            return
        }
        selectedIndex -= 1
        sendActions(for: .valueChanged)
    }

    override func accessibilityActivate() -> Bool {
        return true
    }
}
