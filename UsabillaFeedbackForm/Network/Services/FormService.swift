//
//  FormService.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 23/05/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol FormServiceProtocol {
    var requestBuilder: RequestBuilder.Type { get }
    var httpClient: HTTPClientProtocol.Type { get }

    func getForm(withId id: String, screenShot: UIImage?) -> Promise<FormModel>
}

class FormService: FormServiceProtocol {
    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getForm(withId id: String, screenShot: UIImage?) -> Promise<FormModel> {
        let request = requestBuilder.requestGetPassiveForm(withId: id)
        return Promise { fulfill, reject in
            self.httpClient.request(request: request as URLRequest, responseQueue: nil, completion: { response in
                if let json = response.data {
                    fulfill(FormModel(json: JSON(json), id: id, screenshot: screenShot))
                    return
                }
                reject(response.error!)
            })
        }
    }
}
