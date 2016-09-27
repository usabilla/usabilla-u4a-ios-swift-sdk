//
//  EmailFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class EmailFieldModel: StringFieldModel {

    let placeHolder: String?
    
    required init(json: JSON, pageModel: PageModel) {
        placeHolder = json["placeholder"].string
        super.init(json: json, pageModel: pageModel)
    }

    
    deinit {
        print("mail field model")
    }
    
}
