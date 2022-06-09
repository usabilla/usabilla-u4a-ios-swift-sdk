//
//  AppEventNotifier.swift
//  Usabilla
//
//  Created by Hitesh Jain on 17/03/2022.
//  Copyright © 2022 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol AppEnvironment {
    var isInForeground: Bool { get }
    var appState: AppState { get }
    var currentTime: String { get set}
}

enum AppState {
    case launch
    case exit
    case crash
    case user
}

struct AppEventData: Codable {
    var launchDate: Date = Date()
    var surveyQueue: [SurveyDispatcherObject] = []
    var lastFetchDate: Date = Date()
}

class AppEventNotifier: NSObject, AppEnvironment, AppCrashDelegate {
    /// Whether the application is in the foreground.
    private var launchTimer: Timer?
    let appStateId: String = "AppStateID"
    var isInForeground: Bool = false
    var appState: AppState = .launch
    var eventEngine: DefaultEventEngine
    var currentTime: String = Int64(Date().timeIntervalSince1970 * 1000).description
    let fetchTime: Int = 43200 // 12*3600 hr*sec -> seconds
    let appLaunchDelay: Double = 3.0
    private var customVariables: [String: String]
    var surveyDispatcher: SurveyDispatcher?
    // eventInitializer will initialize the events
    init(customVariables: [String: String]) {
        self.customVariables = customVariables
        self.eventEngine = DefaultEventEngine()
        super.init()
        AppCrash.add(delegate: self)
        eventInitializer()
        self.eventEngine.surveyPresenterDelegate = self
        self.surveyDispatcher = SurveyDispatcher()
        self.surveyDispatcher?.delegate = self
        appLaunch()
    }

    func setCustomVariables (_ customVariables: [String: String]) {
        self.customVariables = customVariables
    }

    func setCampaignManager(_ manager: CampaignManager) {
        surveyDispatcher?.campaignManager = manager
    }
    // deinit will deinit the notifiers
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }

    func eventInitializer() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(notification:)), name:
                                                NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
                                                // NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillTerminate(notification:)), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }

#if canImport(UIKit)
    @objc func applicationWillEnterForeground(notification: Notification) {
        self.isInForeground = true
        Swift.debugPrint("APPSTATE :\( UIApplication.shared.applicationState)")
        self.appLaunch()
    }
    @objc func applicationDidEnterBackground(notification: Notification) {
        self.isInForeground = false
        self.appExit()
    }
    @objc func applicationWillTerminate(notification: Notification) {
        self.isInForeground = false
        self.appExit()
    }
#endif

    func restoreSavedSurveysAndConfigure() -> Bool {
        var result = false
        if let data = DefaultEventAppStateDAO.shared.read(id: appStateId) {
            if data.surveyQueue.count > 0 {
                surveyDispatcher?.surveysToShow = data.surveyQueue
                result = true
            }
        }
        if var appData = DefaultEventAppStateDAO.shared.read(id: "AppStateID") {
            appData.launchDate = Date()
            DefaultEventAppStateDAO.shared.create(appData)
        } else {
            let appData = AppEventData()
            DefaultEventAppStateDAO.shared.create(appData)
        }
        return result
    }

    func appLaunch() {
        if launchTimer != nil {
            launchTimer?.invalidate()
        }
        appState = AppState.launch
        checkAndFetchCampaigns(completion: {
                // set the launch timer
            self.launchTimer = Timer.scheduledTimer(timeInterval: self.appLaunchDelay, target: self, selector: #selector(self.appLaunchAfterTimer), userInfo: nil, repeats: false)

        })
    }

    @objc func appLaunchAfterTimer() {
        launchTimer?.invalidate()
        if !restoreSavedSurveysAndConfigure() {
            triggerEventEngine()
        } else {
            surveyDispatcher?.showSurvey()
        }

    }

    func appExit() {
        launchTimer?.invalidate()
        // calulate the run time
        appState = AppState.exit
        triggerEventEngine()
    }

    func appCrashDidCatchCrash(with model: AppCrashModel) {
        launchTimer?.invalidate()
        appState = AppState.crash
        isInForeground = false
        triggerEventEngine()
    }

    func checkAndFetchCampaigns(completion: (() -> Void)? = nil) {
        if let appData = DefaultEventAppStateDAO.shared.read(id: "AppStateID") {
            let timeInApp = getDateDiff(start: appData.lastFetchDate, end: Date())
            if timeInApp >= fetchTime {
                surveyDispatcher?.fetchCampaignsAndEvents(completion: completion)
                return
            }
        completion?()
        return
        }
        completion?()
    }

    func triggerEventEngine() {
        switch appState {
        case .launch:
            eventEngine.triggered(.launch, evalObject: createJustInTimeEvaluationbject())
        case .exit:
            eventEngine.triggered(.exit, evalObject: createJustInTimeEvaluationbject())
        case .crash:
            eventEngine.triggered(.crash, evalObject: createJustInTimeEvaluationbject())
        case .user:
            eventEngine.triggered(.crash, evalObject: createJustInTimeEvaluationbject())
        }
    }

    func createJustInTimeEvaluationbject() -> EvaluationObject {
        var data = EvaluationObject()
        let localeLanguage = String(describing: Locale.preferredLocale()).prefix(2).lowercased()
        data.add(key: .language, value: localeLanguage)
        data.addCustomerVariables(customVariables)
        data.add(key: .currentTime, value: Date().toRFC3339Format())
        if let appData = DefaultEventAppStateDAO.shared.read(id: appStateId) {
            let timeInApp = getDateDiff(start: appData.launchDate, end: Date())
            data.add(key: .timeSpent, value: String(timeInApp))
        }
        data.add(key: .appVersion, value: Bundle.appVersion)
        data.add(key: .platform, value: PlatformType.ios.rawValue)
        return data
    }

    func getDateDiff(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)

        if let seconds = dateComponents.second {
            return Int(seconds)
        }
        return 0
    }
}

extension AppEventNotifier: PresentSurveyProtocol {
    func scheduleSurvey(survey: SurveyDispatcherObject) {
        let object = SurveyDispatcherObject(surveyDate: survey.surveyDate,
                                            surveyId: survey.surveyId,
                                            surveyType: survey.surveyType,
                                            customVariables: customVariables)
        surveyDispatcher?.addSurveyToQueue(surveyObject: object)
    }

    func evaluationCompleded() {
        /// if evaluation is completed, and app is not in foreground, store the surveys
        ///

        if !isInForeground {
            if let surveys = surveyDispatcher?.surveysToShow {
                if var appData = DefaultEventAppStateDAO.shared.read(id: "AppStateID") {
                    appData.surveyQueue = surveys
                    DefaultEventAppStateDAO.shared.create(appData)
                } else {
                    var appData = AppEventData()
                    appData.surveyQueue = surveys
                    DefaultEventAppStateDAO.shared.create(appData)
                }
            }
            return
        }
        surveyDispatcher?.showSurvey()
    }

    func noResultFound() {
        // TODO: No Result Found
        DLogInfo(DefaultEventConstants.noResultFound)
    }
}

extension AppEventNotifier: SurveyDispatcherDelegate {
    func didPresentSurvey(survey: SurveyDispatcherObject) {
        _ = eventEngine.updateSurveyShown(survey.surveyId)
        if var appData = DefaultEventAppStateDAO.shared.read(id: "AppStateID") {
            appData.surveyQueue = []
            DefaultEventAppStateDAO.shared.create(appData)
        }
    }

    func didSurveyAlreadyPresented(survey: SurveyDispatcherObject) {
        _ = eventEngine.updateSurveyShown(survey.surveyId)
    }

    func failedToPresentSurvey(survey: SurveyDispatcherObject, reason: DefaultEventError) {
        DLogInfo(DefaultEventConstants.noSurveyToShow)
        if reason.message == "inactiveCampaign" {
            eventEngine.updateDefaultEventStatus(survey.surveyId)
            surveyDispatcher?.removeSurveyFromQueue(surveyObject: survey)
            surveyDispatcher?.showSurvey()
        }
    }
}
