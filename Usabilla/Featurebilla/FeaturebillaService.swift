//
//  FeaturebillaService.swift
//  Usabilla
//
//  Created by Hitesh Jain on 08/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

protocol FeaturebillaServiceProtocol {
    var requestBuilder: RequestBuilder.Type { get }
    var httpClient: HTTPClientProtocol.Type { get }

    func getSettings() -> Promise<SettingModel>
}

class FeaturebillaService: FeaturebillaServiceProtocol {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getSettings() -> Promise<SettingModel> {
        let request = requestBuilder.requestGetFeatureSettings()
        return Promise { fulfill, reject in
            guard let request = request else {
                PLog("❌ not a valid url parameter")
                reject(NSError(domain: "not a valid url parameter", code: 999, userInfo: nil))
                return
            }
            httpClient.request(request: request, responseQueue: nil, allowNilData: false) { response in
                if let json = response.data {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        let settingModel = try JSONDecoder().decode(SettingModel.self, from: data)
                        fulfill(settingModel)
                        return
                    } catch {
                        reject(NSError(domain: "setting model is not valid", code: 0, userInfo: nil))
                        return
                    }
                }
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            }
        }
    }
}
