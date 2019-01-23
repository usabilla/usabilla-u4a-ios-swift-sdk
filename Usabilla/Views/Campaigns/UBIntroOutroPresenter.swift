//
//  UBIntroOutroPresenter.swift
//  Usabilla
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol UBIntroOutroPresenter {
    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?)
    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?)
    func updateConstraints(to size: CGSize, orientation: UIInterfaceOrientation)
}
