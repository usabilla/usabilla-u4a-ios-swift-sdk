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
    private func hideAllSubViews() {
        view.backgroundColor = .black
        containerView.alpha = 0
        leftButton.alpha = 0
        rightButton.alpha = 0
        titleLabel.alpha = 0
    }
    private func presentAllViews() {
        containerView.alpha = 1.0
        leftButton.alpha = 1.0
        rightButton.alpha = 1.0
        titleLabel.alpha = 1.0
    }

    func addBaseImage(image: UIImage, source: UBimageSource) {
        imageSource = source
        configureAllElements()
        containerView.image = image
        presentAllViews()
    }

    func presentCamera(animated: Bool = true) {
        cameraViewController.theme = theme
        cameraViewController.delegate = self
        //cameraViewController.modalPresentationStyle = .formSheet
        DispatchQueue.main.async {
            let navController = UBNavigationController(rootViewController: self.cameraViewController)
            navController.modalPresentationStyle = .formSheet
            navController.preferredContentSize = DeviceInfo.preferedFormSize()
            self.present(navController, animated: animated, completion: nil)
        }
    }

    private func pickImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePicker.allowsEditing = false
                imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                self.present(imagePicker, animated: false, completion: nil)
            }
        }
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
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
    }

    fileprivate func configureFromLibrary() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_add_button_title"), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
    }

    fileprivate func configureForDefault() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_done_button_title"), for: UIControlState.normal)
        titleLabel.text = LocalisationHandler.getLocalisedStringForKey("usa_edit_title")
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
            pickImageFromGallery()
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
        hideAllSubViews()
        containerView.alpha = 0.0
        view.alpha = 0.0
        dismiss(animated: true, completion: nil)
        dismiss(animated: false, completion: nil)
    }

    func pickPhotoCapturedFromCamera(image: UIImage) {
        addBaseImage(image: image, source: .camera)
        self.dismiss(animated: false ,completion: nil)
    }

    func pickPhotoCapturedFromLibrary(image: UIImage) {
        hideAllSubViews()
        addBaseImage(image: image, source: .library)
        self.dismiss(animated: false, completion: nil)
    }

    func librarySelected() {
        hideAllSubViews()
        dismiss(animated: false, completion: {
            self.pickImageFromGallery()
        })
    }
}

extension UBEditImageMainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hideAllSubViews()
        self.dismiss(animated: false, completion: nil)
        presentCamera(animated: false)
    }

    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        addBaseImage(image: image, source: .library)
        self.dismiss(animated: false, completion: nil)
    }

}
