//
//  EditImageButtonView.swift
//  Usabilla
//
//  Created by Anders Liebl on 22/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit

enum UBSABottomMenuType {
    case full
    case floating
    case keyboard
}
enum UBSATopMenuType {
    case iconsUndoDone
    case iconDone
    case disabled
}

protocol UBSAToolBarButtonPluginProtocol: class {
    func didTouchUpInside(sender: UBSAPluginProtocol)
    func drawingModeOn(status: Bool)
}
protocol UBSAPluginProtocol {
    func canvas(frame: CGRect) -> UIView
    func bottomMenu(frame: CGRect) -> UIView
    func bottomeMenuType() -> UBSABottomMenuType
    func topMenuType() -> UBSATopMenuType
    func menuButton() -> UIButton

    func pluginWillClose()
    func finalView() -> UIImageView?
    func pluginDidClose()
    func pluginWillShow()
    func pluginDidShow()

    var delegate: UBSAToolBarButtonPluginProtocol? {get set}

    func undoAction()
}

/// the undoAction is optional as, only the drawing tool currently needs it
/// by adding the line the undoAction can be left as is
extension UBSAPluginProtocol {
    func undoAction() {}
}

class UBSAEditImageMasterView: UIViewController, UBSAToolBarButtonPluginProtocol {

    fileprivate var currentPresentedMenu: UIView?
    fileprivate var currentPresentedPlugin: UBSAPluginProtocol?
    var theme: UsabillaTheme?
    lazy var plugins: [UBSAPluginProtocol] = []

    lazy var containerView: UBSAContainerView = {
        let aView = UBSAContainerView(frame: .zero)
        aView.clipsToBounds = true
        aView.backgroundColor = .clear
        aView.layer.cornerRadius = 4
        aView.layer.masksToBounds = true
        aView.isUserInteractionEnabled = true
        aView.contentMode = UIViewContentMode.scaleAspectFill
        aView.translatesAutoresizingMaskIntoConstraints = false
        return aView
    }()

    lazy var leftButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .right
        button.imageEdgeInsets = UIEdgeInsets(top: UBDimensions.UBSAEditImageMasterView.doneButtoniconsInsect,
                                              left: UBDimensions.UBSAEditImageMasterView.doneButtoniconsInsect,
                                              bottom: UBDimensions.UBSAEditImageMasterView.doneButtoniconsInsect,
                                              right: UBDimensions.UBSAEditImageMasterView.doneButtoniconsInsect)
        button.backgroundColor = .clear
        var buttonImage = UIImage.getImageFromSDKBundle(name: UBDimensions.UBSAEditImageMasterView.editButtonName)
        if let color = theme?.colors.accent {
            buttonImage = buttonImage?.maskWithColor(color: color)
        }
        button.setImage(buttonImage, for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTouchUpInside), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    lazy var undoButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.contentHorizontalAlignment = .right
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: UBDimensions.UBSAEditImageMasterView.undoButtoniconsInsect,
                                              left: UBDimensions.UBSAEditImageMasterView.undoButtoniconsInsect,
                                              bottom: UBDimensions.UBSAEditImageMasterView.undoButtoniconsInsect,
                                              right: UBDimensions.UBSAEditImageMasterView.undoButtoniconsInsect)
        let buttonImage = UIImage.getImageFromSDKBundle(name: UBDimensions.UBSAEditImageMasterView.undoButtonName)
        var buttonImageEnabled: UIImage!
        var buttonImageDisabled: UIImage!
        if let color = theme?.colors.accent {
            buttonImageEnabled = buttonImage?.maskWithColor(color: color)
        }
        if let disabledColor = theme?.colors.text {
           buttonImageDisabled = buttonImage?.maskWithColor(color: disabledColor)
        }
        button.setImage(buttonImageEnabled, for: UIControlState.normal)
        button.setImage(buttonImageDisabled.alpha(value: 0.3), for: UIControlState.disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(undoButtonTouchUpInside), for: .touchUpInside)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.backgroundColor = .clear
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var rightButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.contentHorizontalAlignment = .right
        button.backgroundColor = .clear
        // adding more space around the Add (to the left) allowing bigger touch area
        button.contentEdgeInsets = UIEdgeInsets(top: UBDimensions.UBSAEditImageMasterView.addButtonInsectTop,
                                                left: UBDimensions.UBSAEditImageMasterView.addButtonInsectleft,
                                                bottom: UBDimensions.UBSAEditImageMasterView.addButtonInsectBottom,
                                                right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    lazy var toolBarView: UIStackView = {
        let aView = UIStackView()
        view.addSubview(aView)
        aView.clipsToBounds = true
        aView.backgroundColor = .clear
        aView.translatesAutoresizingMaskIntoConstraints = false
        return aView
    }()
    private var buttons: [UIButton] = []

    private func addButton(_ plugin: UBSAPluginProtocol) {
        buttons.append(plugin.menuButton())
        toolBarView.addArrangedSubview(plugin.menuButton())
    }

    /*
      - this method adds all the plugins that are needed.
      - for now it implememnts a dummy plugin
     */
    func configurePlugins() {
        let draw = DrawingPlugin()
        draw.theme = theme
        draw.delegate = self
        plugins.append(draw)
        addButton(draw)
    }

    func didTouchUpInside(sender: UBSAPluginProtocol) {
        currentPresentedPlugin = sender
        let menu = sender.bottomMenu(frame: CGRect(x: 0, y: 0,
                                                   width: view.frame.size.width,
                                                   height: UBDimensions.UBSAEditImageMasterView.bottomMenuHeight + DeviceInfo.getBottomSafeInsets()))
        setTopMenu(type: sender.topMenuType())
        // The containerview knows the size of the backaground image,
        // its the only view that knows the frame we are working in
        // pass that frame into to the plugin to allow actions only in that area
        var aframe = containerView.workingFrame()
        aframe.origin.x = 0
        aframe.origin.y = 0
        containerView.addActionView(sender.canvas(frame: aframe))
        animateMenuIn(view: menu)
    }

    func drawingModeOn(status: Bool) {
       undoButton.isEnabled = status
    }
}

extension UBSAEditImageMasterView {

    @objc func backButtonTouchUpInside() {
        fatalError("backButtonTouchUpInside() has not been implemented")
    }

    @objc func addButtonTouchUpInside() {
        fatalError("addButtonTouchUpInside()  has not been implemented")
    }

    @objc func doneButtonTouchUpInside() {
        currentPresentedPlugin?.pluginWillClose()
        setStandardMenu()
        animateMenuOut()
        containerView.removeActionView()
        // get the view from the plugin
        if let view = currentPresentedPlugin?.finalView() {
            containerView.addView(view)
        }
    }

    @objc func undoButtonTouchUpInside() {
        currentPresentedPlugin?.undoAction()
    }

    fileprivate func setStandardMenu() {
        doneButton.isHidden = true
        undoButton.isHidden = true
        leftButton.isHidden = false
        leftButton.isEnabled = true
        rightButton.isHidden = false
        rightButton.isEnabled = true
        titleLabel.isHidden = false
    }
    fileprivate func setCanvasView(_ view: UIView) {
        //self.view.addSubview(view)
    }

    fileprivate func setTopMenu(type: UBSATopMenuType) {
        switch type {
        case .iconsUndoDone:
            undoButton.isHidden = false
            undoButton.isEnabled = false
            rightButton.isHidden = true
            leftButton.isHidden = true
            titleLabel.isHidden = true
            doneButton.isHidden = false
        case .iconDone:
            rightButton.isHidden = true
            leftButton.isHidden = true
            titleLabel.isHidden = true
            doneButton.isHidden = false
        case .disabled:
            rightButton.isEnabled = false
            leftButton.isEnabled = true
        }
    }

    fileprivate func animateMenuIn(view: UIView) {
        if currentPresentedMenu == nil {
            let startFrame = CGRect(x: 0, y: self.view.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
            view.frame = startFrame
            self.view.addSubview(view)
            let endFrame = CGRect(x: 0, y: self.view.frame.size.height-view.frame.height, width: view.frame.size.width, height: view.frame.size.height)
            self.currentPresentedPlugin?.pluginWillShow()
            UIView.animate(withDuration: UBDimensions.UBSAEditImageMasterView.bottomMenuAnimationTime, delay: 0, options: .curveEaseOut, animations: {
                view.frame = endFrame
            }, completion: { _ in
                self.currentPresentedMenu = view
                self.currentPresentedPlugin?.pluginDidShow()
            })
        }
    }
    fileprivate func animateMenuOut() {
        if let menuView = currentPresentedMenu {
            let endFrame = CGRect(x: 0, y: self.view.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
            UIView.animate(withDuration: UBDimensions.UBSAEditImageMasterView.bottomMenuAnimationTime, delay: 0, options: .curveEaseOut, animations: {
                menuView.frame = endFrame
            }, completion: { _ in
                menuView.removeFromSuperview()
                self.currentPresentedPlugin?.pluginDidClose()
                self.currentPresentedPlugin = nil
                self.currentPresentedMenu = nil
            })
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let menuview = currentPresentedMenu {
            coordinator.animate(alongsideTransition: { _ in
                var frame = menuview.frame
                frame.origin.y = self.view.frame.height-frame.size.height
                self.currentPresentedMenu?.frame = frame
            }, completion: { _ in
                var frame = menuview.frame
                frame.origin.y = self.view.frame.height-frame.size.height
                self.currentPresentedMenu?.frame = frame
            })
        }
    }
}
