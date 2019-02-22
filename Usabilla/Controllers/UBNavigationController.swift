//
//  UBNavigationController.swift
//  Usabilla
//
//  Created by Anders Liebl on 27/11/2018.
//  Copyright © 2018 Usabilla. All rights reserved.
//

import UIKit

class UBNavigationController: UINavigationController {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        preferredContentSize = DeviceInfo.preferedFormSize()
    }
     override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations)!
    }
}
