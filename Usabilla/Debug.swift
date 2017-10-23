//
//  Debug.swift
//  Usabilla
//
//  Created by Benjamin Grima on 05/10/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
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
    extension Usabilla {

        open class func formViewController(forFormData data: Data) -> UINavigationController? {
            return UsabillaInternal.formViewController(forFormData: data)
        }
        open class func displayCampaignForm(withID formID: String, completion: ((UBCampaignFormDisplayError?) -> Void)? = nil) {
            UsabillaInternal.displayCampaignForm(withID: formID, completion: completion)
        }
        open class func displayCampaignForm(withData data: Data) {
            UsabillaInternal.displayCampaignForm(withData: data)
        }
    }

#endif
