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

    private let contentView = UIView()
    private let size: CGFloat = 42
    private let spacing: CGFloat = 0
    private let moodZoomScale: CGFloat = 1.3
    private let starZoomScale: CGFloat = 1.0

    private var initialTouchIndex = -1
    private var selectedIndex: Int = -1 {
        didSet {
            if rating == nil {
                return
            }
            accessibilityValue = accessibilityLabels[getSelectedIndexBase()]
            refreshSelection()
        }
    }
    var offset: CGFloat = 0 {
        didSet {
            reload()
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
            return getSelectedIndexBase() > -1 ? getSelectedIndexBase() + 1 : nil
        }
        set {
            guard let v = newValue, v > 0 && v <= maxValue else {
                selectedIndex = -1
                return
            }
            selectedIndex = getSelectedIndexBase(v)
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

    private func
        getSelectedIndexBase(_ selected: Int? = nil) -> Int {
        if let selectedIndex = selected {
            if selectedIndex*2 <= contentView.subviews.count {
                return selectedIndex*2-1
            }
            return selectedIndex
        }

        guard selectedIndex > -1 else {
            return -1
        }
        var num = selectedIndex
        if nil != contentView.subviews[selectedIndex] as? UIButton {
            num = (selectedIndex/2)
        }
        return num

    }
    private func internalInit() {
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraitAdjustable
        accessibilityIdentifier = "ratingControl"
        addSubview(contentView)
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: size).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        contentView.isMultipleTouchEnabled = false
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
    private func createSpaceView( width: CGFloat, xPos: CGFloat) -> UIView {
        let aView = UIView(frame: CGRect(x: xPos, y: 0, width: width, height: 42))
        aView.backgroundColor = UIColor.clear
        aView.isUserInteractionEnabled = false
        return aView
    }
    private func reload() {
        isExclusiveTouch = true
        accessibilityLabel = "\(LocalisationHandler.getLocalisedStringForKey("usa_mood_select_a_rating_out_of")) \(maxValue)"
        contentView.subviews.forEach { $0.removeFromSuperview() }
        configureStackViewForMoreMoods()
        refreshSelection()
    }

    private func configureStackViewForMoreMoods() {
        var screenWidth = DeviceInfo.getMaxFormWidth()
        let margins = DeviceInfo.getRightCardBorder()*4
        screenWidth -=  (margins + offset * 2)
        let numberOfMoods: CGFloat = CGFloat(maxValue)
        let moodsMaxWidth: CGFloat = numberOfMoods*42
        var spaceing = (screenWidth-moodsMaxWidth)/(numberOfMoods-1)
        spaceing = spaceing > 50 ? 50 : spaceing
        let viewMaxWidth = moodsMaxWidth+((numberOfMoods-1)*spaceing)
        var viewOffset = (screenWidth-viewMaxWidth)/2
        if !centered {
            viewOffset = 0
        }
        var currentXposition: CGFloat = 0
        let aButton = createSpaceView(width: viewOffset, xPos: currentXposition)
        contentView.addSubview(aButton)
        currentXposition += viewOffset

        for index in 0..<maxValue {
            let button = buttonForStackView(index: index, xPosition: currentXposition)
            currentXposition += button.frame.size.width
            contentView.addSubview(button)
           if index != maxValue-1 {
                let aButton = createSpaceView(width: spaceing, xPos: currentXposition)
                currentXposition += aButton.frame.width
                contentView.addSubview(aButton)
            }
        }
    }

    private func buttonForStackView(index: Int, xPosition: CGFloat) -> UIButton {
        let button = UIButton(frame: CGRect(x: xPosition, y: 0, width: 42, height: 42))
        button.contentMode = .scaleAspectFill
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        let selected = imageForButton(index, selected: true)
        let unselected = imageForButton(index, selected: false) ?? selected?.alpha(value: 0.4)
        button.setImage(unselected, for: .normal)
        button.setImage(selected, for: .selected)
        button.isUserInteractionEnabled = false
        button.widthAnchor.constraint(equalToConstant: 42).isActive = true
        return button
    }

    private func refreshSelection(animated: Bool = true) {

        // get the moodview
        let moodviews = contentView.subviews.filter { $0 is UIButton }

        for (index, subView) in moodviews.enumerated() {
            let button = (subView as? UIButton)

            var state: Bool = false

            state = mode == .star ? index <= getSelectedIndexBase(): index == getSelectedIndexBase()
            let zoomScale = mode == .star ? starZoomScale : moodZoomScale

            if getSelectedIndexBase() > -1 {
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
            let maxX = centered ? frame.width : contentView.subviews[contentView.subviews.count - 2].frame.maxX
            if position.x >= 0 && position.x < maxX {
                ratingButtonSelected(position: position)
            }
        }
    }

    private func ratingButtonSelected(position: CGPoint) {
        let newIndex = contentView.subviews.index {
            position.x >= $0.frame.minX && position.x < $0.frame.maxX
        } ?? selectedIndex

        guard newIndex != selectedIndex else {
            return
        }
        if nil == contentView.subviews[newIndex] as? UIButton {
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
