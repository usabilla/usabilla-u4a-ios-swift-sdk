//
//  UsabillaCSDebug.swift
//  UsabillaCS
//
//  Created by Hitesh Jain on 05/10/2021.
//  Copyright © 2021 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension UsabillaCS {
#if INTERNAL_USE || DEBUG
    open class func formViewController(forFormData data: Data, screenshot: UIImage? = nil) -> UINavigationController? {
        return UsabillaInternal.formViewController(forFormData: data, screenshot: screenshot)
    }
    open class func displayCampaignForm(withID formID: String, completion: ((UBCampaignFormDisplayError?) -> Void)? = nil) {
        UsabillaInternal.displayCampaignForm(withID: formID, completion: completion)
    }
    open class func displayCampaignForm(withData data: Data) {
        UsabillaInternal.displayCampaignForm(withData: data)
    }

#endif
}
