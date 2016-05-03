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
    var buttonView: NPSContentController? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.buttonView?.removeFromSuperview()
        buttonView = NPSContentController()
        buttonView!.delegate = self
        self.contentView.addSubview(buttonView!)
        buttonView!.translatesAutoresizingMaskIntoConstraints = false
        
        let f = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.dividerLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8)
        
        let a = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        
        let v = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0.9, constant: 0)
        
        let z = NSLayoutConstraint(item: buttonView!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1, constant: 8)
        
        contentView.addConstraints([f, a, v, z])
        
        setNeedsLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        npsModel = item as! NPSFieldModel

        
        if let value = npsModel.fieldValue {
            buttonView?.selectButton(value)
        } else {
            buttonView?.resetButtons()
        }
     
    }
}
