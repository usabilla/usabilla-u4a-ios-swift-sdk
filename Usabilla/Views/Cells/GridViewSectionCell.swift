//
//  GridViewSectionCell.swift
//  Usabilla
//
//  Created by Anders Liebl on 16/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit
class  GridViewSectionCell: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView() {
        // add subviews
        addSubview(titleLabel)

        // design
        backgroundColor = .white
        titleLabel.textColor = .black

    }

    func setupConstraints() {
        // titleLabel
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UBDimensions.GridHeaderCell.titleLeftSideMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UBDimensions.GridHeaderCell.titleRightSideMargin).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UBDimensions.GridHeaderCell.titleBottomMargin).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: UBDimensions.GridHeaderCell.titleHeigth)
        // subTitleLabel
    }
}
