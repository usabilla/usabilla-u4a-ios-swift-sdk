//
//  File.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 11/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation


protocol IntFieldHandlerProtocol: class {

    var fieldValue: Int {set get}
    //var themeConfig: UsabillaThemeConfigurator {get set}
}

protocol FormViewControllerDelegate: class {
    func rightBarButtonTapped(_ formViewController: FormViewController)
    func leftBarButtonTapped(_ formViewController: FormViewController)
}
