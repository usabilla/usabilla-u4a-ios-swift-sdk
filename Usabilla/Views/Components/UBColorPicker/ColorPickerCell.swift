//
//  ColorPickerCell.swift
//  Usabilla
//
//  Created by Hitesh Jain on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

struct ColorPickerCellValues {
    static let width: CGFloat = 18.0
    static let height: CGFloat = width
    static let radius: CGFloat = width / 2
    static let borderWidth: CGFloat = 1.0
}

class ColorPickerCell: UICollectionViewCell {
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        colorView.layer.masksToBounds = false
        colorView.layer.cornerRadius = ColorPickerCellValues.radius
        colorView.layer.borderWidth = ColorPickerCellValues.borderWidth
    }

    func addViews() {
        addSubview(colorView)
        colorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: ColorPickerCellValues.width).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: ColorPickerCellValues.height).isActive = true
    }
}
