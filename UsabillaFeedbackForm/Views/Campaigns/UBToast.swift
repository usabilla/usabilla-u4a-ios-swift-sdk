//
//  UBToast.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 08/06/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBToast: UIView {

    let margin: CGFloat = 18

    var label: UILabel!
    var text: String! {
        didSet {
            label.text = text
        }
    }

    weak var delegate: UIViewController!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(delegate: UIViewController) {
        super.init(frame: .zero)
        self.delegate = delegate
        label = UILabel()
        label.text = text
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.topAnchor.constraint(equalTo: topAnchor, constant: margin).activate()
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).activate()
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).activate()
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).activate()

        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 14
        layer.masksToBounds = true
    }

    @discardableResult func show() -> UBToast {

        delegate.view.addSubview(self)
        // setup toast layout in parent view
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: delegate.view.leftAnchor, constant: margin).activate()
        rightAnchor.constraint(equalTo: delegate.view.rightAnchor, constant: -margin).activate()
        bottomAnchor.constraint(equalTo: delegate.view.bottomAnchor, constant: -margin).activate()

        return self
    }

    func dismiss(delay: Int = 2, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.removeFromSuperview()
            if completion != nil {
                completion!()
            }
        }
    }
}
