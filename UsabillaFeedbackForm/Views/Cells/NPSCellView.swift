//
//  NPSCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class NPSCellView: RootCellView, IntFieldHandlerProtocol {


    var fieldValue: Int = 0 {
        didSet {
            npsModel?.fieldValue = self.fieldValue
        }
    }
    var npsModel: NPSFieldModel!
    var buttonView: NPSContentController?


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buttonView?.removeFromSuperview()
        buttonView = NPSContentController()
        buttonView!.delegate = self
        self.contentView.addSubview(buttonView!)
        buttonView!.translatesAutoresizingMaskIntoConstraints = false

        let f = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.titleLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 8)

        let a = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)

        let v = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 0.9, constant: 0)

        let z = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: 8)

        contentView.addConstraints([f, a, v, z])

        setNeedsLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setFeedbackItem(_ item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        guard let item = item as? NPSFieldModel else {
            return
        }
        npsModel = item
        buttonView?.themeConfig = item.themeConfig

        if let value = npsModel.fieldValue {
            buttonView?.selectButton(value)
        } else {
            buttonView?.resetButtons()
        }

    }



//    deinit {
//        print("NPS cell deinit")
//    }
}
