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

class UBEditImageMainViewController: UIViewController {

    var imageSource: UBimageSource = .unknown
    private var theme: UsabillaTheme?
    var client: ClientModel
    lazy var cameraViewController: UBCameraViewController = UBCameraViewController()
    lazy var containerView: UIImageView = {
        let aView = UIImageView()
        aView.clipsToBounds = true
        aView.backgroundColor = .clear
        aView.layer.cornerRadius = 4
        aView.layer.masksToBounds = true
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
        button.addTarget(self, action: #selector(UBEditImageMainViewController.backButtonTouchUpInside), for: .touchUpInside)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UBEditImageMainViewController.addButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

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
        navigationController?.delegate = self
        view.backgroundColor = .clear
        view.isOpaque = false
        presentCamera()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if containerView.superview == nil {
            view.addSubview(containerView)
        }
    }

    func addBaseImage(image: UIImage, source: UBimageSource) {
        imageSource = source
        configureAllElements()
        containerView.image = image
    }

    func presentCamera(animated: Bool = true) {
        cameraViewController.theme = theme
        cameraViewController.delegate = self
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
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_retake_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_add_button_title"), for: UIControlState.normal)
        //titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
    }

    fileprivate func configureFromLibrary() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_add_button_title"), for: UIControlState.normal)
        //titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
    }

    fileprivate func configureForDefault() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_done_button_title"), for: UIControlState.normal)
        //titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
    }

    fileprivate func setupUI() {
        view.backgroundColor = theme?.colors.cardColor
        leftButton.setTitleColor(theme?.colors.accent, for: UIControlState.normal)
        leftButton.setTitleColor(theme?.colors.accent.withAlphaComponent(0.5), for: UIControlState.selected)
        leftButton.setTitleColor(theme?.colors.accent.withAlphaComponent(0.5), for: UIControlState.highlighted)
        leftButton.titleLabel?.font = theme?.fonts.regular
        rightButton.setTitleColor(theme?.colors.accent.withAlphaComponent(0.5), for: UIControlState.highlighted)
        rightButton.setTitleColor(theme?.colors.accent.withAlphaComponent(0.5), for: UIControlState.selected)
        rightButton.setTitleColor(theme?.colors.accent, for: UIControlState.normal)
        rightButton.titleLabel?.font = theme?.fonts.regular
        titleLabel.font = theme?.fonts.boldFont
        titleLabel.textColor = theme?.colors.title

    }

    fileprivate func layoutViews() {

        leftButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonTopMargin ).isActive = true
        leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonLeftMargin).isActive = true
        leftButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        titleLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: UBDimensions.UBEditImageMainView.titleLabelTopMargin).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true

        rightButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonTopMargin ).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBEditImageMainView.rightButtonRightMargin).isActive = true
        rightButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        rightButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

        containerView.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: UBDimensions.UBEditImageMainView.imageTopMargin).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: UBDimensions.UBEditImageMainView.imageBottomMargin).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.imageLeftSideMargin).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBEditImageMainView.imageRightSideMargin).isActive = true
    }

    // MARK: - Action methods
    @objc
    fileprivate func backButtonTouchUpInside() {
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
    fileprivate func addButtonTouchUpInside() {
        if imageSource == .camera, let image = self.containerView.image {
            checkPermissionAndSaveImage(image)
        }
        dismiss(animated: true, completion: nil)
        if imageSource != .unknown {
            let imageType = ["image_type": imageSource.rawValue]
            client.addBehaviour("screenshot_annotations", imageType)
            SwiftEventBus.postToMainThread("imagePicked", sender: containerView.image)
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
