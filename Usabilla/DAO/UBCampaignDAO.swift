//
//  UBCampaignDAO.swift
//  Usabilla
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCampaignDAO: UBFileStorageDAO<CampaignModel> {
    static let directory = FileDirectory.campaign
    static let shared = UBCampaignDAO()

    internal required init() {
        super.init(directory: UBCampaignDAO.directory)
    }

    override func id(forObj: CampaignModel) -> String {
        return forObj.identifier
    }
}
