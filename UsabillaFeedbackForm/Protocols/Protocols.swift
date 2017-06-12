//
//  File.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 11/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation

protocol IntFieldHandlerProtocol: class {
    var fieldValue: Int { set get }
}

protocol FormViewControllerDelegate: class {
    func formWillClose(_ formViewController: FormViewController)
    func pageDidTurn(oldPageModel: PageModel, oldPageIndex: Int, newPageIndex: Int, newPageType: PageType, formViewController: FormViewController)
}

protocol ComponentViewModel {
    var theme: UsabillaTheme { get }
}

protocol StringComponentViewModel: ComponentViewModel {
    var value: String? { get set }
}

protocol EditableStringComponentViewModel: StringComponentViewModel {
    var placeHolder: String? { get }
}

protocol OptionsComponentViewModel: ComponentViewModel {
    var value: [String]? { get set }
    var options: [Options] { get }
}

protocol Centerable {
    var isCentered: Bool { get set }
}

protocol ComponentModel {
}

protocol IntComponentModel: ComponentModel {
    var fieldValue: Int? { get set }
}

protocol StringComponentModel: ComponentModel {
    var fieldValue: String? { get set }
}

protocol EditableStringComponentModel: StringComponentModel {
    var placeHolder: String? { get }
}

protocol ImageComponentModel: ComponentModel {
    var image: UIImage? { get set }
}

protocol Reachable {
    func startNotifier() throws
    var whenReachable: ((Reachability) -> Void)? { get set }
    var isReachable: Bool { get }
    var currentReachabilityStatus: Reachability.NetworkStatus { get }
}

protocol PageModelProtocol {
    func toJSONDictionary() -> [String: Any]
    var fields: [BaseFieldModel] { get }
    var fieldValuesCollection: [String: [String]] { get }
    var type: PageType? {get set}
}
