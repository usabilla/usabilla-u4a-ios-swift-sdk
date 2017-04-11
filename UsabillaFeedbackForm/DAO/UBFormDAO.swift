//
//  UBFormDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBFormDAO: UBFileStorageDAO<FormModel> {

    static let sahred = UBFormDAO()

    internal required init() {
        super.init(directoryName: "Forms")
    }

    @discardableResult override func create(_ obj: FormModel) -> Bool {
        createDirectory(url: directoryUrl!)

        let fileName = obj.appId
        return saveToFile(id: fileName, data: obj)
    }

    override func read(id: String) -> FormModel? {
        let filePath = self.filePathFor(id: id)
        let form = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? FormModel
        return form
    }
}
