//
//  HeaderFieldModel.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 04/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


class HeaderFieldModel: StringFieldModel {

    override init(json: JSON, pageModel: PageModel) {
        super.init(json: json, pageModel: pageModel)
        fieldValue = json["text"].string

    }

}
