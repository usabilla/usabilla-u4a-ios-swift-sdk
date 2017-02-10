//
//  RatingControl.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 12/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

enum RatingMode {
    case rating
    case selection
}

class RatingControl: UIControl {

    private let contentView = UIStackView()
    private var selectedIndex = -1

    private let size: CGFloat = 60
    private let spacing: CGFloat = 23

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

    var mode: RatingMode = .rating {
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
        addSubview(contentView)

        contentView.isUserInteractionEnabled = false
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
        if mode == .rating {
            if selected {
                return selectedImages?.first ?? getStar()
            } else {
                return unselectedImages?.first ?? getEmptyStar()
            }
        } else {
            if selected {
                return selectedImages?[index]
            } else {
                return unselectedImages?[index]
            }
        }
    }

    private func getStar() -> UIImage {
        return drawAccurateHalfStarShapeWithFrame(CGRect(x: 0, y: 0, width: 60, height: 60), tintColor: tintColor, progress: 1)
    }

    private func getEmptyStar() -> UIImage {
        return drawAccurateHalfStarShapeWithFrame(CGRect(x: 0, y: 0, width: 60, height: 60), tintColor: tintColor, progress: 0)
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

            button.imageView?.contentMode = .scaleAspectFit
            let selected = imageForButton(i, selected: true)
            let unselected = imageForButton(i, selected: false) ?? selected?.alpha(value: 0.4)
            button.setImage(unselected, for: .normal)
            button.setImage(selected, for: .selected)
            button.isUserInteractionEnabled = false
            contentView.addArrangedSubview(button)

            if !centered {
                button.setContentHuggingPriority(999, for: .horizontal)
                if let prev = prevbutton {
                    button.widthAnchor.constraint(equalTo: prev.widthAnchor).isActive = true
                } else {
                    prevbutton = button
                }
            }
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
        for (index, s) in contentView.arrangedSubviews.enumerated() {
            (s as? UIButton)?.isSelected = (mode == RatingMode.rating) ? index <= selectedIndex: index == selectedIndex
        }
    }

    private func drawAccurateHalfStarShapeWithFrame(_ frame: CGRect, tintColor: UIColor, progress: CGFloat) -> UIImage {
        let starShapePath = UIBezierPath()
        starShapePath.move(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.02500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.37292 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.02500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.30504 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.20642 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.78265 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.79358 * frame.width, y: frame.minY + 0.97500 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.69501 * frame.width, y: frame.minY + 0.62908 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.97500 * frame.width, y: frame.minY + 0.39112 * frame.height))
        starShapePath.addLine(to: CGPoint(x: frame.minX + 0.62723 * frame.width, y: frame.minY + 0.37309 * frame.height))
        starShapePath.close()
        starShapePath.miterLimit = 4
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)

        let frameWidth = frame.size.width
        let rightRectOfStar = CGRect(x: frame.origin.x + progress * frameWidth, y: frame.origin.y, width: frameWidth - progress * frameWidth, height: frame.size.height)
        let clipPath = UIBezierPath.init(rect: CGRect.infinite)// [UIBezierPath bezierPathWithRect:CGRectInfinite];
        clipPath.append(UIBezierPath(rect: rightRectOfStar))

        clipPath.usesEvenOddFillRule = true

        UIGraphicsGetCurrentContext()!.saveGState()
        clipPath.addClip()
        tintColor.setFill()
        starShapePath.fill()

        UIGraphicsGetCurrentContext()!.restoreGState()

        tintColor.setStroke()
        starShapePath.lineWidth = 1
        starShapePath.stroke()

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image!
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches: touches, withEvent: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches: touches, withEvent: event)
    }

    private func handleStarTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
        sendActions(for: .valueChanged)
        refreshSelection()

    }
}
