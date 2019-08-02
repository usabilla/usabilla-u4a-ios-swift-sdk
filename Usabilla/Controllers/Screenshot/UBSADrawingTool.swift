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
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        case .marker:
            ctx.addPath(path)
            ctx.setLineCap(.round)
            ctx.setLineWidth(lineWidth)
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.setAlpha(lineAlpha)
            ctx.strokePath()
        }
    }
}

protocol PenToolViewDelegate: class {
    func selectedPenTool(penType: PenType)
}

struct PenToolConfig {
    static let inactiveMarker = UIImage.getImageFromSDKBundle(name: "marker_inactive")
    static let inactivePencil = UIImage.getImageFromSDKBundle(name: "pencil_inactive") as UIImage?
    static let activeMarker = UIImage.getImageFromSDKBundle(name: "marker_color") as UIImage?
    static let activePencil = UIImage.getImageFromSDKBundle(name: "pencil_color") as UIImage?
    static let activeOutlineMarker = UIImage.getImageFromSDKBundle(name: "marker_outline") as UIImage?
    static let activeOutlinePencil = UIImage.getImageFromSDKBundle(name: "pencil_outline") as UIImage?
    static let halfAlpha: CGFloat = 0.3
    static let widthPenBtn: CGFloat = 48.0
    static let heightPenBtn: CGFloat = 90.0
    static let marginLeftMarker: CGFloat = 0
    static let marginRightPencil: CGFloat = 0
    static let marginBottomMarker: CGFloat = DeviceInfo.hasTopNotch ? 34.0 : 34.0
    static let marginBottomPencil: CGFloat = DeviceInfo.hasTopNotch ? 34.0 : 34.0
}

class PenToolView: UIView {

    weak var delegate: PenToolViewDelegate?
    var selectedTool: PenType = PenType.marker
    var selectedColor: UIColor = .black
    var textColor: UIColor = .gray

    let marker: UIButton = {
        let image = PenToolConfig.inactiveMarker
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(markerClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let pencil: UIButton = {
        let image = PenToolConfig.inactivePencil
        let button = UIButton(type: .custom)
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
            guard let image = PenToolConfig.activeMarker?.maskWithColor(color: selectedColor)
                else { return }
            let bgImage = PenToolConfig.activeOutlineMarker?.maskWithColor(color: textColor)
            let image2 = bgImage?.withSelectedImage(image: image)
            marker.setImage(image2, for: .normal)
            let oldImage = PenToolConfig.inactivePencil?.alpha(value: PenToolConfig.halfAlpha)
            pencil.setImage(oldImage, for: .normal)
        case .pencil:
            guard let image = PenToolConfig.activePencil?.maskWithColor(color: selectedColor)
                else { return }
            let bgImage = PenToolConfig.activeOutlinePencil?.maskWithColor(color: textColor)
            let image2 = bgImage?.withSelectedImage(image: image)
            pencil.setImage(image2, for: .normal)
            let oldImage = PenToolConfig.inactiveMarker?.alpha(value: PenToolConfig.halfAlpha)
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

        NSLayoutConstraint.activate([
            marker.widthAnchor.constraint(equalToConstant: PenToolConfig.widthPenBtn),
            marker.heightAnchor.constraint(equalToConstant: PenToolConfig.heightPenBtn),
            marker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: PenToolConfig.marginLeftMarker),
            marker.bottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: PenToolConfig.marginBottomMarker),
            pencil.widthAnchor.constraint(equalToConstant: PenToolConfig.widthPenBtn),
            pencil.heightAnchor.constraint(equalToConstant: PenToolConfig.heightPenBtn),
            pencil.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: PenToolConfig.marginRightPencil),
            pencil.bottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: PenToolConfig.marginBottomPencil)
        ])
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
}
