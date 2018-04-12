//
//  PoweredByUsabillaView.swift
//  Usabilla
//
//  Created by Adil Bougamza on 12/04/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class PoweredByUsabillaView: UIView {

    init(theme: UsabillaTheme) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        self.backgroundColor = UIColor.clear

        let logo = UIButton(type: UIButtonType.custom)
        logo.addTarget(PageViewController.self, action: #selector(PageViewController.openUsabilla), for: .touchUpInside)
        logo.setImage(Icons.imageOfPoweredBy(color: theme.colors.text.withAlphaComponent(0.5)), for: UIControlState())
        logo.accessibilityIdentifier = "powered-by-id"
        self.addSubview(logo)

        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logo.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
