//
//  PluginViewController.swift
//  Usabilla
//
//  Created by Anders Liebl on 22/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

class UBSAPluginViewController: UIViewController, UBSAPluginProtocol {

    private(set) var toolbarButtonImageName = "dummy"
    var theme: UsabillaTheme?
    lazy var leftButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: UBDimensions.PluginViewController.buttonWidth,
                                            height: UBDimensions.PluginViewController.buttonHeight))
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .clear
        var buttonImage = UIImage.getImageFromSDKBundle(name: toolbarButtonImageName)
        if let color = theme?.colors.accent {
            buttonImage = buttonImage?.maskWithColor(color: color)
        }
        button.setImage(buttonImage, for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UBSAPluginViewController.touchUpInside), for: .touchUpInside)
        return button
    }()

    weak var delegate: UBSAToolBarButtonPluginProtocol?

    func canvas(frame: CGRect) -> UIView {
        return UIView(frame: frame)
    }

    func bottomMenu(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        return view
    }

    func bottomeMenuType() -> UBSABottomMenuType {
        return .full
    }

    func topMenuType() -> UBSATopMenuType {
        return .iconDone
    }

    func menuButton() -> UIButton {
        return leftButton
    }

    func pluginWillClose() {

    }

    func finalView() -> UIImageView? {
        return nil
    }

    func pluginDidClose() {

    }

    func pluginWillShow() {

    }

    func pluginDidShow() {

    }

    func undoAction() {

    }
}

extension UBSAPluginViewController {
    @objc func touchUpInside() {
        delegate?.didTouchUpInside(sender: self)
    }

    func drawingModeOn(_ status: Bool) {
        delegate?.drawingModeOn(status: status)
    }
}
