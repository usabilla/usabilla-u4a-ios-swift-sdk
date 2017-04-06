//
//  UBMock.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

@testable import UsabillaFeedbackForm

class UBMock {

    class func formMock () -> FormModel {
        let path = Bundle(for: UBMock.self).path(forResource: "test", ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj: JSON = JSON(data: (data as Data?)!)
        return FormModel(json: jsonObj, id: "mockFormId", screenshot: nil)
    }
}
