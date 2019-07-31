//
//  UBEditImageMainViewController.swift
//  Usabilla
//
//  Created by Anders Liebl on 03/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit
import Photos
enum UBimageSource: String {
    case camera = "camera"
    case library = "library"
    case unknown = "default"
}

class UBEditImageMainViewController: UBSAEditImageMasterView {

    var imageSource: UBimageSource = .unknown

    var client: ClientModel
    lazy var cameraViewController: UBCameraViewController = UBCameraViewController()
    init(client: ClientModel) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecylce methods
    convenience init(theme: UsabillaTheme, client: ClientModel ) {
        self.init(client: client)
        self.theme = theme
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if !DeviceInfo.isIPad() {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        navigationController?.delegate = self
        view.backgroundColor = .clear
        view.isOpaque = false
        configurePlugins()
        presentCamera()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if containerView.superview == nil {
            view.addSubview(containerView)
        }
    }

    // MARK: - Rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

//    override var shouldAutorotate: Bool {
//        return true
//    }

    func addBaseImage(image: UIImage, source: UBimageSource) {
        imageSource = source
        configureAllElements()
        containerView.setBackgroundImage(image)
    }

    func presentCamera(animated: Bool = true) {
        cameraViewController.theme = theme
        cameraViewController.delegate = self
        // when the view is being presented, its not laid out, so frame is wrong size...
        let aFrame = CGRect(x: 0, y: 0, width: DeviceInfo.getMaxFormWidth(), height: DeviceInfo.getMaxFormHeight())
        cameraViewController.view.frame = aFrame
        navigationController?.pushViewController(cameraViewController, animated: animated)
    }

    private func presentImagePicker(animated: Bool = true) {
        let viewController = UBImagePickerController(theme: theme)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: animated)
    }

    // MARK: - Configuration methods
    fileprivate func configureAllElements() {
        switch imageSource {
        case .camera:
            configureFromCamera()
        case .library:
            configureFromLibrary()
        default:
            configureForDefault()
        }
        layoutViews()
        setupUI()
    }

    fileprivate func configureFromCamera() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.leftButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.rightButtonText), for: UIControlState.normal)
    }

    fileprivate func configureFromLibrary() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.backButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.addButtonText), for: UIControlState.normal)
    }

    fileprivate func configureForDefault() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.backButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.doneButtonText), for: UIControlState.normal)
    }

    fileprivate func setupUI() {
        view.backgroundColor = theme?.colors.cardColor
        leftButton.setTitleColor(theme?.colors.accent, for: UIControlState.normal)
        leftButton.setTitleColor(theme?.colors.accent.withAlphaComponent(UBDimensions.UBEditImageMainView.leftButtonAlpha), for: UIControlState.selected)
        leftButton.setTitleColor(theme?.colors.accent.withAlphaComponent(UBDimensions.UBEditImageMainView.leftButtonAlpha), for: UIControlState.highlighted)
        leftButton.titleLabel?.font = theme?.fonts.regular
        rightButton.setTitleColor(theme?.colors.accent.withAlphaComponent(UBDimensions.UBEditImageMainView.rightButtonAlpha), for: UIControlState.highlighted)
        rightButton.setTitleColor(theme?.colors.accent.withAlphaComponent(UBDimensions.UBEditImageMainView.rightButtonAlpha), for: UIControlState.selected)
        rightButton.setTitleColor(theme?.colors.accent, for: UIControlState.normal)
        rightButton.titleLabel?.font = theme?.fonts.regular
        titleLabel.font = theme?.fonts.boldFont
        titleLabel.textColor = theme?.colors.title

        
    }

    fileprivate func layoutViews() {

        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight()).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.imageLeftSideMargin).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBEditImageMainView.imageRightSideMargin).isActive = true

        leftButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonBottomMargin).isActive = true
        leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonLeftMargin).isActive = true
        leftButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        doneButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonBottomMargin).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonRightMargin).isActive = true
        doneButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        doneButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        undoButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonBottomMargin).isActive = true
        undoButton.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: 0).isActive = true
        undoButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        undoButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        titleLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true

        rightButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonBottomMargin ).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonRightMargin).isActive = true
        rightButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        rightButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        toolBarView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: UBDimensions.UBEditImageMainView.toolbarTopMarginHeight).isActive = true
        toolBarView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: UBDimensions.UBEditImageMainView.toolbarBottomMarginHeight).isActive = true
        toolBarView.heightAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.toolbarHeight).isActive = true
        toolBarView.widthAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.toolbarWidth).isActive = true
        toolBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }

    // MARK: - Action methods
    @objc
    override func backButtonTouchUpInside() {
        containerView.reset()
        switch imageSource {
        case .camera:
            presentCamera(animated: false)
        case .library:
            presentCamera(animated: false)
            presentImagePicker(animated: false)
        default:
            return
        }
    }

    private func checkPermissionAndSaveImage(_ imageData: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            UIImageWriteToSavedPhotosAlbum(imageData, nil, nil, nil)
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { reqStatus in
                if reqStatus == .authorized {
                    UIImageWriteToSavedPhotosAlbum(imageData, nil, nil, nil)
                }
            }
        }
    }

    /// if the add button is pressed, we close the view, (expects to be inside a navigationcontroller)
    /// the submit the image throug the eventbus
    @objc
    override func addButtonTouchUpInside() {
        if imageSource == .camera {
            checkPermissionAndSaveImage(containerView.finalImage())
        }
        dismiss(animated: true, completion: nil)
        if imageSource != .unknown {
            let imageType = ["image_type": imageSource.rawValue, "number_of_drawings": containerView.numbeOfDrawings()] as [String: Any]
            client.addBehaviour("screenshot_annotations", imageType)
            SwiftEventBus.postToMainThread("imagePicked", sender: containerView.finalImage())
        }
    }
}
extension UBEditImageMainViewController: CapturePhotoProtocol {
    func cameraCanceled() {
        dismiss(animated: true, completion: nil)
    }

    func pickPhotoCapturedFromCamera(image: UIImage) {
        addBaseImage(image: image, source: .camera)
        navigationController?.popToRootViewController(animated: false)
    }

    func pickPhotoCapturedFromLibrary(image: UIImage) {
        addBaseImage(image: image, source: .library)
        self.dismiss(animated: false, completion: nil)
    }

    func librarySelected() {
        self.presentImagePicker()
    }
}

extension UBEditImageMainViewController: UBImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UBImagePickerController) {
        navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UBImagePickerController, didFinishPickingImage image: UIImage!) {
        addBaseImage(image: image, source: .library)
        navigationController?.popToRootViewController(animated: false)
    }
}

extension UBEditImageMainViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            if toVC is UBCameraViewController {
                return BottomUpTransistion()
            }
            return LeftToRightTransition()
        case .pop:
            if fromVC is UBImagePickerController {
                return RightToLeftTransition()
            }
            return TopDownTransition()
        default:
            return nil
        }
    }
}

extension UBEditImageMainViewController {
}

//extension UBEditImageMainViewController: ToolBarButtonPluginProtocol {
//}
