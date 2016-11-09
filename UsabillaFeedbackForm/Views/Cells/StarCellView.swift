//
//  StarCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 09/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class StarCellView: RootCellView, SwiftStarDelegate {

    var starRatingView: StarRatingiView
    var starModel: StarFieldModel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        starRatingView = StarRatingiView()
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 1
        starRatingView.currentValue = 0
        starRatingView.tintColor = UIColor(colorLiteralRed: 239.0/255.0, green: 197.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        //starRatingView.allowsHalfStars = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        starRatingView.delegate = self



        self.contentView.addSubview(starRatingView)


        self.starRatingView.translatesAutoresizingMaskIntoConstraints = false



        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 0.9, constant: 0).isActive = true

        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true

        setNeedsLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        starModel = item as! StarFieldModel
        if let value = starModel.fieldValue {
            starRatingView.currentValue = value
        } else {
            starRatingView.currentValue = 0
            starModel.fieldValue = nil
        }
        starRatingView.backgroundColor = starModel.themeConfig.backgroundColor
        let theme = starModel.themeConfig
        if theme.fullStar != nil && theme.emptyStar != nil {
            starRatingView.filledStarImage = theme.fullStar
            starRatingView.emptyStarImage = theme.emptyStar
        }
    }


    func starValueChanged(_ value: Int) {
        starModel.fieldValue = value
    }

//    deinit {
//        print("Star  cell deinit")
//    }

}
