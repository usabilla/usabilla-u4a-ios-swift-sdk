///
///  SurveyDispatcher.swift
///  Usabilla
///
///  This Object is responsible for showing surveys once they have been found throught the AppEventNotifier / DefaultEventEngine
///
///  Currently its only capable of showing Campaigns
///
///
///  Created by Anders Liebl on 13/05/2022.
///  Copyright © 2022 Usabilla. All rights reserved.
///

import Foundation

protocol SurveyDispatcherDelegate: class {
    func didPresentSurvey(survey: SurveyDispatcherObject)
    func failedToPresentSurvey(survey: SurveyDispatcherObject, reason: DefaultEventError)
}

enum SurveyDispatcherResult: Int {
    case displayNotAllowed
    case failedToDisplay
    case didDisplay
    case errorInFormat
    case undefinded
    case inactiveCampaign
}

struct SurveyDispatcherObject: Equatable, Codable {
    static func == (lhs: SurveyDispatcherObject, rhs: SurveyDispatcherObject) -> Bool {
        return lhs.surveyDate == rhs.surveyDate && lhs.surveyType == rhs.surveyType && lhs.surveyId == rhs.surveyId
    }

    let surveyDate: Date
    let surveyId: String
    let surveyType: SurveyOriginType
    var customVariables: [String: String]

    init(surveyDate: Date, surveyId: String, surveyType: SurveyOriginType, customVariables: [String: String] = [: ]) {
        self.surveyDate = surveyDate
        self.surveyId = surveyId
        self.surveyType = surveyType
        self.customVariables = customVariables
    }
}

class SurveyDispatcher {

    var surveysToShow: [SurveyDispatcherObject] = []
    var campaignManager: CampaignManager?
    var delegate: SurveyDispatcherDelegate?

    ///
    ///   This method will present a survey, when present the
    ///   - parameters:
    ///      - surveyId: the id of the survey to present
    ///      - surveyType: the type to present
    func addSurveyToCue(surveyObject: SurveyDispatcherObject) {
        surveysToShow.append(surveyObject)
    }

    func showSurvey() {
        let surveys = surveysToShow.sorted(by: {return $0.surveyDate.timeIntervalSince1970 < $1.surveyDate.timeIntervalSince1970 })
        if let surveyObject = surveys.first {
        switch surveyObject.surveyType {
        case .GFPCampaign:
            presentGFPCampaign(with: surveyObject)
        case .GFPForm:
            presentGFPForm()
        case .unknow:
            let error = DefaultEventError(message: "The \(surveyObject.surveyType.rawValue) is currently not supported")
            delegate?.failedToPresentSurvey(survey: surveyObject, reason: error)
        }
        }
    }
}

extension SurveyDispatcher {

    func presentGFPCampaign(with surveyObject: SurveyDispatcherObject) {
        campaignManager?.campaignStore.getCampaignStatus(withID: surveyObject.surveyId).then { campaign in
            if campaign.status == .active {
            self.campaignManager?.displayCampaignFromDispatcher(campaign, withUserContext: surveyObject.customVariables).then { result in
                    switch result {
                    case .displayNotAllowed:
                        print("displayNotAllowed for the survey")
                    case .failedToDisplay:
                        print("failedToDisplay survery")
                    case .didDisplay:
                        self.surveysToShow = []
                        self.delegate?.didPresentSurvey(survey: surveyObject)
//                        if let idx = self.surveysToShow.index(of: surveyObject) {
//                            self.surveysToShow.remove(at: idx)
//                        }
                    case .errorInFormat:
                        print("Survey had errorInFormat")
                    case .undefinded:
                        print("Survey not presented du to an undefinded error")
                    case .inactiveCampaign:
                        print("")
                    }
                }
            } else {
                let error = DefaultEventError(message: "inactiveCampaign")
              //  delegate?.failedToPresentSurvey(surveyId: surveyId, surveyType: surveyType, reason: error)
            }
        }
    }
    func presentGFPForm() {

    }

    func fetchCampaignsAndEvents(completion: (() -> Void)? = nil) {
        campaignManager?.fetchCampaignForEventEngine(completion: {
            completion?()
        })
    }
}
