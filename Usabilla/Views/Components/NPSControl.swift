//
//  NPSControl.swift
//  Usabilla
//
//  Created by Benjamin Grima on 12/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

//swiftlint:disable:next type_body_length
class NPSControl: UIControl {

    class NPSLabel: UILabel {
        private let selectedFontSize: CGFloat = 18
        var isLower: Bool = false {
            didSet {
                updateColor()
            }
        }
        var isSelected: Bool = false {
            didSet {
                updateColor()
            }
        }
        var hightlightedTextColor: UIColor? {
            didSet {
                updateColor()
            }
        }
        var customFont: UIFont? {
            didSet {
                font = customFont
            }
        }

        func updateColor() {
            textColor = isLower || isSelected ? hightlightedTextColor : tintColor
        }
    }

    private var selectedLabel: NPSLabel = NPSLabel()
    private let borderedView = UIView()
    private let contentStackView = UIStackView()
    private var labels: [NPSLabel] {
        //swiftlint:disable:next force_cast
        return contentStackView.arrangedSubviews as! [NPSLabel]
    }
    private let progressView = UIView()
    private let touchView = UBTouchView()
    private var toolTip = NPSToolTip()

    private var toolTipCenterXContraint: NSLayoutConstraint!
    private var progressViewTrailingAnchor: NSLayoutConstraint!

    private var initialTouchIndex = -1
    private var selectedIndex = -1 {
        didSet {
            accessibilityValue = rating?.description
            refreshSelection()
        }
    }
    private var feedbackGenerator: Any?

    // MARK: Configuration
    private let numberOfValues = 11

    private let npsHeight: CGFloat = 32
    private let sideContentStackViewPadding: CGFloat = 3//14
    private let minimumChoiceWidth: CGFloat = 20
    private let maximiumChoiceWidth: CGFloat = 50
    private let progressViewMargins: CGFloat = 0.55 * UIScreen.main.scale
    private let transitionDuration: TimeInterval = 0.15

    // MARK: Customization
    var font: UIFont? {
        didSet {
            labels.forEach { $0.customFont = font }
            toolTip.label.font = font?.withSize(20)
        }
    }
    var toolTipTextColor: UIColor? {
        didSet {
            labels.forEach { $0.hightlightedTextColor = toolTipTextColor }
            selectedLabel.hightlightedTextColor = toolTipTextColor
            toolTip.label.textColor = toolTipTextColor
        }
    }
    var rating: Int? {
        get {
            return selectedIndex > -1 ? selectedIndex : nil
        }
        set {
            guard let v = newValue, v >= 0 && v < numberOfValues else {
                selectedIndex = -1
                return
            }
            selectedIndex = v
        }
    }
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(numberOfValues) * minimumChoiceWidth + 2.0 * sideContentStackViewPadding, height: npsHeight)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }

    override func tintColorDidChange() {
        labels.forEach { $0.tintColor = tintColor }
        toolTip.tintColor = tintColor
        progressView.backgroundColor = tintColor.withAlphaComponent(0.5)
        borderedView.layer.borderColor = tintColor.cgColor
        selectedLabel.tintColor = tintColor
        selectedLabel.backgroundColor = tintColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        borderedView.layoutIfNeeded()
        refreshSelection()
    }

    private func internalInit() {
        createCircleLable()
        setupView()
        setupLayout()
        refreshSelection()
    }

    private func setupView() {
        isAccessibilityElement = true
        backgroundColor = .clear
        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false

        borderedView.isMultipleTouchEnabled = false
        borderedView.layer.borderWidth = 0
        borderedView.layer.cornerRadius = npsHeight / 2
        borderedView.layer.masksToBounds = true
        borderedView.layer.shouldRasterize = true
        borderedView.layer.rasterizationScale = UIScreen.main.scale
        borderedView.clipsToBounds = false

        selectedLabel.layer.cornerRadius = 18
        selectedLabel.layer.masksToBounds = true

        progressView.isHidden = true

        toolTip.alpha = 0.0

        addSubviews(borderedView, toolTip)
        borderedView.addSubviews(progressView, contentStackView, selectedLabel, touchView)
        createLabels(inContentView: contentStackView, count: numberOfValues)
    }

    private func setupLayout() {
        borderedView.translatesAutoresizingMaskIntoConstraints = false
        borderedView.topAnchor.constraint(equalTo: topAnchor).activate()
        borderedView.leadingAnchor.constraint(equalTo: leadingAnchor).activate()
        borderedView.trailingAnchor.constraint(equalTo: trailingAnchor).activate()
        borderedView.bottomAnchor.constraint(equalTo: bottomAnchor).activate()
        borderedView.heightAnchor.constraint(equalToConstant: npsHeight).activate()

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: progressViewMargins).activate()
        progressView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor, constant: -progressViewMargins).activate()
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: progressViewMargins).activate()
        progressView.layer.cornerRadius = (npsHeight - (2 * progressViewMargins)) / 2

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: borderedView.topAnchor).activate()
        contentStackView.leadingAnchor.constraint(equalTo: borderedView.leadingAnchor).activate()
        contentStackView.trailingAnchor.constraint(equalTo: borderedView.trailingAnchor).activate()
        contentStackView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor).activate()
        contentStackView.distribution = .fillEqually
        contentStackView.layoutMargins = UIEdgeInsets(top: 0, left: sideContentStackViewPadding, bottom: 0, right: sideContentStackViewPadding)
        contentStackView.isLayoutMarginsRelativeArrangement = true

        touchView.translatesAutoresizingMaskIntoConstraints = false
        touchView.topAnchor.constraint(equalTo: borderedView.topAnchor).activate()
        touchView.leadingAnchor.constraint(equalTo: borderedView.leadingAnchor).activate()
        touchView.trailingAnchor.constraint(equalTo: borderedView.trailingAnchor).activate()
        touchView.bottomAnchor.constraint(equalTo: borderedView.bottomAnchor).activate()
        
        toolTip.translatesAutoresizingMaskIntoConstraints = false
        toolTip.bottomAnchor.constraint(equalTo: topAnchor, constant: -10).activate()
        toolTip.widthAnchor.constraint(equalToConstant: 35).activate()
        toolTip.heightAnchor.constraint(equalToConstant: 46).activate()
        toolTipCenterXContraint = toolTip.centerXAnchor.constraint(equalTo: contentStackView.centerXAnchor).activate()
    }

    private func createLabels(inContentView stackView: UIStackView, count: Int) {
        var firstLabel: NPSLabel?

        for index in 0..<count {
            let label = NPSLabel()
            label.textAlignment = .center
            label.text = String(index)
            stackView.addArrangedSubview(label)

            if let firstLabel = firstLabel {
                label.widthAnchor.constraint(equalTo: firstLabel.widthAnchor).activate()
                continue
            }

            firstLabel = label
            label.widthAnchor.constraint(lessThanOrEqualToConstant: maximiumChoiceWidth).activate()
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumChoiceWidth).activate()
            label.topAnchor.constraint(equalTo: borderedView.topAnchor, constant: -4).activate()
        }

    }

    private func createCircleLable() {
        let label = NPSLabel()
        label.textAlignment = .center
        selectedLabel = label
        selectedLabel.isHidden = true

    }
    private func refreshSelection() {
        accessibilityValue = rating?.description
        accessibilityLabel = "Select a score"
        accessibilityTraits = UIAccessibilityTraitAdjustable

        if rating != nil {
            progressView.isHidden = false
        }

        for (index, label) in labels.enumerated() {
            label.isLower = index < selectedIndex
            label.isSelected = index == selectedIndex
        }

        moveTooltip(toIndex: selectedIndex)
        moveProgressBar(toIndex: selectedIndex)
        highlightSelectedLabel(atIndex: selectedIndex)
    }

    private func moveTooltip(toIndex index: Int) {
        guard index >= 0 && index < labels.count else {
            return
        }
        let choiceLabel = labels[index]
        toolTipCenterXContraint?.isActive = false
        toolTipCenterXContraint = toolTip.centerXAnchor.constraint(equalTo: choiceLabel.centerXAnchor).activate()
        toolTip.text = String(index)
        toolTip.layoutIfNeeded()
    }

    private func moveProgressBar(toIndex index: Int) {
        guard index >= 0 && index < labels.count else {
            return
        }
        let choiceLabel = labels[index]
        //let labelWidth: CGFloat = contentStackView.frame.width / CGFloat(numberOfValues)
        //Hide the progressbar under the circle-indication label
        let progressViewTrailingOffset: CGFloat = -12
        progressViewTrailingAnchor?.isActive = false
        progressViewTrailingAnchor = progressView.trailingAnchor.constraint(equalTo: choiceLabel.trailingAnchor, constant: progressViewTrailingOffset).activate()
    }

    private func highlightSelectedLabel(atIndex index: Int) {
        guard index >= 0 && index < labels.count else {
            return
        }
        let choiceLabel = labels[index]
        let choiceframe = choiceLabel.frame
        var selectedFrame = selectedLabel.frame
        selectedLabel.text = choiceLabel.text
        selectedFrame.origin = choiceframe.origin
        selectedFrame.size.width = choiceframe.size.height + 4
        selectedFrame.size.height = choiceframe.size.height + 4
        selectedLabel.frame = selectedFrame
        selectedLabel.center = choiceLabel.center
        selectedLabel.isHidden = false
        selectedLabel.isLower = true
    }

    // MARK: Haptic Feedback

    private func prepareHapticFeedback() {
        if #available(iOS 10.0, *) {
            feedbackGenerator = UISelectionFeedbackGenerator()
            (feedbackGenerator as? UISelectionFeedbackGenerator)?.prepare()
        }
    }

    private func submitHapticFeedback() {
        if #available(iOS 10.0, *) {
            (feedbackGenerator as? UISelectionFeedbackGenerator)?.selectionChanged()
        }
    }

    private func releaseHapticFeedback() {
        if #available(iOS 10.0, *) {
            feedbackGenerator = nil
        }
    }

    // MARK: Touch handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareHapticFeedback()
        initialTouchIndex = selectedIndex
        handleTouches(touches: touches, withEvent: event)
        UIView.animate(withDuration: transitionDuration) {
            self.toolTip.alpha = 1.0
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches: touches, withEvent: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: transitionDuration) {
            self.toolTip.alpha = 0.0
        }
        handleTouches(touches: touches, withEvent: event)
        if initialTouchIndex != selectedIndex {
            sendActions(for: .valueChanged)
        }
        releaseHapticFeedback()
    }

    private func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: contentStackView)
            let maxX = frame.width

            if position.x >= 0 && position.x < maxX {
                ratingButtonSelected(position: position)
            }
        }
    }

    private func frame(forLabel label: UIView, atIndex index: Int) -> CGRect {
        let vFrame = label.frame
        switch index {
        case 0:
            return CGRect(x: vFrame.origin.x - sideContentStackViewPadding, y: vFrame.origin.y, width: vFrame.width + sideContentStackViewPadding, height: vFrame.height)
        case numberOfValues - 1:
            return CGRect(x: vFrame.origin.x, y: vFrame.origin.y, width: vFrame.width + sideContentStackViewPadding, height: vFrame.height)
        default:
            return vFrame
        }
    }

    private func ratingButtonSelected(position: CGPoint) {
        var newIndex = selectedIndex
        for (index, label) in labels.enumerated() {
            let labelFrame = self.frame(forLabel: label, atIndex: index)
            if position.x >= labelFrame.minX && position.x < labelFrame.maxX {
                newIndex = index
                break
            }
        }
        guard newIndex != selectedIndex else {
            return
        }
        selectedIndex = newIndex

        submitHapticFeedback()
    }

    // MARK: Accessibility

    override func accessibilityElementCount() -> Int {
        return numberOfValues
    }

    override func accessibilityIncrement() {
        guard selectedIndex < numberOfValues - 1 else {
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
