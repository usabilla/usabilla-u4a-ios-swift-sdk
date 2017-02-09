//
//  ImagePickerOrientationSupport.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 09/02/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

class ImagePickerOrientationSupport: UIImagePickerController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.all
    }
}
