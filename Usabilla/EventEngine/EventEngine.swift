//
//  EventEngine.swift
//  Usabilla
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
    func sendEvent(_ eventName: String, activeStatuses: [String: String]) -> ([CampaignModel], [CampaignModel]) {
        DLogInfo("Event \"\(eventName)\" sent!")

        let event = Event(name: eventName)

        let campaignThatResponds = campaigns.filter {
            $0.respondToEvents(event: event)
        }

        let campaignToDisplay = campaignThatResponds.filter {
            $0.triggers(event: event, activeStatuses: activeStatuses) == true
        }
        campaignToDisplay.forEach { DLogInfo("Campaign \($0.identifier) has been triggered!") }
        return (campaignThatResponds, campaignToDisplay)
    }
}
