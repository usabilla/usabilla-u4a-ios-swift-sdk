//
//  UBMock.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

@testable import UsabillaFeedbackForm

class UBMock {

    class func formMock () -> FormModel {
        let path = Bundle(for: UBMock.self).path(forResource: "test", ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj: JSON = JSON(data: (data as Data?)!)
        return FormModel(json: jsonObj, id: "mockFormId", screenshot: nil)
    }

    class func campaignMock() -> CampaignModel {
        return CampaignModel(id: "campaignid", json: JSON.parse(""))
    }

    class func campaignMockWithRules(id: String = "a") -> CampaignModel {
        let leaf = LeafRule(event: Event(name: "foo"))
        let leaf2 = LeafRule(event: Event(name: "bar"))
        let rule = AndRule(childRules: [leaf, leaf2])
        return CampaignModel(id: id, rule: rule, formId: "", targetingId: "", maximumDisplays: 0, version: 0)
    }
}

class UBFormServiceMock: FormServiceProtocol {

    var requestBuilder: RequestBuilder.Type = RequestBuilder.self
    var httpClient: HTTPClientProtocol.Type = HTTPClient.self

    func getForm(withId id: String, screenShot: UIImage?) -> Promise<FormModel> {
        return Promise { fulfill, _ in
            let formModel = FormModel(json: "", id: "a", screenshot: nil)
            fulfill(formModel)
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
    static func request(request: URLRequest, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(HTTPClientResponse(data: nil, error: NSError(domain: "Invalid JSON", code: 2, userInfo: nil), success: false))
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBHTTPMockSuccess: HTTPClientProtocol {
    // inject your expected result to be tested
    static var result: [AnyObject]!
    static func request(request: URLRequest, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(HTTPClientResponse(data: result, error: nil, success: true))
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBHTTPMock: HTTPClientProtocol {
    // inject your expected response to be tested
    static var response: HTTPClientResponse!
    static func request(request: URLRequest, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(response)
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBCampaignServiceMock: CampaignServiceProtocol {

    var campaignsResponse: Cachable<[CampaignModel]>?
    var targetingResponse: Cachable<Rule>?
    var campaignForm: FormModel?

    let requestBuilder: RequestBuilder.Type
    let httpClient: HTTPClientProtocol.Type

    init(requestBuilder: RequestBuilder.Type = RequestBuilder.self, httpClient: HTTPClientProtocol.Type = HTTPClient.self) {
        self.requestBuilder = requestBuilder
        self.httpClient = httpClient
    }

    func getCampaignForm(withId id: String) -> Promise<FormModel> {
        return Promise { fulfill, reject in
            if campaignForm != nil {
                return fulfill(campaignForm!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getCampaigns(withAppId appId: String) -> Promise<Cachable<[CampaignModel]>> {
        return Promise { fulfill, reject in
            if campaignsResponse != nil {
                return fulfill(campaignsResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func getTargeting(withId id: String) -> Promise<Cachable<Rule>> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill(targetingResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func submitCampaignResult(withRequest request: URLRequest) -> Promise<String> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill("feedbackId")
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }
}

class UBPageModelMock: PageModelProtocol {
    func toJSONDictionary() -> [String : Any] {
        var dict = ["one": ["one"]]
        dict["two"] = ["two", "two"]
        return dict
    }
    var type: PageType?
    var fields: [BaseFieldModel]
    var fieldValuesCollection: [String : [String]]

    init() {
        fields = []
        fieldValuesCollection = [:]
    }
}
