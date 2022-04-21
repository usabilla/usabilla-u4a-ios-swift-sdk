//
//  DefaultEventsEngineTest.swift
//  UsabillaTests
//
//  Created by Anders Liebl on 11/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import XCTest
@testable import Usabilla


class DefaultEventEngineTest: XCTestCase, PresentSurveyProtocol {
    func scheduleSurvey(survey: SurveyDispatcherObject) {
    
    }
    
    func evaluationCompleded() {

    }
    

    
    var expectation: XCTestExpectation?
    var engine: DefaultEventEngine?
    var testResult: Bool?
    var counter = 0
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        engine = DefaultEventEngine()
        engine?.surveyPresenterDelegate = self
        
        let path = Bundle(for:DefaultEventTest.self).path(forResource: "DefaultEventEngine", ofType: "json")!
        let data = try? NSData(contentsOf: NSURL(fileURLWithPath: path) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let jsonObj = JSON(data: (data as Data?)!)
        let defaultjons: JSON = jsonObj["default_events"]
        let modules: [JSON] = defaultjons["modules"].arrayValue
        
        var defaultEvent =  DefaultEvent(json: modules, targetingId: "123456789")
        defaultEvent.surveyId = "123-456-789-123"
        defaultEvent.surveyType = .GFPCampaign

        DefaultEventDAO.shared.create(defaultEvent)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchCounter3() throws {
        expectation = expectation(description: "Engine triggere with launch")
        engine?.triggered(.launch)
        waitForExpectations(timeout: 4)
        let result = try XCTUnwrap(testResult)
        XCTAssertEqual(result, true)
        XCTAssertEqual(counter, 2 )
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func presentSurvey(surveyId: String, surveyType: SurveyOriginType) {
        XCTAssertEqual("123-456-789-123", surveyId)
        testResult = true
        expectation?.fulfill()
        expectation = nil
    }
    
    func noResultFound(){
        if counter < 4 {
            counter += 1
            engine?.triggered(.launch)
            return
        }
        testResult = false
        expectation?.fulfill()
        expectation = nil
 
    }

}
