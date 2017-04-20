//
//  CampaignService.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 18/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class CampaignService {

    class func getCampaignForm(withId id: String) -> Promise<FormModel> {
        let request = RequestBuilder.buildGetCampaignForm(withFormId: id)
        return Promise { fulfill, reject in
            HTTPClient.request(request: request as URLRequest, completion: { response in
                if let json = response.data {
                    fulfill(FormModel(json: JSON(json), id: "a", screenshot: nil))
                }
                reject(response.error!)
            })
        }
    }
}
