//
//  StarCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 09/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import HCSStarRatingView

class StarCellView: RootCellView {
    
    var starRatingView: HCSStarRatingView
    var starModel: StarFieldModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        starRatingView = HCSStarRatingView()
        starRatingView.maximumValue = 5
        starRatingView.minimumValue = 1
        starRatingView.value = 0
        starRatingView.tintColor = UIColor(colorLiteralRed: 239.0/255.0, green: 197.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        starRatingView.allowsHalfStars = false
        starRatingView.backgroundColor = UsabillaThemeConfigurator.sharedInstance.backgroundColor
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let theme = UsabillaThemeConfigurator.sharedInstance
        if theme.fullStar != nil && theme.emptyStar != nil {
            starRatingView.filledStarImage = theme.fullStar
            starRatingView.emptyStarImage = theme.emptyStar
        }
        starRatingView.addTarget(self, action: #selector(StarCellView.barChangedValue), forControlEvents: UIControlEvents.ValueChanged)

        self.contentView.addSubview(starRatingView)
        
        
        self.starRatingView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0).active = true
        
        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        
        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0).active = true
        
        NSLayoutConstraint(item: starRatingView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0).active = true
        
        setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        starModel = item as! StarFieldModel
        if starModel.fieldValue != nil {
            starRatingView.value = CGFloat(starModel.fieldValue!)
        }
      
    }
    
    
    func barChangedValue() {
        starModel.fieldValue = Int(starRatingView.value)
    }
}
