//
//  UBCampaignDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class UBCampaignDAO: UBFileStorageDAO<CampaignModel> {
    static let directoryName = "Campaigns"
    static let shared = UBCampaignDAO()

    internal required init() {
        super.init(directoryName: UBCampaignDAO.directoryName)
    }

    override func id(forObj: CampaignModel) -> String {
        return forObj.identifier
    }
}
