//
//  UBToast.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 08/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBToast: UIView {

    private let opacity: CGFloat = 0.6
    private let margin: CGFloat = 18
    var duration: Int = 2

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

    init(delegate: UIViewController, text: String? = nil, duration: Int = 2) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.duration = duration
        self.text = text

        label = UILabel()
        label.text = text
        label.textColor = toastTextColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: margin).activate()
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).activate()
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).activate()
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).activate()

        backgroundColor = toastBackgroundColor.withAlphaComponent(opacity)
        layer.cornerRadius = 14
        layer.masksToBounds = true
    }

    func show(completion: (() -> Void)?) {
        delegate.view.addSubview(self)
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: delegate.view.centerXAnchor).activate()
        widthAnchor.constraint(lessThanOrEqualTo: delegate.view.widthAnchor, constant: -2 * margin).activate()
        bottomAnchor.constraint(equalTo: delegate.view.bottomAnchor, constant: -margin).activate()

        UIView.animate(withDuration: 0.33, delay: 0.5, options: .curveEaseOut, animations: {
            self.alpha = 1
        }, completion: nil)

        dismiss(completion: completion)
    }

    private func dismiss(completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(self.duration)) {
            UIView.animate(withDuration: 0.8, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
                if completion != nil {
                    completion!()
                }
            })
        }
    }
}
