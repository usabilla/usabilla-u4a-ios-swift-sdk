//
//  UBImageLibraryButton.swift
//  Usabilla
//
//  Created by Anders Liebl on 26/06/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit
import Photos

/// Called when there is a touch-up event inside the view
protocol UBImageLibraryButtonProtocol: class {
    func UBtouchUpInside()
}

/// UIView that acts as button.
/// It reads from the users camera-roll and uses the latest image
/// as background. If the Camera-roll is updated the image is replaced
///
/// It asks for permission from the iOS to obtain read access.
///
/// If the delegate is set it will respond to "touchUpInside" events

class UBImageLibraryButton: UIView {
    
    weak var delegate: UBImageLibraryButtonProtocol?

    fileprivate lazy var button: UIButton = {
        let button = UIButton()
        addSubview(button)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UBImageLibraryButton.buttonTouchUpInside), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        testAndGetLibraryAccess()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    fileprivate func configureView () {
        
        self.backgroundColor = .clear
        
        image.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        image.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true

        button.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }

    @objc
    fileprivate func buttonTouchUpInside() {
        delegate?.UBtouchUpInside()
    }
    
    /// Asks for acces to the photolibrary. If granted, fetches the newest photo from the camera roll
    /// and installs it in the button view
    fileprivate func testAndGetLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.authorized {
            PHPhotoLibrary.shared().register(self)
            queryForCameraRollPhoto(size: image.frame.size)
            return
        }
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            if newStatus == PHAuthorizationStatus.authorized {
                PHPhotoLibrary.shared().register(self)
                self.queryForCameraRollPhoto(size: self.image.frame.size)
            }
        })
    }
    
    /// Retrieves the latest image from the Camera Roll,
    /// once found, it is set on the image of this class
    /// - Parameter size: size for the image, defaults to CGSize.zero
    ///
    fileprivate func queryForCameraRollPhoto(size: CGSize = CGSize.zero) {
        let imgManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1

        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let last = allPhotos.lastObject {
            let scale = UIScreen.main.scale
            let calculatedSize = CGSize(width: size.width * scale, height: size.height * scale)
            let options = PHImageRequestOptions()
            imgManager.requestImage(for: last, targetSize: calculatedSize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, _) in
                if let image = image {
                    self.image.image = image
                }
            })
        }
    }
}

extension UBImageLibraryButton: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        queryForCameraRollPhoto(size: image.frame.size)
    }

}
