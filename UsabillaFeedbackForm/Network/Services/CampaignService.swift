//
//  CampaignService.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 18/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

class Cachable<T> {
    let value: T
    let hasChanged: Bool // if etag is different set to true
    init(value: T, hasChanged: Bool) {
        self.value = value
        self.hasChanged = hasChanged
    }
}

protocol CampaignServiceProtocol: SubmissionServiceProtocol {
    var requestBuilder: RequestBuilder.Type { get }
    var httpClient: HTTPClientProtocol.Type { get }

    func getCampaignForm(withId id: String) -> Promise<FormModel>
    func getCampaigns(withAppId appId: String) -> Promise<Cachable<[CampaignModel]>>
    func getTargeting(withId id: String) -> Promise<Cachable<Rule>>
    func incrementCampaignViews(forCampaignId campaignId: String, viewCount: Int) -> Promise<Bool>
}

class CampaignService: CampaignServiceProtocol {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withId id: String) -> Promise<FormModel> {
        let request = requestBuilder.requestGetCampaignForm(withId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request as URLRequest, responseQueue: nil, allowNilData: false, completion: { response in
                if let json = response.data {
                    fulfill(FormModel(json: JSON(json), id: id, screenshot: nil))
                    return
                }
                reject(response.error!)
            })
        }
    }

    func getCampaigns(withAppId appId: String) -> Promise<Cachable<[CampaignModel]>> {
        let request = requestBuilder.requestGetCampaigns(withAppId: appId)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request as URLRequest, responseQueue: nil, allowNilData: false, completion: { response in
                guard let json = response.data,
                    let campaignsArray = JSON(json).array else {
                        reject(response.error!)
                        return
                }
                let campaigns = campaignsArray.flatMap { CampaignModel(json: $0) }
                let cachabelResult: Cachable<[CampaignModel]> = Cachable(value: campaigns, hasChanged: response.isChanged)
                fulfill(cachabelResult)
            })
        }
    }

    func getTargeting(withId id: String) -> Promise<Cachable<Rule>> {
        let request = requestBuilder.requestGetTargeting(withId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request, responseQueue: nil, allowNilData: false, completion: { response in
                if let jsonData = response.data {
                    let json = JSON(jsonData).dictionary
                    PLog("targeting for id : \(id) :\n \(String(describing: json))")

                    guard let targeting = json?["options"], let rule = TargetingParser.targeting(fromJson: targeting) else {
                        reject(NSError(domain: "Impossible to parse targeting", code: 0, userInfo: nil))
                        return
                    }

                    let cachable: Cachable<Rule> = Cachable(value: rule, hasChanged: response.isChanged)
                    fulfill(cachable)
                    return
                }
                reject(response.error!)
            })
        }
    }

    /// Submits a partial campaign result
    ///
    /// - Parameters:
    ///   - request: the URL request with the feedback data
    ///
    /// - Returns: A promise fulfilled with the location header of the feedback item being submitted.

    func submit(withRequest request: URLRequest) -> Promise<String> {
        return Promise { fulfill, reject in
            httpClient.request(request: request, responseQueue: nil, allowNilData: true, completion: { response in
                if let location = response.headers?["Location"] as? String {
                    fulfill(location)
                    return
                }
                reject(NSError(domain: "API says no", code: 1, userInfo: nil))
            })
        }
    }

    /// Increase a campaign number of views
    ///
    /// - Parameters:
    ///   - campaignId: the id of the campaign to increment the number of views
    ///   - viewCount: the number of views to increment with
    ///
    /// - Returns: A promise fulfilled with the location header of the feedback item being submitted.

    func incrementCampaignViews(forCampaignId campaignId: String, viewCount: Int) -> Promise<Bool> {
        let request = requestBuilder.requestPatchCampaignViews(forCampaignId: campaignId, viewCount: viewCount)
        return Promise { fulfill, reject in
            httpClient.request(request: request, responseQueue: nil, allowNilData: true, completion: { response in
                if response.success {
                    fulfill(true)
                    return
                }
                reject(response.error ?? NSError(domain: "Impossible to increment campaign views", code: 0, userInfo: nil))
            })
        }
    }
}
