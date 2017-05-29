//
//  HTTPClientProtocol.swift
//  UsabillaFeedbackForm
//
//  Created by Giacomo Pinato on 21/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

protocol HTTPClientProtocol {
    static func request(request: URLRequest, responseQueue: DispatchQueue?, completion: @escaping(HTTPClientResponse) -> Void)
    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void)
}
