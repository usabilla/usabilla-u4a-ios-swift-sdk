//
//  File.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 11/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import Foundation
import UIKit

protocol Accessible {
    var accessibilityExtraInfo: String? { get set }
}

protocol CellViewModelDelegate: class {
    func valueDidChange(model: BaseFieldModel)
}

protocol IntFieldHandlerProtocol: class {
    var fieldValue: Int { get set }
}

protocol FormViewControllerDelegate: class {
    func formWillClose(_ formViewController: FormViewController)
    func pageDidTurn(oldPageModel: PageModel, oldPageIndex: Int, newPageIndex: Int, nextPageType: PageType, formViewController: FormViewController)
}

protocol ComponentViewModel: Accessible {
    var theme: UsabillaTheme { get }
    var cardBackGroundColor: UIColor? {get set}
    var delegate: ComponentViewModelDelegate? { get set }
    func reset()
}

protocol ComponentViewModelDelegate: class {
    func valueDidChange()
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
    func reset()
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

protocol MaskProtocol {
    var masks: MaskModel? { get set }
}

protocol Reachable {
    func startNotifier() throws
    var whenReachable: ((Reachability) -> Void)? { get set }
    var isReachable: Bool { get }
    var currentReachabilityStatus: Reachability.NetworkStatus { get }
}

protocol PageModelProtocol {
    func toDictionary() -> [String: Any?]
    var fields: [BaseFieldModel] { get }
    var fieldValuesCollection: [String: [String]] { get }
    var type: PageType { get }
}

protocol CampaignSubmissionManagerProtocol {
    func handle(request: UBCampaignFeedbackRequest)
}

protocol SubmissionServiceProtocol {
    @discardableResult func submit(withRequest request: URLRequest) -> Promise<String?>
}

protocol Exportable {
    var exportableValue: Any? { get }
}
