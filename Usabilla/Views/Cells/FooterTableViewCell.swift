//
//  FooterTableViewCell.swift
//  Usabilla
//
//  Created by Benjamin Grima on 11/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    var footerView: UIView? {
        didSet {
            if let footerView = footerView, contentView.subviews.count == 0 {
                selectionStyle = .none
                contentView.addSubview(footerView)
                footerView.translatesAutoresizingMaskIntoConstraints = false
                footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                footerView.heightAnchor.constraint(equalToConstant: footerHeight)
                footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
            }
        }
    }
}
