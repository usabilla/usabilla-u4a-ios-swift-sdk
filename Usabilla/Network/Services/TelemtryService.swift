//
//  TelemtryService.swift
//  Usabilla
//
//  Created by Anders Liebl on 22/03/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol TelemtryServiceProtocol {
    var requestBuilder: RequestBuilder.Type { get }
    var httpClient: HTTPClientProtocol.Type { get }

    func submitTelemtryData(appId: String, body: String) -> Promise<Bool>
}

class TelemtryService: TelemtryServiceProtocol {

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type
    weak var telemetric: UBTelemetrics?

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func submitTelemtryData(appId: String, body: String) -> Promise<Bool> {
        let request = requestBuilder.requestSubmitTelemetryData(withAppID: appId, body: body)
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
                guard let error = response.error else {
                    PLog("❌ error missing from response")
                    reject(NSError(domain: "error missing from response", code: 0, userInfo: nil))
                    return
                }
                reject(error)
            })
        }
    }
}
