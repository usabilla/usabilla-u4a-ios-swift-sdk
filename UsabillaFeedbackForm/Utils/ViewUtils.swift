//
//  ViewUtils.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 03/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation


class ViewUtils {

    public static func generateFooter(themeConfig: UsabillaThemeConfigurator) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let logo = UIButton(type: UIButtonType.custom)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.addTarget(self, action: #selector(PageController.openUsabilla), for: .touchUpInside)
        logo.setImage(Icons.imageOfPoweredBy(color: themeConfig.accentColor), for: UIControlState())
        view.addSubview(logo)
        NSLayoutConstraint(item: logo, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: logo, attribute: .height, multiplier: 1, constant: 0).isActive = true
        return view
    }
    
    
    
    public static func addConstraintToFillContainerView(innerview: UIView, outerview: UIView, withMargin: CGFloat = 0) {
        NSLayoutConstraint(item: innerview, attribute: .bottom, relatedBy: .equal, toItem: outerview, attribute: .bottom, multiplier: 1, constant: -withMargin).isActive = true
        NSLayoutConstraint(item: innerview, attribute: .top, relatedBy: .equal, toItem: outerview, attribute: .top, multiplier: 1, constant: withMargin).isActive = true
        NSLayoutConstraint(item: innerview, attribute: .leading, relatedBy: .equal, toItem: outerview, attribute: .leading, multiplier: 1, constant: withMargin).isActive = true
        NSLayoutConstraint(item: innerview, attribute: .trailing, relatedBy: .equal, toItem: outerview, attribute: .trailing, multiplier: 1, constant: -withMargin).isActive = true
    }

    
    
}
