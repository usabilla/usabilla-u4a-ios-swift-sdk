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
    func didSurveyAlreadyPresented(survey: SurveyDispatcherObject)
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
    func addSurveyToQueue(surveyObject: SurveyDispatcherObject) {
        surveysToShow.append(surveyObject)
    }
    func removeSurveyFromQueue(surveyObject: SurveyDispatcherObject) {
        surveysToShow.removeAll(where: { (survey) -> Bool in
            return survey.surveyId == surveyObject.surveyId
        })
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
                        PLog(DefaultEventConstants.displayNotAllowed)
                        self.delegate?.didSurveyAlreadyPresented(survey: surveyObject)
                    case .failedToDisplay:
                        PLog(DefaultEventConstants.failedToDisplay)
                    case .didDisplay:
                        self.surveysToShow = []
                        self.delegate?.didPresentSurvey(survey: surveyObject)
//                        if let idx = self.surveysToShow.index(of: surveyObject) {
//                            self.surveysToShow.remove(at: idx)
//                        }
                    case .errorInFormat:
                        PLog(DefaultEventConstants.errorInFormat)
                    case .undefinded:
                        PLog(DefaultEventConstants.undefinded)
                    case .inactiveCampaign:
                        PLog(DefaultEventConstants.inactiveCampaign)
                    }
                }
            } else {
                let error = DefaultEventError(message: "inactiveCampaign")
                self.delegate?.failedToPresentSurvey(survey: surveyObject, reason: error)
            }
        }
    }
    func presentGFPForm() {
        // TODO: PRESENT GFP FORM
    }

    func fetchCampaignsAndEvents(completion: (() -> Void)? = nil) {
        campaignManager?.fetchCampaignForEventEngine(completion: {
            completion?()
        })
    }
}
