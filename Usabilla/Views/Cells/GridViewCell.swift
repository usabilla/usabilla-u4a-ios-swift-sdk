/*
	Copyright (C) 2017 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	Collection view cell for displaying an asset.
 */

import UIKit

class GridViewCell: UICollectionViewCell {

    lazy var imageView: UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var representedAssetIdentifier: String = "GridViewCell"

    func setupView() {
        // add subviews
        contentView.addSubview(imageView)

        // design
        backgroundColor = .clear
        contentView.backgroundColor = .white
        imageView.backgroundColor = .white
    }
    func setupConstraints() {
        // imageview
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UBDimensions.GridCell.imageLeftSideMargin).activate()
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UBDimensions.GridCell.imageRightSideMargin).activate()
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UBDimensions.GridCell.imageTopMargin).activate()
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UBDimensions.GridCell.imageBottomMargin).activate()
    }

    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
