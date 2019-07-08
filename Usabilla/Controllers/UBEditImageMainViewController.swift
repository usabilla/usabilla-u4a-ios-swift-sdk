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
        aView.backgroundColor = .clear
        aView.contentMode = .scaleAspectFit
        aView.translatesAutoresizingMaskIntoConstraints = false
        return aView
    }()

    lazy var leftButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UBEditImageMainViewController.backButtonTouchUpInside), for: .touchUpInside)
        return button
    }()

    lazy var rightButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
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
        view.addSubview(containerView)
        presentCamera()
    }

    private func removeAllViews() {
        view.backgroundColor = .black
        containerView.alpha = 0
        leftButton.alpha = 0
        rightButton.alpha = 0
    }
    private func presentAllViews() {
        containerView.alpha = 1.0
        leftButton.alpha = 1.0
        rightButton.alpha = 1.0
    }

    func addBaseImage(image: UIImage, source: UBimageSource) {
        imageSource = source
        configureAllElements()
        containerView.image = image
        presentAllViews()
    }

    func presentCamera() {
        cameraViewController.delegate = self
        DispatchQueue.main.async {
            let navController = UBNavigationController(rootViewController: self.cameraViewController)
            self.present(navController, animated: true, completion: nil)
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
                self.present(imagePicker, animated: true, completion: nil)
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
    }

    fileprivate func configureFromLibrary() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_add_button_title"), for: UIControlState.normal)
    }

    fileprivate func configureForDefault() {
        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
        rightButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_done_button_title"), for: UIControlState.normal)
    }

    fileprivate func setupUI() {
        view.backgroundColor = theme?.colors.cardColor
        leftButton.setTitleColor(theme?.colors.text, for: UIControlState.normal)
        leftButton.titleLabel?.font = theme?.fonts.regular
        rightButton.setTitleColor(theme?.colors.text, for: UIControlState.normal)
        rightButton.titleLabel?.font = theme?.fonts.regular
    }

    fileprivate func layoutViews() {

        leftButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonTopMargin ).isActive = true
        leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonLeftMargin).isActive = true
        leftButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight).isActive = true
        leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth).isActive = true

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
            presentCamera()
        case .library:
            pickImageFromGallery()
        default:
            return
        }
    }

    /// if the add button is pressed, we close the view, (expects to be inside a navigationcontroller)
    /// the submit the image throug the eventbus
    @objc
    fileprivate func addButtonTouchUpInside() {
        if imageSource == .camera, let image = self.containerView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
        if imageSource != .unknown {
            let imageType = ["image_type": imageSource.rawValue]
            client.addBehaviour("screenshot_annotations", imageType)
            SwiftEventBus.postToMainThread("imagePicked", sender: containerView.image)
        }
    }
}
extension UBEditImageMainViewController: CapturePhotoProtocol {
    func cameraCanceled() {
        removeAllViews()
        dismiss(animated: true, completion: nil)
        navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: false)
    }

    func pickPhotoCapturedFromCamera(image: UIImage) {
        addBaseImage(image: image, source: .camera)
        self.dismiss(animated: true, completion: nil)
    }

    func pickPhotoCapturedFromLibrary(image: UIImage) {
        removeAllViews()
        addBaseImage(image: image, source: .library)
        self.dismiss(animated: true, completion: nil)
    }

    func librarySelected() {
        removeAllViews()
        dismiss(animated: true, completion: {
            self.pickImageFromGallery()
        })
    }
}

extension UBEditImageMainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        removeAllViews()
        self.dismiss(animated: true, completion: nil)
        presentCamera()
    }

    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        addBaseImage(image: image, source: .library)
        self.dismiss(animated: true, completion: nil)
    }

}
