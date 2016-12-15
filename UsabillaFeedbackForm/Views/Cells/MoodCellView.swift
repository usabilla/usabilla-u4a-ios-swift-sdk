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

        setBoundsToFillContainerView(view: buttonView!)
        
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
