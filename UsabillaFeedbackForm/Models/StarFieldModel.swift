//
//  StarFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

class StarFieldModel: IntFieldModel {
    
    required init(json: JSON, pageModel: PageModel) {
        super.init(json: json, pageModel: pageModel)
        self.type = "stars"
    }
//    deinit {
//        print("star field model")
//    }
    

}
