//
//  Promise.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 18/01/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

class Promise<S> {

    private var _success: ((S) -> Void)?
    private var _failure: ((Error) -> Void)?

    private var data: S?
    private var error: Error?

    init(resolvers: (_ fulfill: @escaping (S) -> Void, _ reject: @escaping (Error) -> Void) -> Void) {
        resolvers({ (data: S) in
            self.data = data
            self._success?(data)
        }) { (error: Error) in
            self.error = error
            self._failure?(error)
        }
    }
    @discardableResult func then(execute body: @escaping (S) -> Void) -> Promise<S> {
        _success = body
        if let data = data {
            _success?(data)
        }
        return self
    }

    @discardableResult func `catch`(execute body: @escaping (Error) -> Void) -> Promise<S> {
        _failure = body
        if let error = error {
            _failure?(error)
        }
        return self
    }
}
