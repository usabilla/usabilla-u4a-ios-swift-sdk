//
//  UITableView.swift
//  Usabilla
//
//  Created by Adil Bougamza on 27/09/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import UIKit

extension UITableView {
    // Dispatching the scroll is used because of an issue in iPhone 5* iOS 11
    // This method works well also on all other devices on different iOS Versions
    func scrollTo(indexPath: IndexPath, animated: Bool) {
        DispatchQueue.main.async {
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}
