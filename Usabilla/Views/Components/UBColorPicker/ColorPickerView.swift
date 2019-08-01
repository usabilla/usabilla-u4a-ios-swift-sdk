//
//  ColorPickerView.swift
//  Usabilla
//
//  Created by Hitesh Jain on 23/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

struct ColorPickerValues {

    static let green: UIColor = UIColor(red: 0.32, green: 0.84, blue: 0.65, alpha: 1)
    static let red: UIColor = UIColor(red: 0.93, green: 0.29, blue: 0.35, alpha: 1)
    static let colorsArray: [UIColor] =  [UIColor.white, UIColor.black, red, green]
    static let externalBorderColor: UIColor = UIColor(red: 0.34, green: 0.38, blue: 0.42, alpha: 1)
    static let borderColor: CGColor = externalBorderColor.withAlphaComponent(0.5).cgColor
    static let clearColor: CGColor = UIColor.clear.cgColor
    static let cellSize: CGSize = CGSize(width: 48, height: 48)
    static let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    static let minimumLineSpacingForSectionAt: CGFloat = 0
    static let minimumInteritemSpacingForSectionAt: CGFloat = 0
    static let marginLeftCVColorPicker: CGFloat = 0
    static let marginRightCVColorPicker: CGFloat = 0
    static let marginCenterCVColorPicker: CGFloat = DeviceInfo.hasTopNotch ? 0.0 : 0.0
    static let heightCVColorPicker: CGFloat = 48.0
}

class ColorPickerView: UIView {

    /// Array of UIColor you want to show in the color picker
    var colors: [UIColor] = ColorPickerValues.colorsArray {
        didSet {
            if colors.isEmpty {
                fatalError("ERROR ColorPickerView - You must set at least 1 color!")
            }
        }
    }

    /// The object that acts as the layout delegate for the color picker
    weak var layoutDelegate: ColorPickerViewDelegateFlowLayout?
    /// The object that acts as the delegate for the color picker
    weak var delegate: ColorPickerViewDelegate?
    /// The index of the selected color in the color picker
    var indexOfSelectedColor: Int? {
        return _indexOfSelectedColor
    }

    fileprivate var _indexOfSelectedColor: Int?
    fileprivate lazy var collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorPickerCell.self, forCellWithReuseIdentifier: "ColorPickerCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForInitial()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareForInitial()
    }

    private func prepareForInitial() {
        backgroundColor = UIColor.clear
    }

    // MARK: - View management
    override func layoutSubviews() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: ColorPickerValues.marginCenterCVColorPicker),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ColorPickerValues.marginLeftCVColorPicker),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: ColorPickerValues.marginRightCVColorPicker),
            collectionView.heightAnchor.constraint(equalToConstant: ColorPickerValues.heightCVColorPicker)
        ])
    }

    // MARK: - Private Methods
    private func _selectColor(at indexPath: IndexPath, animated: Bool) {

        guard let colorPickerCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else { return }
        UIView.animate(withDuration: 0.2,
                       animations: {
                        colorPickerCell.colorView.layer.borderColor = UIColor.white.cgColor
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            _ = colorPickerCell.colorView.addExternalBorder(borderColor: ColorPickerValues.externalBorderColor)
                        }
        })

        _indexOfSelectedColor = indexPath.item
        let color = colors[indexPath.item]
        delegate?.colorPockerView(self, didSelectColor: color)
    }

    // MARK: - Public Methods
    func selectColor(at index: Int, animated: Bool) {
        if index < colors.count {
            let indexPath = IndexPath(item: index, section: 0)
            DispatchQueue.main.async {
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                self.collectionView(self.collectionView, didSelectItemAt: indexPath)
            }
        }
    }
}

extension ColorPickerView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colorPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorPickerCell", for: indexPath)
        guard let cell: ColorPickerCell = colorPickerCell as? ColorPickerCell else { return colorPickerCell}
        cell.colorView.backgroundColor = colors[indexPath.item]
        return cell
    }
}

extension ColorPickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self._selectColor(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let oldColorCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else {
            return
        }
        oldColorCell.colorView.removeExternalBorders()
        oldColorCell.colorView.layer.borderColor = ColorPickerValues.borderColor
        delegate?.colorPickerView?(self, didDeselectItemAt: indexPath)
    }
}

extension ColorPickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layoutDelegate = layoutDelegate,
            let sizeForItemAt = layoutDelegate.colorPickerView?(self, sizeForItemAt: indexPath) {
            return sizeForItemAt
        }
        return ColorPickerValues.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumLineSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumLineSpacingForSectionAt: section) {
            return minimumLineSpacingForSectionAt
        }
        return ColorPickerValues.minimumLineSpacingForSectionAt
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumInteritemSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumInteritemSpacingForSectionAt: section) {
            return minimumInteritemSpacingForSectionAt
        }
        return ColorPickerValues.minimumInteritemSpacingForSectionAt
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let layoutDelegate = layoutDelegate, let insetForSectionAt = layoutDelegate.colorPickerView?(self, insetForSectionAt: section) {
            return insetForSectionAt
        }
        return ColorPickerValues.insets
    }
}

extension UIView {
    struct Constants {
        static let ExternalBorderName = "externalBorder"
    }

    func addExternalBorder(borderWidth: CGFloat = 2.0, borderColor: UIColor = UIColor.white) -> CALayer {
        let externalBorder = CALayer()
        let frameWidth = frame.size.width
        externalBorder.frame = CGRect(x: -borderWidth, y: -borderWidth, width: frameWidth + 2 * borderWidth, height: frame.size.height + 2 * borderWidth)
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = Constants.ExternalBorderName
        let cornerRadius: CGFloat = frameWidth / 2 + borderWidth
        externalBorder.cornerRadius = cornerRadius
        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false

        return externalBorder
    }

    func removeExternalBorders() {
        layer.sublayers?.filter { $0.name == Constants.ExternalBorderName }.forEach {
            $0.removeFromSuperlayer()
        }
    }

    func removeExternalBorder(externalBorder: CALayer) {
        guard externalBorder.name == Constants.ExternalBorderName else { return }
        externalBorder.removeFromSuperlayer()
    }

}
