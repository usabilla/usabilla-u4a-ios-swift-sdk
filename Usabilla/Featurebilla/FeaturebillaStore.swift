//
//  FeaturebillaStore.swift
//  Usabilla
//
//  Created by Hitesh Jain on 11/11/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation

protocol FeaturebillaStoreProtocol {
    func loadSettings() -> Promise<SettingModel>
}

class FeaturebillaStore: FeaturebillaStoreProtocol {

    let featurebillaService: FeaturebillaServiceProtocol
    init(service: FeaturebillaServiceProtocol) {
        self.featurebillaService = service
    }

    // Entry to load a feature flags from Network or try getting it from local
    func loadSettings() -> Promise<SettingModel> {
        return Promise { fulfill, reject in
            self.featurebillaService.getSettings().then { settings in
                PLog("  SettingModel is loaded successfully")
                fulfill(settings)
            }.catch { error in
                do {
                    let settingModel =  try self.fetchDefaultFeatureSettings()
                        fulfill(settingModel)
                } catch {
                    reject(NSError(domain: "setting model is not valid", code: 0, userInfo: nil))
                }
                reject(error)
                }
            }
    }

    func fetchDefaultFeatureSettings() throws -> SettingModel {
        guard let mockFilePath = Bundle.sdkBundle?.path(forResource: "config", ofType: "json") else {
            throw ConfigurationError.missingMockFeatureSettingsFile }
        guard let mockFeatureSettingsData =  try String(contentsOfFile: mockFilePath).data(using: .utf8) else {
            throw ConfigurationError.corruptedMockFeatureSettingsData }
        guard let mockFeatureSettingsContainer =  try? JSONDecoder().decode(SettingModel.self, from: mockFeatureSettingsData) else {
            throw ConfigurationError.mockedFeatureSettingsDecodingError }
        return mockFeatureSettingsContainer
    }
}

private enum ConfigurationError: Error {
    case missingMockFeatureSettingsFile
    case corruptedMockFeatureSettingsData
    case mockedFeatureSettingsDecodingError
}
