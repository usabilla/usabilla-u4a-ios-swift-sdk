//
//  CardView.swift
//  Usabilla
//
//  Created by Anders Liebl on 12/11/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class GFPCardView: UIView {
    
    lazy var cardStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        //stack.backgroundColor = .systemTeal
        //stack.layoutMargins = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        stack.isLayoutMarginsRelativeArrangement = true
        //stack.spacing = UIStackView.spacingUseSystem
        stack.spacing = 20.0
        stack.distribution = .equalSpacing
        stack.distribution = .fill
        return stack
    }()

    required init() {
        super.init(frame: CGRect.zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - setup
    private func configureViews() {
        layer.cornerRadius = 10
        clipsToBounds = true
        addSubview(cardStackView)
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        cardStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        cardStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -0).isActive = true
        cardStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        cardStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }

    func addSubviewToStack(_ view: UIView) {
        cardStackView.addArrangedSubview(view)
    }
    
}
