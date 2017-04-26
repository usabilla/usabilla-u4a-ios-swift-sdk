//
//  CampaignService.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 18/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class CampaignService {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withId id: String) -> Promise<FormModel> {
        let request = requestBuilder.requestGetCampaignForm(withId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request as URLRequest, responseQueue: nil, completion: { response in
                if let json = response.data {
                    fulfill(FormModel(json: JSON(json), id: "a", screenshot: nil))
                    return
                }
                reject(response.error!)
            })
        }
    }

    func getCampaignsFor(appId id: String) -> Promise<[CampaignModel]> {
        let request = requestBuilder.requestGetCampaignsfor(appId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request as URLRequest, responseQueue: nil, completion: { response in
                if let json = response.data {
                    // init the return array of campaigns
                    var campaigns = [CampaignModel]()
                    // loop through and create CampaignModels
                    if let campaignsArray = JSON(json).array {
                        for campaignJson in campaignsArray {
                            let id = campaignJson["campId"].stringValue // TO DO: update this property when json is ready
                            let model = CampaignModel(id: id, json: campaignJson)
                            campaigns.append(model)
                        }
                    }
                    fulfill(campaigns)
                    return
                }
                reject(response.error!)
            })
        }
    }

    func getTargetingForCampaign(id: String) -> Promise<Rule> {
        let request = requestBuilder.requestGetTargetingFor(campaignId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request, responseQueue: nil, completion: { response in
                if let jsonData = response.data {
                    let json = JSON(jsonData).dictionary
                    PLog("targeting for campaign id : \(id) :\n \(String(describing: json))")
                    fulfill(ConcreteRule(type: RuleType.leaf, childRules: [])) // TO DO: parse the targetting here
                    return
                }
                reject(response.error!)
            })
        }
    }
}
