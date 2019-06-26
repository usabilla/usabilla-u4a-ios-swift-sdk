//
//  UBToast.swift
//  Usabilla
//
//  Created by Adil Bougamza on 08/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class UBToast: UIView {

    private let opacity: CGFloat = UBDimensions.Toast.opacity
    private let margin: CGFloat = UBDimensions.Toast.margin
    private var widthConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?

    var duration: Int = UBDimensions.Toast.duration

    var label: UILabel!
    var text: String! {
        didSet {
            label.text = text
        }
    }
    var toastBackgroundColor: UIColor = UIColor.black {
        didSet {
            backgroundColor = toastBackgroundColor.withAlphaComponent(opacity)
        }
    }
    var toastTextColor: UIColor = UIColor.white {
        didSet {
            label.textColor = toastTextColor
        }
    }

    weak var delegate: UIViewController!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(delegate: UIViewController, text: String? = nil, duration: UBToastDuration = .normal) {
        super.init(frame: .zero)
        self.accessibilityIdentifier = "toast"
        self.delegate = delegate
        self.duration = duration.rawValue
        self.text = text

        label = UILabel()
        label.text = text
        label.textColor = toastTextColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = UBDimensions.Toast.labelNOL
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: UBDimensions.Toast.labelFont).getDynamicTypeFont()
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: margin).activate()
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).activate()
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).activate()
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).activate()

        backgroundColor = toastBackgroundColor.withAlphaComponent(opacity)
        layer.cornerRadius = UBDimensions.Toast.cornerRadius
        layer.masksToBounds = true
    }

    func show(position: IntroPageDisplayMode = .bannerBottom, completion: (() -> Void)?) {
        delegate.view.addSubview(self)
        alpha = UBAlpha.zeroAlpha.rawValue
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor).activate()
        widthConstraint = widthAnchor.constraint(lessThanOrEqualTo: delegate.view.widthAnchor).activate()

        bottomConstraint = bottomAnchor.constraint(equalTo: delegate.view.bottomAnchor).activate()
        topConstraint?.isActive = false
        if position == .bannerTop {
            topConstraint = topAnchor.constraint(equalTo: delegate.view.topAnchor, constant: DeviceInfo.topMargin).activate()
            bottomConstraint?.isActive = false

        }

        UIView.animate(withDuration: UBDimensions.Toast.animateDuration, delay: UBDimensions.Toast.animateDelay, options: .curveEaseOut, animations: {
            self.alpha = UBAlpha.fullAlpha.rawValue
        }, completion: nil)

        dismiss(completion: completion)
    }

    private func dismiss(completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(self.duration)) {
            UIView.animate(withDuration: UBDimensions.Toast.animateDurationDismiss, animations: {
                self.alpha = UBAlpha.zeroAlpha.rawValue
            }, completion: { _ in
                self.removeFromSuperview()
                completion?()
            })
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        widthConstraint?.constant = -(UBDimensions.Toast.widthConstraintWRTMargin * margin) - UIView.safeAreaEdgeInsets.left - UIView.safeAreaEdgeInsets.right
        bottomConstraint?.constant = -margin - UIView.safeAreaEdgeInsets.bottom
    }
}
