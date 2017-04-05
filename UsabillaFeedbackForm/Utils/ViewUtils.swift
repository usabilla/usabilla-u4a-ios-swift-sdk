//
//  ViewUtils.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 03/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class ViewUtils {

    public static func generateFooter(theme: UsabillaTheme) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let logo = UIButton(type: UIButtonType.custom)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.addTarget(PageController.self, action: #selector(PageController.openUsabilla), for: .touchUpInside)
        logo.setImage(Icons.imageOfPoweredBy(color: theme.textColor.withAlphaComponent(0.5)), for: UIControlState())
        view.backgroundColor = theme.backgroundColor
        view.addSubview(logo)

        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return view
    }

}
