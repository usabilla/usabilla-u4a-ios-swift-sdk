//
//  UBSADragableImageView.swift
//  Usabilla
//
//  Created by Anders Liebl on 26/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//
//  This UIImageView implements a Pan Gesture recognizer.  If a delegate has been set
//  movedSubview and draggingSubview protocols will be called
//  The view will follow the drag, and update its location in it parrent view, regardless of
//  the delegate is set. 

import UIKit
protocol UBSADragableImageViewProtocol: class {
    func startedTouchedSubView(_ subview: UBSADragableImageView)
    func endedTouchedSubView(_ subview: UBSADragableImageView)

    func movedSubview(_ subview: UBSADragableImageView, center: CGPoint)
    func draggingSubview(_ subview: UBSADragableImageView, center: CGPoint)
}

class UBSADragableImageView: UIImageView {
    weak var delegate: UBSADragableImageViewProtocol?

    fileprivate var lastLocation = CGPoint(x: 0, y: 0)
    override init(image: UIImage?) {
        super.init(image: image)
        configurePan()
        isUserInteractionEnabled = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePan()
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func configurePan() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(UBSADragableImageView.detectPan(_: )))
        gestureRecognizers = [panRecognizer]
    }

    @objc func detectPan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            delegate?.movedSubview(self, center: center)
            return
        }

        let translation  = recognizer.translation(in: self.superview)
        center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
        delegate?.draggingSubview(self, center: center)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastLocation = center
        delegate?.startedTouchedSubView(self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.endedTouchedSubView(self)
    }
}
