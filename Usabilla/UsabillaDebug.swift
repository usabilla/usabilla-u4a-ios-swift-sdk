//
//  UsabillaDebug.swift
//  Usabilla
//
//  Created by Hitesh Jain on 06/02/2020.
//  Copyright © 2020 Usabilla. All rights reserved.
//

import Foundation
import UIKit

extension Usabilla {
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
