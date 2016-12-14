//
//  MoodCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 09/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class MoodCellView: RootCellView, IntFieldHandlerProtocol {

    var fieldValue: Int = 0 {
        didSet {
            moodModel.fieldValue = self.fieldValue
        }
    }
    var moodModel: MoodFieldModel!
    var buttonView: MoodContentController? = nil



    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buttonView = MoodContentController()
        buttonView!.delegate = self
        buttonView!.translatesAutoresizingMaskIntoConstraints = false

        rootCellContainerView.addSubview(buttonView!)

        let f = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)

        NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
        
        let z = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.rootCellContainerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)

        contentView.addConstraints([f, z])


        setNeedsLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        moodModel = item as! MoodFieldModel
        buttonView?.themeConfig = item.themeConfig

        //buttonView?.setNumberOfItems(moodModel.points)
        if moodModel.fieldValue == nil {
            buttonView?.resetSelected()
        } else {
            buttonView?.setSelected(moodModel.fieldValue!)
        }

    }

//    deinit {
//        print("mood cell deinit")
//    }
}
