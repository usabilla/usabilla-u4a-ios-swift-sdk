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
        // Setup
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        self.backgroundColor = UIColor.clear

        let logo = UIButton(type: UIButtonType.custom)
        logo.addTarget(PageViewController.self, action: #selector(PageViewController.openUsabilla), for: .touchUpInside)
        logo.setImage(Icons.imageOfPoweredBy(color: theme.colors.hint), for: UIControlState())
        logo.accessibilityIdentifier = "powered-by-id"
        if !UsabillaInternal.setFooterLogoClickable {
            logo.isUserInteractionEnabled = UsabillaInternal.setFooterLogoClickable
        }
        self.addSubview(logo)

        // Layout
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logo.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        // Accessibility
        logo.accessibilityLabel = LocalisationHandler.getLocalisedStringForKey("usa_powered_by_usabilla")
        logo.accessibilityHint = LocalisationHandler.getLocalisedStringForKey("usa_tap_to_visit_usabilla")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
