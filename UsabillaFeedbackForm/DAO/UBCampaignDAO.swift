//
//  UBCampaignDAO.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 07/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class CampaignDAO: UBFileStorageDAO<CampaignModel> {
    required init() {
        super.init(directoryName: "campaign")
    }
}
