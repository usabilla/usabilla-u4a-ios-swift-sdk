//
//  EventEngine.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 05/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class EventEngine {

    var campaigns: [CampaignModel]

    init(campaigns: [CampaignModel]) {
        self.campaigns = campaigns
    }

    /**
     - Parameter eventName: the event
     - Returns: tuple 
        - campaigns which respond to the event
        - campaigns which triggered
     */
    func sendEvent(_ eventName: String) -> ([CampaignModel], [CampaignModel]) {
        let event = Event(name: eventName)

        let campaignThatResponds = campaigns.filter {
            $0.respondToEvents(event: event)
        }

        let campaignToDisplay = campaignThatResponds.filter {
            $0.triggers(event: event) == true
        }

        return (campaignThatResponds, campaignToDisplay)
    }
}
