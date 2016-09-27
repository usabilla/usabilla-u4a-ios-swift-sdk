//
//  ParagraphCellView.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 16/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

class ParagraphCellView: BaseTextAreaCellView {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textView.editable = false
        textView.dataDetectorTypes = [.Link, .PhoneNumber]
        textView.scrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setFeedbackItem(item: FieldModelProtocol) {
        super.setFeedbackItem(item)
        let model = item as! ParagraphFieldModel
        let text = model.fieldValue
        if model.html != nil && model.html! {
            textView.setValue(text, forKey: "contentToHTMLString")
        } else {
            textView.text = text
        }    
    }
    
//    deinit {
//        print("paragraph cell deinit")
//    }
}
