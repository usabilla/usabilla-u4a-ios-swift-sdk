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
class UBCameraViewController: UIViewController {

    weak var delegate: CapturePhotoProtocol?
    var theme: UsabillaTheme?
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

    private var _captureOutput: AVCaptureOutput!

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

    // MARK: - Properties
    lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        return session
    }()

    var previewLayer: AVCaptureVideoPreviewLayer!
    let sampleBufferQueue = DispatchQueue.global(qos: .userInteractive)

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // set the status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            setupNavigationBar()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
    }

    private func setupNavigationBar() {
        let title = LocalisationHandler.getLocalisedStringForKey(UBDimensions.UBCameraView.leftBarBtnText)
        let backItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(cancelButtonPressed))
        self.navigationItem.leftBarButtonItem = backItem
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
    }

    func setupView() {
        view.addSubview(imageLibraryButtonView)
        view.addSubview(captureButton)
        view.addSubview(previewView)
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UBDimensions.UBCameraView.bottomMarginBtnCamera),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageLibraryButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UBDimensions.UBCameraView.leftMarginBtnImageLibrary),
            imageLibraryButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UBDimensions.UBCameraView.bottomMarginBtnImageLibrary),
            imageLibraryButtonView.heightAnchor.constraint(equalToConstant: UBDimensions.UBCameraView.heightBtnImageLibrary),
            imageLibraryButtonView.widthAnchor.constraint(equalToConstant: UBDimensions.UBCameraView.widthBtnImageLibrary),
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: UBDimensions.UBCameraView.bottomMarginPreviewCamera)
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
        describtionLabel.leadingAnchor.constraint(equalTo: errorMessageView.leadingAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        describtionLabel.trailingAnchor.constraint(equalTo: errorMessageView.trailingAnchor, constant: -UBDimensions.UBCameraView.errroViewMargin).isActive = true

        settingsButton.topAnchor.constraint(equalTo: describtionLabel.bottomAnchor, constant: UBDimensions.UBCameraView.errroViewMargin).isActive = true
        settingsButton.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: errorMessageView.bottomAnchor, constant: -UBDimensions.UBCameraView.errroViewContentHeight).isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    // MARK: - Rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }

    // setup and starting camera session
    private func setupCaptureSession() {
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
            setImageOutput(session: captureSession)
            captureSession.startRunning()
        } catch let error {
            print("Error creating capture session: \(error.localizedDescription)")
            self.teardownAVCapture()
            return
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

    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cameraCanceled()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopCaptureSession()
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
        guard let image = UIImage(data: imageData) else { return }
        self.stopCaptureSession()
        self.delegate?.pickPhotoCapturedFromCamera(image: image)
    }

    deinit {
        self.teardownAVCapture()
    }

}

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
            //self.checkPermissionAndSaveImage(imageData: imageData)
        }
    }

    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capture image: \(error.localizedDescription)")
        } else {
            guard let imageData = photo.fileDataRepresentation() else { return }
            self.saveImage(imageData: imageData)
            //self.checkPermissionAndSaveImage(imageData: imageData)
        }
    }

}

extension UBCameraViewController: UBImageLibraryButtonProtocol {
    func UBtouchUpInside() {
        self.delegate?.librarySelected()
    }

}
