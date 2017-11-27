//
//  UBMock.swift
//  Usabilla
//
//  Created by Adil Bougamza on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

@testable import Usabilla

class UBMock {

    static var mockJson: JSON?
    static var formJson: JSON?
    static var mockTargeting: TargetingOptionsModel {
        get {
            return TargetingOptionsModel(json: json("TargetingOptionsJSON")!)!
        }
    }
    class func json(_ key: String) -> JSON? {
        if mockJson == nil {
            mockJson = UBTestHelper.getJSONFromFile(named: "Mock")["node"]
        }

        return UBMock.mockJson?[key]
    }

    class func json(fromFile: String, _ key: String? = nil) -> JSON {
        var mockJson = UBTestHelper.getJSONFromFile(named: fromFile)
        if let key = key {
            return mockJson[key]
        }
        return mockJson
    }

    class func formMock () -> FormModel {
        if formJson == nil {
            formJson = UBTestHelper.getJSONFromFile(named: "test")
        }
        return FormModel(json: formJson!, id: "mockFormId", screenshot: nil)!
    }

    class func pageMock () -> PageModel {
        return PageModel(pageNumber: 0, pageName: "", type: .form)
    }

    class func campaignMock(withID id: String = "", withTargetingID targetingId: String = "", withTargeting targeting: TargetingOptionsModel = UBMock.mockTargeting) -> CampaignModel {
        return CampaignModel(id: id, targeting: targeting, formID: "", targetingID: targetingId, maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: Date())
    }

    class func campaignMockWithRules(id: String = "a", createdAt: Date = Date()) -> CampaignModel {
        let leaf = LeafEvent(event: Event(name: "foo"))
        let leaf2 = LeafEvent(event: Event(name: "bar"))
        let rule = AndRule(childRules: [leaf, leaf2])
        let targeting = TargetingOptionsModel(rule: rule, targetingID: "tid", lastModifiedDate: nil)
        return CampaignModel(id: id, targeting: targeting, formID: "", targetingID: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active, createdAt: createdAt)
    }
}

class UBFormServiceMock: FormServiceProtocol {

    var requestBuilder: RequestBuilder.Type = RequestBuilder.self
    var httpClient: HTTPClientProtocol.Type = HTTPClient.self

    func getForm(withID id: String, screenShot: UIImage?) -> Promise<FormModel> {
        return Promise { fulfill, _ in
            let formModel = FormModel(json: "", id: "a", screenshot: nil)
            fulfill(formModel!)
        }
    }
    func submitForm(payload: [String: Any], screenshot: String?) -> Promise<Bool> {
        return Promise { fulfill, _ in
            sleep(1)
            fulfill(true)
        }
    }
}

class UBHTTPMockFail: HTTPClientProtocol {
    static func request(request: URLRequest, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(HTTPClientResponse(data: nil, error: NSError(domain: "Invalid JSON", code: 2, userInfo: nil), success: false))
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBHTTPMockSuccess: HTTPClientProtocol {
    // inject your expected result to be tested
    static var result: [AnyObject]!
    static func request(request: URLRequest, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(HTTPClientResponse(data: result, error: nil, success: true))
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBHTTPMock: HTTPClientProtocol {
    // inject your expected response to be tested
    static var response: HTTPClientResponse!
    static var onURLRequest: [String: HTTPClientResponse] = [:]
    static var onStringRequest: [String: HTTPClientResponse] = [:]

    static func request(request: URLRequest, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
        if let response = onURLRequest[request.url!.absoluteString] {
            completion(response)
            return
        }
        completion(response)
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
        if let response = onStringRequest[url] {
            completion(response)
            return
        }
        completion(response)
    }
}

class UBCampaignServiceMock: CampaignServiceProtocol {

    var campaignsJSONResponse: Cachable<[JSON]>?
    var targetingResponse: [TargetingOptionsModel]?
    var campaignForm: FormModel?
    var onIncrementCampaign: ((String, Int) -> Void)?
    var onGetTargeting: (([String]) -> Void)?
    var incrementCampaignSucceed = true
    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withID id: String) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            if campaignForm != nil {
                return fulfill(campaignForm!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getCampaignsJSON(withAppID appID: String) -> Promise<Cachable<[JSON]>> {
        return Promise { fulfill, reject in
            if campaignsJSONResponse != nil {
                return fulfill(campaignsJSONResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getTargetings(withIDs ids: [String]) -> Promise<[TargetingOptionsModel]> {
        return Promise { fulfill, reject in
            onGetTargeting?(ids)
            if targetingResponse != nil {
                return fulfill(targetingResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func submit(withRequest request: URLRequest) -> Promise<String?> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill("true")
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func incrementCampaignViews(forCampaignID campaignID: String, viewCount: Int) -> Promise<Bool> {
        return Promise { fulfill, reject in
            onIncrementCampaign?(campaignID, viewCount)
            if incrementCampaignSucceed == true {
                return fulfill(true)
            }
            return reject(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
}

class UBPageModelMock: PageModelProtocol {
    func toDictionary() -> [String: Any?] {
        var dict = ["one": ["one"]]
        dict["two"] = ["two", "two"]
        return dict
    }

    var type: PageType
    var fields: [BaseFieldModel]
    var fieldValuesCollection: [String: [String]]

    init(type: PageType? = nil) {
        self.type = type ?? .form
        fields = []
        fieldValuesCollection = [:]
    }
}

class CampaignSubmissionRequestManagerMock: CampaignSubmissionRequestManagerProtocol {
    func savePage(page: PageModelProtocol, nextPageType: PageType) {
    }
}

class CampaignSubmissionManagerMock: CampaignSubmissionManagerProtocol {
    var lastRequest: UBCampaignFeedbackRequest!
    var requestJSON: JSON? {
        if let request = lastRequest {
            return JSON(request.request.httpBody as Any)
        }
        return nil
    }
    func handle(request: UBCampaignFeedbackRequest) {
        lastRequest = request
    }
}

enum MockDirectoryEnum: String, DirectoryProtocol {
    case testDirectory = "Testdirectory"

    var description: String {
        return "test"
    }

    var name: String {
        return "Testdirectory"
    }
}
