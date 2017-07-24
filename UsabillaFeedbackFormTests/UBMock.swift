//
//  UBMock.swift
//  UsabillaFeedbackForm
//
//  Created by Adil Bougamza on 21/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

@testable import UsabillaFeedbackForm

class UBMock {

    static var mockJson: JSON?

    class func json(_ key: String) -> JSON? {
        if mockJson == nil {
            mockJson = UBTestHelper.getJSONFromFile(named: "Mock")["node"]
        }

        return UBMock.mockJson?[key]
    }

    class func formMock () -> FormModel {
        return FormModel(json: UBTestHelper.getJSONFromFile(named: "test"), id: "mockFormId", screenshot: nil)
    }

    class func campaignMock(withId id: String = "") -> CampaignModel {
        return CampaignModel(id: id, rule: nil, formId: "", targetingId: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active)
    }

    class func campaignMockWithRules(id: String = "a") -> CampaignModel {
        let leaf = LeafRule(event: Event(name: "foo"))
        let leaf2 = LeafRule(event: Event(name: "bar"))
        let rule = AndRule(childRules: [leaf, leaf2])
        return CampaignModel(id: id, rule: rule, formId: "", targetingId: "", maximumDisplays: 0, numberOfTimesTriggered: 0, status: .active)
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
    static func request(request: URLRequest, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
        completion(response)
    }

    static func request(_ url: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, responseQueue: DispatchQueue?, allowNilData: Bool, completion: @escaping (HTTPClientResponse) -> Void) {
    }
}

class UBCampaignServiceMock: CampaignServiceProtocol {

    var campaignsResponse: Cachable<[CampaignModel]>?
    var targetingResponse: Cachable<Rule>?
    var campaignForm: FormModel?
    var onIncrementCampaign: ((String, Int) -> Void)?
    var onGetTargeting: ((String) -> Void)?
    var incrementCampaignSucceed = true
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
            onGetTargeting?(id)
            if targetingResponse != nil {
                return fulfill(targetingResponse!)
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func submit(withRequest request: URLRequest) -> Promise<String> {
        return Promise { fulfill, reject in
            if targetingResponse != nil {
                return fulfill("feedbackId")
            }
            reject(NSError(domain: "", code: 500, userInfo: nil))
        }
    }

    func incrementCampaignViews(forCampaignId campaignId: String, viewCount: Int) -> Promise<Bool> {
        return Promise { fulfill, reject in
            onIncrementCampaign?(campaignId, viewCount)
            if incrementCampaignSucceed == true {
                return fulfill(true)
            }
            return reject(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
}

class UBPageModelMock: PageModelProtocol {
    func toJSONDictionary() -> [String: Any] {
        var dict = ["one": ["one"]]
        dict["two"] = ["two", "two"]
        return dict
    }
    var type: PageType?
    var fields: [BaseFieldModel]
    var fieldValuesCollection: [String: [String]]

    init() {
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
