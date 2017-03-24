//
//  UBIntroOutroPresenter.swift
//  UsabillaFeedbackForm
//
//  Created by Benjamin Grima on 23/03/2017.
//  Copyright © 2017 Usabilla. All rights reserved.
//

import Foundation

protocol UBIntroOutroPresenter {
    func present(view: UBIntroOutroView, inView: UIView)
    func dismiss(view: UBIntroOutroView, inView: UIView, completion: (() -> Void)?)
}
