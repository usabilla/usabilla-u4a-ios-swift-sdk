//
//  UBIntroOutroPresenter.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBIntroOutroPresenter {
    func present(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?)
    func dismiss(view: UBIntroOutroView, inView: UIView, animations: (() -> Void)?, completion: (() -> Void)?)
}
