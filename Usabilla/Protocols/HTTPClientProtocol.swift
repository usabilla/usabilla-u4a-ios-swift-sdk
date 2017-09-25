//
//  HTTPClientProtocol.swift
//  Usabilla
//
//  Created by Giacomo Pinato on 21/04/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol HTTPClientProtocol {
    static func request(request: URLRequest, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping(HTTPClientResponse) -> Void)
    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void)
}
