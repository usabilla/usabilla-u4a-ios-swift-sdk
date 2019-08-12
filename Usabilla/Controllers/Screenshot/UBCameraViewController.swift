//
//  UBCameraViewController.swift
//  Usabilla
//
//  Created by Hitesh Jain on 26/06/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

/*
 This method get called when there is a image clicked
 and populated to screenshot placerholder
 */
protocol CapturePhotoProtocol: class {
    func pickPhotoCapturedFromCamera(image: UIImage)
    func cameraCanceled()
    func librarySelected()
}
/*
 UBCameraViewController shows the imagepicker view
 with camera view
 */
// swiftlint:disable file_length
class UBCameraViewController: UIViewController {

    weak var delegate: CapturePhotoProtocol?
    var theme: UsabillaTheme?
    weak var previewConstraint: NSLayoutConstraint?
    private var _captureOutput: AVCaptureOutput!

    // capture button default like ios camera
    fileprivate lazy var captureButton: UIButton = {
        let cameraImage = UIImage.getImageFromSDKBundle(name: UBDimensions.UBCameraView.cameraBtnImageName)
        let button = UIButton(type: .custom)
        button.setImage(cameraImage, for: UIControlState())
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTakePhoto), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // previewView contains camera frame
    fileprivate lazy var previewView: UIView = {
        let view = UIView()
        #if targetEnvironment(simulator)
            view.backgroundColor = .white
        #endif
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Error view
    fileprivate lazy var errorMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBCameraView.leftBarBtnText)
        button.contentHorizontalAlignment = .left
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(.white, for: UIControlState.normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: UIControlState.highlighted)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    fileprivate lazy var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_camera_settings_title"), for: UIControlState.normal)
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.init(rgba: "#5fc9f8"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(didPressSetting), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = LocalisationHandler.getLocalisedStringForKey("usa_camera_error_title")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let describtionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = LocalisationHandler.getLocalisedStringForKey("usa_camera_error_description")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// imageLibraryButtonView contains preview image
    /// first captured image and on click opens image library (gallery)
    fileprivate lazy var imageLibraryButtonView: UBImageLibraryButton = {
        let view = UBImageLibraryButton()
        view.delegate = self
        view.clipsToBounds = true
        view.layer.cornerRadius = UBDimensions.UBCameraView.cornerRadiusBtnImageLibrary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @available(iOS 10.0, *)
    private var photoOutput: AVCapturePhotoOutput! {
        get {
            return _captureOutput as? AVCapturePhotoOutput
        }
        set {
            _captureOutput = newValue
        }
    }

    @available(iOS, deprecated: 10.0)
    private var stillImageOutput: AVCaptureStillImageOutput! {
        get {
            return _captureOutput as? AVCaptureStillImageOutput
        }
        set {
            _captureOutput = newValue
        }
    }

    lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()

    var previewLayer: AVCaptureVideoPreviewLayer!
    let sampleBufferQueue = DispatchQueue.global(qos: .userInteractive)

    // set the status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - lifecycle methods
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        setConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            setupCaptureSession()
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (authorized) in
                DispatchQueue.main.async {
                    if authorized {
                        self.setupCaptureSession()
                        return
                    }
                    self.addErrorView()
                }
            })
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            self.addErrorView()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopCaptureSession()
    }

    deinit {
        self.teardownAVCapture()
    }

    // MARK: - Rotation
    private var orientationPreference: UIInterfaceOrientationMask = DeviceInfo.isIPad() ? [.all] : [.portrait]
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientationPreference
    }

    // MARK: - Actions
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cameraCanceled()
    }

    @objc func didPressSetting(_ sender: Any) {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func didTakePhoto(_ sender: Any) {
        if #available(iOS 10.0, *) {
            takePictureWithPhotoOutput()
        } else {
            takePictureWithStillImageOutput()
        }
    }

}
// MARK: - camera session
extension UBCameraViewController {
    private func setupCaptureSession() {
        #if targetEnvironment(simulator)
            return
        #else
        guard captureSession.inputs.isEmpty else {
                captureSession.startRunning()
                return
        }
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let cameraInput = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(cameraInput)
            let preview = AVCaptureVideoPreviewLayer(session: captureSession)
            preview.frame = view.bounds
            //preview.backgroundColor = UIColor.gray.cgColor
            preview.videoGravity = .resizeAspectFill
            self.previewLayer = preview
            let rootLayer: CALayer = self.previewView.layer
            rootLayer.masksToBounds = true
            rootLayer.addSublayer(self.previewLayer)
            self.configureVideoOrientation()
            setImageOutput(session: captureSession)
            captureSession.startRunning()
        } catch let error {
            print("Error creating capture session: \(error.localizedDescription)")
            self.teardownAVCapture()
            return
        }
        #endif
    }

    private func configureVideoOrientation() {
        if let previewLayer = self.previewLayer,
            let connection = previewLayer.connection {
            let orientation = UIDevice.current.orientation

            if connection.isVideoOrientationSupported,
                let videoOrientation = AVCaptureVideoOrientation(rawValue: orientation.rawValue) {
                previewLayer.frame = self.view.bounds
                connection.videoOrientation = videoOrientation
            }
        }
    }

    // clean up capture setup
    private func teardownAVCapture() {
        if #available(iOS 10.0, *) {
            photoOutput = nil
        } else {
            stillImageOutput = nil
        }
        if previewLayer != nil {
            previewLayer.removeFromSuperlayer()
            previewLayer = nil
        }
    }

    private func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    private func setImageOutput(session: AVCaptureSession) {
        // Make a still image output
        if #available(iOS 10.0, *) {
            photoOutput = AVCapturePhotoOutput()
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }
        } else {
            stillImageOutput = AVCaptureStillImageOutput()
            if session.canAddOutput(stillImageOutput) {
                session.addOutput(stillImageOutput)
            }
        }
    }

    private func takePictureWithStillImageOutput() {
        guard let stillImageConnection = stillImageOutput.connection(with: .video) else { return }
        stillImageOutput.captureStillImageAsynchronously(from: stillImageConnection) { imageDataSampleBuffer, error in
            if let error = error as NSError? {
                print("Error capture image: \(error.localizedDescription)")
            } else {
                if let sampleBuffer = imageDataSampleBuffer {
                    guard let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        else { return }
                    self.saveImage(imageData: imageData)
                }
            }
        }
    }

    @available(iOS 10.0, *)
    private func takePictureWithPhotoOutput() {
        var outputFormat: [String: Any] = [:]
        if #available(iOS 11.0, *) {
            outputFormat = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        } else {
            outputFormat = [AVVideoCodecKey: AVVideoCodecJPEG]
        }
        let settings = AVCapturePhotoSettings(format: outputFormat)
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }

    private func saveImage(imageData: Data) {

        var imageOrientation: UIImageOrientation = UIImageOrientation.up
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            imageOrientation = UIImageOrientation.left
        case UIDeviceOrientation.landscapeRight:
            imageOrientation = UIImageOrientation.down
        case UIDeviceOrientation.landscapeLeft:
            imageOrientation = UIImageOrientation.up
        case UIDeviceOrientation.portrait:
            imageOrientation = UIImageOrientation.right
        default:
            imageOrientation = UIImageOrientation.right
        }
        guard  let aimage = UIImage(data: imageData),
               let cgImage: CGImage = aimage.cgImage else { return }
        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: imageOrientation)
        self.stopCaptureSession()
        self.delegate?.pickPhotoCapturedFromCamera(image: image)
    }
}
    // MARK: - layout
extension UBCameraViewController {
    func setupView() {
        view.addSubview(backButton)
        view.addSubview(imageLibraryButtonView)
        view.addSubview(captureButton)
        view.addSubview(previewView)
    }

    private func setConstraints() {
        previewConstraint = previewView.topAnchor.constraint(equalTo: view.topAnchor, constant: barHeight())
        previewConstraint?.isActive = true
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: UBDimensions.UBCameraView.bottomMarginPreviewCamera),
            backButton.bottomAnchor.constraint(equalTo: previewView.topAnchor, constant: UBDimensions.UBCameraView.cancelButtonBottomMargin ),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBEditImageMainView.leftButtonLeftMargin),
            backButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonHeight),
            backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBEditImageMainView.buttonWidth),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UBDimensions.UBCameraView.bottomMarginBtnCamera),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLibraryButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UBDimensions.UBCameraView.leftMarginBtnImageLibrary),
            imageLibraryButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UBDimensions.UBCameraView.bottomMarginBtnImageLibrary),
            imageLibraryButtonView.heightAnchor.constraint(equalToConstant: UBDimensions.UBCameraView.heightBtnImageLibrary),
            imageLibraryButtonView.widthAnchor.constraint(equalToConstant: UBDimensions.UBCameraView.widthBtnImageLibrary)
            ])

    }

    func addErrorView() {
        errorMessageView.addSubview(titleLabel)
        errorMessageView.addSubview(describtionLabel)
        errorMessageView.addSubview(settingsButton)

        view.addSubview(errorMessageView)

        if let theme = theme {
            titleLabel.font = theme.fonts.boldFont
        }
        captureButton.isEnabled = false
        addErrorViewConstraints()
    }

    func addErrorViewConstraints() {
        errorMessageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: errorMessageView.topAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBCameraView.errroViewContentHeight).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: errorMessageView.leadingAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: errorMessageView.trailingAnchor, constant: -UBDimensions.UBCameraView.errroViewMargin).isActive = true

        describtionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        describtionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBCameraView.errroViewContentHeight).isActive = true
        describtionLabel.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        describtionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UBDimensions.UBCameraView.errroViewDescribtionMaxWidth).isActive = true

        settingsButton.topAnchor.constraint(equalTo: describtionLabel.bottomAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        settingsButton.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: errorMessageView.bottomAnchor, constant: -UBDimensions.UBCameraView.errroViewContentHeight).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

}
    // MARK: - AVCapture deleagte
// swiftlint:disable function_parameter_count
@available(iOS 10.0, *)
extension UBCameraViewController: AVCapturePhotoCaptureDelegate {

    @available(iOS, deprecated: 11.0)
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Swift.Error?) {
        if let error = error {
            print("Error capture image: \(error.localizedDescription)")
        } else if let buffer = photoSampleBuffer,
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer,
                previewPhotoSampleBuffer: nil) {
            self.saveImage(imageData: imageData)
        }
    }

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capture image: \(error.localizedDescription)")
        } else {
            guard let imageData = photo.fileDataRepresentation() else { return }
            self.saveImage(imageData: imageData)
        }
    }

}
// MARK: - Library button delegate
extension UBCameraViewController: UBImageLibraryButtonProtocol {
    func UBtouchUpInside() {
        self.delegate?.librarySelected()
    }
}

extension UBCameraViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.configureVideoOrientation()
        self.previewConstraint?.isActive = false
        coordinator.animate(alongsideTransition: { [weak self] (_ : UIViewControllerTransitionCoordinatorContext) in
            if let heigth = self?.barHeight(), let anchor = self?.view.topAnchor {
                self?.previewConstraint = self?.previewView.topAnchor.constraint(equalTo: anchor, constant: heigth)
                self?.previewConstraint?.isActive = true
                self?.previewView.setNeedsLayout()
            }
        })
    }
}
