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
    case loaded = "loaded"
    case unknown = "default"
}

struct UBImageInputTypes {
    enum UBInputTypes {
    case camera
    case library
    case both
    case none
    }
    static func available(_ type: UBInputTypes? = nil ) -> UBInputTypes {
        let camera = Bundle.main.infoDictionary?["NSCameraUsageDescription"]
        let library = Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"]
        if type == .camera && camera != nil {return .camera}
        if type == .library && library != nil {return .library}

        if camera != nil && library != nil {return .both}
        if camera == nil && library != nil {return .library}
        if camera != nil && library == nil {return .camera}
        return .none
    }
}

class UBEditImageMainViewController: UBSAEditImageMasterView {
    var currentOrientation: UIDeviceOrientation?
    var imageSource: UBimageSource = .unknown
    private var currentImage: UIImage?
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
    convenience init(theme: UsabillaTheme, client: ClientModel, image: UIImage? = nil ) {
        self.init(client: client)
        self.theme = theme
        currentImage = image
        if currentImage != nil {
            imageSource = .loaded
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCurrentOrientation()

        if !DeviceInfo.isIPad() {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        navigationController?.delegate = self
        view.backgroundColor = .clear
        view.isOpaque = false
        configurePlugins()
        if imageSource != .loaded { presentImageSelector()}
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if containerView.superview == nil {
            view.addSubview(containerView)
            if let img = currentImage {
                addBaseImage(image: img, source: .loaded)
            }
        }
    }

    // MARK: - Rotation
    private var orientationPreference: UIInterfaceOrientationMask = DeviceInfo.isIPad() ? [.all] : [.portrait]
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientationPreference
    }

    func setCurrentOrientation() {
         if !DeviceInfo.isIPad() {
            currentOrientation = UIDevice.current.orientation
        }
    }

    func addBaseImage(image: UIImage, source: UBimageSource) {
        imageSource = source
        configureAllElements()
        containerView.setBackgroundImage(image)
    }

    // show the initail image selector. Default is Camera, but if camera is not available. show image library.
    // if also not available, exit gracefully.
    // this method is called from the viewDidLoad af part of the setup.
    // If there is no access 
    func presentImageSelector() {
        if Bundle.main.infoDictionary?["NSCameraUsageDescription"] != nil {
            presentCamera()
        } else if Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"] != nil {
            imageSource = .library
            presentImagePicker()
        }
    }

    func presentCamera(animated: Bool = true) {
        cameraViewController.theme = theme
        cameraViewController.delegate = self
        // when the view is being presented, its not laid out, so frame is wrong size...
        let aFrame = CGRect(x: 0, y: 0,
                            width: DeviceInfo.getMaxFormWidth(),
                            height: DeviceInfo.getMaxFormHeight(adjustToCurrentOrientation: true))
        cameraViewController.view.frame = aFrame
        cameraViewController.previousOrientationForIphone = currentOrientation
        navigationController?.pushViewController(cameraViewController, animated: animated)
    }

    private func presentImagePicker(animated: Bool = true, cancel: Bool = true) {
        let viewController = UBImagePickerController(theme: theme)
        viewController.cancelable = cancel
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
        case .loaded:
            configureForLoaded()
        default:
            configureForDefault()
        }
        layoutViews()
        setupUI()
    }

    fileprivate func configureFromCamera() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.leftButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.rightButtonText), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.editTitleText)
    }

    fileprivate func configureFromLibrary() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.backButtonLibraryText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.addButtonText), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.editTitleText)
    }

    fileprivate func configureForDefault() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.backButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.doneButtonText), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.editTitleText)
    }

    fileprivate func configureForLoaded() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.cancelButtonText), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.doneButtonText), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBEditImageMainView.editTitleText)
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
        doneButton.heightAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        undoButton.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonBottomMargin).isActive = true
        undoButton.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: 0).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

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
        self.setCurrentOrientation()
        switch imageSource {
        case .camera:
            presentCamera(animated: false)
        case .library:
            var cancel = true  // if showing the library with camera, the left button should be back
            if UBImageInputTypes.available(.camera) == .camera {
                presentCamera(animated: false)
                cancel = false
            }
            presentImagePicker(animated: false, cancel: cancel)
        case .loaded:
            self.dismiss(animated: true, completion: nil)
        default:
            return
        }
    }

    private func checkPermissionAndSaveImage(_ imageData: UIImage) {
        let library = Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"]
        if library == nil {return}
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
            let imageType = ["image_type": imageSource.rawValue,
                             "number_of_drawings": containerView.numbeOfDrawings()] as [String: Any]
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
        self.presentImagePicker(animated: true, cancel: false)
    }
}

extension UBEditImageMainViewController: UBImagePickerControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UBImagePickerController) {
        if UBImageInputTypes.available(.camera) == .camera {
            // if camera is available, the library comes from the camera screen, and should only itself
            navigationController?.popViewController(animated: true)
            return
        }
        // if camera is not available, it should remove the edit process
        dismiss(animated: true, completion: nil)
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
//    func testForLibrary
//    let camera = Bundle.main.infoDictionary?["NSCameraUsageDescription"]
//    let library = Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"]
}
