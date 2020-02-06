//
//  UsabillaInternalDebug.swift
//  Usabilla
//
//  Created by Hitesh Jain on 06/02/2020.
//  Copyright © 2020 Usabilla. All rights reserved.
//

import Foundation
import UIKit

#if INTERNAL_USE || DEBUG

    public enum UBCampaignFormDisplayError: Error {
        case sdkNotInitialized
        case formFetchFailed
        case campaignAlreadyBeingPresented

        public var localizedDescription: String {
            switch self {
            case .sdkNotInitialized:
                return "The SDK is not yet initialized"
            case .formFetchFailed:
                return "Impossible to fetch the campaign form"
            case .campaignAlreadyBeingPresented:
                return "A campaign is already being displayed"
            }
        }
    }

#endif
