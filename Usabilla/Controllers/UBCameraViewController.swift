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
}
/*
 UBCameraViewController shows the imagepicker view
with camera view
*/
class UBCameraViewController: UIViewController {
    // should be moved to UBConstants once rebased
    // into feature with develop
    struct UBCameraView {
        static let bottomMarginBtnCamera: CGFloat = -20
        static let bottomMarginPreviewCamera: CGFloat = -20
        static let cameraBtnImageName: String = "camerabtn"
    }
    weak var delegate: CapturePhotoProtocol?
    // capture button defualt like ios camera
    fileprivate lazy var captureButton: UIButton = {
        let cameraImage = UIImage.getImageFromSDKBundle(name: UBCameraView.cameraBtnImageName)
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
        view.contentMode = UIView.ContentMode.scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// imageLibraryButtonView contains preview image
    /// first captured image and on click opens image library (gallery)
    private var imageLibraryButtonView: UIView?
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            setupCaptureSession()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (authorized) in
                DispatchQueue.main.async {
                    if authorized {
                        self.setupCaptureSession()
                    }
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    private func setupNavigationBar() {
        let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationItem.leftBarButtonItem = backItem
    }
    func setupView() {
        view.addSubview(captureButton)
        view.addSubview(previewView)
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UBCameraView.bottomMarginBtnCamera),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: UBCameraView.bottomMarginPreviewCamera)
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.bounds = view.frame
    }
    // MARK: - Rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    // setup and starting camera session
    private func setupCaptureSession() {
        guard captureSession.inputs.isEmpty else { return }
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
            preview.backgroundColor = UIColor.gray.cgColor
            preview.videoGravity = .resizeAspect
            self.previewLayer = preview
            let rootLayer: CALayer = self.previewView.layer
            rootLayer.masksToBounds=true
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
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
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
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopCaptureSession()
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
                    self.checkPermissionAndSaveImage(imageData: imageData)
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
    private func checkPermissionAndSaveImage(imageData: Data) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            self.saveImage(imageData: imageData)
        } else if status == .notDetermined {
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { reqStatus in
                if reqStatus == .authorized {
                    self.saveImage(imageData: imageData)
                } else {
                }
            }
        } else {
        }
    }
    private func saveImage(imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        try? PHPhotoLibrary.shared().performChangesAndWait {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            self.stopCaptureSession()
            self.delegate?.pickPhotoCapturedFromCamera(image: image)
        }
    }
    deinit {
        self.teardownAVCapture()
    }
}
@available(iOS 10.0, *)
extension UBCameraViewController: AVCapturePhotoCaptureDelegate {
    @available(iOS, deprecated: 11.0)
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,resolvedSettings: AVCaptureResolvedPhotoSettings,bracketSettings: AVCaptureBracketedStillImageSettings?,error: Swift.Error?) {
        if let error = error {
            print("Error capture image: \(error.localizedDescription)")
        } else if let buffer = photoSampleBuffer,let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer,previewPhotoSampleBuffer: nil) {
            self.checkPermissionAndSaveImage(imageData: imageData)
        }
    }
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capture image: \(error.localizedDescription)")
        } else {
            guard let imageData = photo.fileDataRepresentation() else { return }
            self.checkPermissionAndSaveImage(imageData: imageData)
        }
    }
}
