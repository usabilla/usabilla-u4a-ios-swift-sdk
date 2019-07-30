//
//  UBSADrawingTool.swift
//  Usabilla
//
//  Created by Hitesh Jain on 24/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

protocol UBSADrawingTool {
    var lineWidth: CGFloat { get set }
    var lineColor: UIColor { get set }
    var lineAlpha: CGFloat { get set }

    func setInitialPoint(_ firstPoint: CGPoint)
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint)
    func draw()
}

enum PenType {
    case marker
    case pencil
}

enum PenStrokeWidth: CGFloat {
    case marker = 12.0
    case pencil = 4.0
}

class PenTool: UIBezierPath, UBSADrawingTool {
    var path: CGMutablePath
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var drawingPenType: PenType

    override init() {
        path = CGMutablePath.init()
        lineColor = .black
        lineAlpha = 0
        drawingPenType = .marker
        super.init()
        lineCapStyle = CGLineCap.round
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInitialPoint(_ firstPoint: CGPoint) {}

    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}

    func createBezierRenderingBox(_ previousPoint2: CGPoint, widhPreviousPoint previousPoint1: CGPoint, withCurrentPoint cpoint: CGPoint) -> CGRect {
        let mid1 = middlePoint(previousPoint1, previousPoint2: previousPoint2)
        let mid2 = middlePoint(cpoint, previousPoint2: previousPoint1)
        let subpath = CGMutablePath.init()

        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint1.x, y: previousPoint1.y))
        path.addPath(subpath)

        var boundingBox: CGRect = subpath.boundingBox
        boundingBox.origin.x -= lineWidth * 2.0
        boundingBox.origin.y -= lineWidth * 2.0
        boundingBox.size.width += lineWidth * 4.0
        boundingBox.size.height += lineWidth * 4.0

        return boundingBox
    }

    private func middlePoint(_ previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPoint {
        return CGPoint(x: (previousPoint1.x + previousPoint2.x) * 0.5, y: (previousPoint1.y + previousPoint2.y) * 0.5)
    }

    func draw() {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        switch drawingPenType {
        case .pencil:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setBlendMode(.normal)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        case .marker:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setBlendMode(.screen)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        }
    }
}

protocol PenToolViewDelegate: class {
    func selectedPenTool(penType: PenType)
}

struct PenToolConfig {
    static let inactiveMarker = UIImage(named: "marker_inactive") as UIImage?
    static let inactivePencil = UIImage(named: "pencil_inactive") as UIImage?
    static let activeMarker = UIImage(named: "marker_color") as UIImage?
    static let activePencil = UIImage(named: "pencil_color") as UIImage?
    static let activeOutlineMarker = UIImage(named: "marker_outline") as UIImage?
    static let activeOutlinePencil = UIImage(named: "pencil_outline") as UIImage?
    static let halfAlpha: CGFloat = 0.5
}

class PenToolView: UIView {

    weak var delegate: PenToolViewDelegate?
    var selectedTool: PenType = PenType.marker
    var selectedColor: UIColor = .black
    var textColor: UIColor = .gray

    let marker: UIButton = {
        let image = PenToolConfig.inactiveMarker
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(markerClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let pencil: UIButton = {
        let image = PenToolConfig.inactivePencil
        let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pencilClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func markerClicked() {
        selectedTool = PenType.marker
        self.togglePenType (penType: PenType.marker)
        delegate?.selectedPenTool(penType: PenType.marker)
    }

    @objc func pencilClicked() {
        selectedTool = PenType.pencil
        self.togglePenType (penType: PenType.pencil)
        delegate?.selectedPenTool(penType: PenType.pencil)
    }

    func togglePenType (penType: PenType) {
        switch penType {
        case .marker:
            guard let image = PenToolConfig.activeMarker?.withSelectedColor(color: selectedColor)
                else { return }
            let bgImage = PenToolConfig.activeOutlineMarker?.withSelectedColor(color: textColor)
            let image2 = bgImage?.withSelectedImage(image: image)
            marker.setImage(image2, for: .normal)
            let oldImage = PenToolConfig.inactivePencil?.alpha(PenToolConfig.halfAlpha)
            pencil.setImage(oldImage, for: .normal)
        case .pencil:
            guard let image = PenToolConfig.activePencil?.withSelectedColor(color: selectedColor)
                else { return }
            let bgImage = PenToolConfig.activeOutlinePencil?.withSelectedColor(color: textColor)
            let image2 = bgImage?.withSelectedImage(image: image)
            pencil.setImage(image2, for: .normal)
            let oldImage = PenToolConfig.inactiveMarker?.alpha(PenToolConfig.halfAlpha)
            marker.setImage(oldImage, for: .normal)
        }
    }

    func togglePenColor(penColor: UIColor) {
        selectedColor = penColor
        self.togglePenType (penType: selectedTool)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForInitial()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareForInitial()
    }

    private func prepareForInitial() {
        backgroundColor = .clear

        self.addSubview(marker)
        self.addSubview(pencil)

        self.addConstraint(NSLayoutConstraint(item: marker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: marker, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: marker, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: marker, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -40))

        self.addConstraint(NSLayoutConstraint(item: pencil, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pencil, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 40))
        self.addConstraint(NSLayoutConstraint(item: pencil, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pencil, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
    }
}

extension UIImage {
    func withSelectedImage(image: UIImage, posX: CGFloat = 0.0, posY: CGFloat = 0.0) -> UIImage {
        let newWidth = posX < 0 ? abs(posX) + max(self.size.width, image.size.width) :
            size.width < posX + image.size.width ? posX + image.size.width : size.width
        let newHeight = posY < 0 ? abs(posY) + max(size.height, image.size.height) :
            size.height < posY + image.size.height ? posY + image.size.height : size.height
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let originalPoint = CGPoint(x: posX < 0 ? abs(posX) : 0, y: posY < 0 ? abs(posY) : 0)
        self.draw(in: CGRect(origin: originalPoint, size: self.size))
        let overLayPoint = CGPoint(x: posX < 0 ? 0 : posX, y: posY < 0 ? 0 : posY)
        image.draw(in: CGRect(origin: overLayPoint, size: image.size))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage()}
        UIGraphicsEndImageContext()

        return newImage
    }

    func withSelectedColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        self.draw(in: rect)
        context?.setBlendMode(.sourceIn)
        context?.fill(rect)
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return resultImage
    }

    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return resultImage
    }
}
