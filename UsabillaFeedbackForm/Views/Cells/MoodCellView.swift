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
        self.contentView.addSubview(buttonView!)
        buttonView!.translatesAutoresizingMaskIntoConstraints = false

        let f = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 24)

        let a = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)

        let v = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 0.9, constant: 0)

        let z = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 2)

        contentView.addConstraints([f, a, v, z])


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
