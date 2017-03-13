//
//  StarCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 09/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class StarCellView: RootCellView {

    var ratingControl: RatingControl
    var starModel: StarFieldModel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        ratingControl = RatingControl()
        ratingControl.mode = .rating
        ratingControl.maxValue = 5
        ratingControl.tintColor = UIColor(colorLiteralRed: 239.0/255.0, green: 197.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        ratingControl.addTarget(self, action: #selector(StarCellView.pickRating(sender:)), for: [.valueChanged])

        self.contentView.addSubview(ratingControl)

        self.ratingControl.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintToFillContainerView(view: ratingControl)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? StarFieldModel else {
            return
        }
        starModel = item
        if let value = starModel.fieldValue {
            ratingControl.rating = value
        } else {
            ratingControl.rating = 0
            starModel.fieldValue = nil
        }
        ratingControl.backgroundColor = starModel.themeConfig.backgroundColor
        let theme = starModel.themeConfig
        if theme.fullStar != nil && theme.emptyStar != nil {
            if let fullStar = theme.fullStar {
                ratingControl.selectedImages = [fullStar]
            }
            if let emptyStar = theme.emptyStar {
                ratingControl.unselectedImages = [emptyStar]
            }
        }
    }


    func pickRating(sender: RatingControl) {
        starModel.fieldValue = sender.rating
    }

//    deinit {
//        print("Star  cell deinit")
//    }

}
