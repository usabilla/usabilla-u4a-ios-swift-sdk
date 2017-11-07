//
//  CampaignService.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 18/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

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

    func getCampaignForm(withID id: String) -> Promise<FormModel>
    func getCampaignsJSON(withAppID appID: String) -> Promise<Cachable<[JSON]>>
    func getTargetings(withIDs ids: [String]) -> Promise<[TargetingOptionsModel]>
    func incrementCampaignViews(forCampaignID campaignID: String, viewCount: Int) -> Promise<Bool>
}

class CampaignService: CampaignServiceProtocol {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withID id: String) -> Promise<FormModel> {
        let request = requestBuilder.requestGetCampaignForm(withID: id)
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
            self.httpClient.request(request: request, responseQueue: nil, allowNilData: false, completion: { response in
                if let json = response.data {
                    guard let formModel = FormModel(json: JSON(json), id: id, screenshot: nil) else {
                        reject(NSError(domain: "form model is not valid", code: 0, userInfo: nil))
                        return
                    }
                    fulfill(formModel)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            })
        }
    }

    func getCampaignsJSON(withAppID appID: String) -> Promise<Cachable<[JSON]>> {
        let request = requestBuilder.requestGetCampaigns(withAppID: appID)
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
            self.httpClient.request(request: request, responseQueue: nil, allowNilData: false, completion: { response in
                guard let json = response.data,
                    let campaignsArray = JSON(json).array else {
                        guard let error = response.error else {
                            PLog("❌ error missing from response")
                            reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                            return
                        }
                        reject(error)
                        return
                }
                fulfill(Cachable(value: campaignsArray, hasChanged: response.isChanged))
            })
        }
    }

    func getTargetings(withIDs ids: [String]) -> Promise<[TargetingOptionsModel]> {
        let request = requestBuilder.requestGetAllTargetingOptions(targetingIds: ids)
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
            self.httpClient.request(request: request, responseQueue: nil, allowNilData: false, completion: { response in
                guard response.error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    reject(response.error!)
                    return
                }
                guard let jsonData = response.data, let json = JSON(jsonData).array else {
                    reject(NSError(domain: "could not parse targeting", code: 0, userInfo: nil))
                    return
                }
                let targetings: [TargetingOptionsModel] = json.flatMap { TargetingOptionsModel(json: $0) }
                fulfill(targetings)
                return
            })
        }
    }

    /// Submits a partial campaign result
    ///
    /// - Parameters:
    ///   - request: the URL request with the feedback data
    ///
    /// - Returns: A promise fulfilled with the location header of the feedback item being submitted.

    func submit(withRequest request: URLRequest) -> Promise<String?> {
        return Promise { fulfill, reject in
            httpClient.request(request: request, responseQueue: nil, allowNilData: true, completion: { response in
                if response.success {
                    if let feedbackID = response.headers?["Location"] as? String {
                        fulfill(feedbackID.components(separatedBy: "/").last)
                        return
                    }
                    fulfill(nil)
                    return
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            })
        }
    }

    /// Increase a campaign number of views
    ///
    /// - Parameters:
    ///   - campaignID: the id of the campaign to increment the number of views
    ///   - viewCount: the number of views to increment with
    ///
    /// - Returns: A promise fulfilled with the location header of the feedback item being submitted.

    func incrementCampaignViews(forCampaignID campaignID: String, viewCount: Int) -> Promise<Bool> {
        let request = requestBuilder.requestPatchCampaignViews(forCampaignID: campaignID, viewCount: viewCount)
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
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
