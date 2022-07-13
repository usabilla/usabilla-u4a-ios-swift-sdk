//
//  DefaultEventsEngine.swift
//  Usabilla
//
//  Created by Anders Liebl on 09/05/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
import AVFoundation

protocol PresentSurveyProtocol {
    func scheduleSurvey(survey: SurveyDispatcherObject)
    func noResultFound()
    func evaluationCompleded()
}

struct DefaultEventEngine {
    let store = DefaultEventStore()
    var surveyPresenterDelegate: PresentSurveyProtocol?

    func triggered(_ triggeredType: SystemEventType, evalObject: EvaluationObject? = nil) {
        var foundSurveys: Bool = false
        let events = getDefaultEvents()
        for aDefaultEvent in events {
            if !aDefaultEvent.status {continue}
            var evalutationObejct: EvaluationObject = EvaluationObject()
            evalutationObejct.add(key: .surveyId, value: aDefaultEvent.surveyId)
            if let data = evalObject?.getKeyValues() {
                evalutationObejct.addKeyValues(keyValues: data)
            }
            evalutationObejct.add(key: .eventType, value: triggeredType.rawValue)
            var aResult = true
            for aModule in aDefaultEvent.modules {
                aResult = aModule.evaluate(evalutationObejct)
                if !aResult {break}
            }
            if aResult {
                foundSurveys = true
                let object = SurveyDispatcherObject(surveyDate: aDefaultEvent.creationdate, surveyId: aDefaultEvent.surveyId, surveyType: aDefaultEvent.surveyType)
                surveyPresenterDelegate?.scheduleSurvey(survey: object)
            }
        }
        if foundSurveys {
            surveyPresenterDelegate?.evaluationCompleded()
            return
        }
        surveyPresenterDelegate?.noResultFound()
    }

    func getDefaultEvents() -> [DefaultEvent] {
        let data = store.getDefaultEvents()
        return data.sorted(by: { return $0.creationdate.timeIntervalSince1970 < $1.creationdate.timeIntervalSince1970})
    }

//    func populateEvaluationObject() -> EvaluationObject {
//        var objetc = EvaluationObject()
//        objetc.add(key: .surveyId, value: "23423424")
//    }

    /** Once a Survey has been shown, tell the Derfault Events that a particular survey has been used
     - parameter surveyId: the surveyId that has been shown
     - returns: true   if the survey was found in defaultEvents, and wasset to shown,
     */
    func updateSurveyShown(_ surveyId: String) -> Bool {
        let events = getDefaultEvents()
        var result = false
        events.forEach({ aDefaultEvent in
            if aDefaultEvent.surveyId == surveyId {
                if let theModule = aDefaultEvent.modules[0] as? EnablingEventModule {
                    result = theModule.setUsagedate(surveyId: surveyId)
                }
            }
        })

        return result
    }

    func updateDefaultEventStatus(_ surveyId: String) {
        let events = getDefaultEvents()
        if var defaultEvent = events.first(where: { $0.surveyId == surveyId}) {
            defaultEvent.status = false
            DefaultEventDAO.shared.create(defaultEvent)
        }
    }
}