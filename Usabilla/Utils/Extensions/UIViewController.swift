//
//  UIViewController.swift
//  Usabilla
//
//  Created by Anders Liebl on 17/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

extension UIViewController {
    func barHeight() -> CGFloat {
        let barHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 0
        if DeviceInfo.isIPad() {
            return barHeight
        }
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width + barHeight, statusBarSize.height + barHeight)
    }
}
