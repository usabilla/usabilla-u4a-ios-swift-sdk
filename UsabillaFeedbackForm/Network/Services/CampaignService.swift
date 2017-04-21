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

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type =  HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withId id: String) -> Promise<FormModel> {
        let request = requestBuilder.buildGetCampaignForm(withFormId: id)
        return Promise { fulfill, reject in
            httpClient.request(request: request as URLRequest, responseQueue: nil, completion: { response in
                if let json = response.data {
                    fulfill(FormModel(json: JSON(json), id: "a", screenshot: nil))
                    return
                }
                reject(response.error!)
            })
        }
    }
}
