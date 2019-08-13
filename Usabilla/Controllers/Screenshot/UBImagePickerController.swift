//
//  UBImagePickerViewController.swift
//  Usabilla
//
//  Created by Anders Liebl on 15/07/2019.
//  Copyright © 2019 Usabilla. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct AlbumModel {
    let date: Date
    let assets: [PHAsset]
}

@objc
protocol UBImagePickerControllerDelegate: NSObjectProtocol {
    @objc
    optional func imagePickerController(_ picker: UBImagePickerController, didFinishPickingImage image: UIImage!)
    @objc
    optional func imagePickerControllerDidCancel(_ picker: UBImagePickerController)
}

class UBImagePickerController: UIViewController {

    fileprivate var orientationPreference: UIInterfaceOrientationMask = [.portrait]
    fileprivate var cameraRollAlbum: [AlbumModel]?
    fileprivate var thumbnailSize: CGSize!
    fileprivate var imageManager: PHCachingImageManager?
    fileprivate var libraryAcces = false
    fileprivate var userScrolled = false

    fileprivate var fallBackMode = false
    weak var delegate: UBImagePickerControllerDelegate?
    let theme: UsabillaTheme
    var client: ClientModel?
    lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 60, height: 60) // just picked any
        layout.scrollDirection = .vertical
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionview)
        collectionview.backgroundColor = .white
        return collectionview
    }()
    lazy var leftButton: UIButton = {
        let button = UIButton()
        view.addSubview(button)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(UBImagePickerController.backButtonTouchUpInside), for: .touchUpInside)
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

    fileprivate lazy var errorMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate lazy var settingsErrorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_library_settings_title"), for: UIControlState.normal)
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.init(rgba: "#5fc9f8"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(didPressSetting), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let titleErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = LocalisationHandler.getLocalisedStringForKey("usa_library_error_title")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let describtionErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = LocalisationHandler.getLocalisedStringForKey("usa_library_error_description")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(theme: UsabillaTheme?, fallBackMode: Bool = false) {
        self.theme = theme ?? UsabillaTheme()
        super.init(nibName: nil, bundle: nil)
        self.fallBackMode = fallBackMode
        if fallBackMode {
            orientationPreference = [UIInterfaceOrientationMask.all]
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Rotation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return orientationPreference
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let aFrame = CGRect(x: 0, y: 0, width: DeviceInfo.getMaxFormWidth(), height: DeviceInfo.getMaxFormHeight())
        view.frame = aFrame
        layoutViews()
        setupUI()
        view.backgroundColor = .white
        testAndGetLibraryAccess()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridViewCell.self, forCellWithReuseIdentifier: "girdcell")
        collectionView.register(GridViewSectionCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "girdcellsection")
        let width: CGFloat = DeviceInfo.getMaxFormWidth()
        thumbnailSize = CGSize(width: (width/UBDimensions.UBImagePickerView.numberOfImagesPrRow), height: (width/UBDimensions.UBImagePickerView.numberOfImagesPrRow))
        scrollToLastItem()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !userScrolled {
            scrollToLastItem()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        userScrolled = true
    }

    fileprivate func setupUI() {
        leftButton.setTitleColor(UIColor.init(rgba: "#5fc9f8"), for: UIControlState.normal)
        leftButton.setTitleColor(UIColor.init(rgba: "#5fc9f8").withAlphaComponent(0.5), for: UIControlState.selected)
        leftButton.setTitleColor(UIColor.init(rgba: "#5fc9f8"), for: UIControlState.highlighted)
        leftButton.titleLabel?.font = theme.fonts.regular
        titleLabel.font = theme.fonts.boldFont
        titleLabel.textColor = theme.colors.title

        leftButton.setTitle(LocalisationHandler.getLocalisedStringForKey("usa_back_button_title"), for: UIControlState.normal)
    }

    fileprivate func layoutViews() {
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor,
                                            constant: (fallBackMode ? UBDimensions.UBImagePickerView.fallBackNavBarHeigth: barHeight()) ).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UBDimensions.UBImagePickerView.collectionLeftSideMargin).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UBDimensions.UBImagePickerView.collectionRightSideMargin).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: UBDimensions.UBImagePickerView.collectionBottomMargin).isActive = true

        leftButton.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: UBDimensions.UBImagePickerView.leftButtonBottomMargin ).isActive = true
        leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UBDimensions.UBImagePickerView.leftButtonLeftMargin).isActive = true
        leftButton.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBImagePickerView.buttonHeight).isActive = true
        leftButton.widthAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBImagePickerView.buttonWidth).isActive = true

        titleLabel.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: UBDimensions.UBImagePickerView.titleLabelTopMargin).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
    }
    func addErrorViewConstraints() {
        errorMessageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        titleErrorLabel.topAnchor.constraint(equalTo: errorMessageView.topAnchor, constant: UBDimensions.UBImagePickerView.errroViewMargin).isActive = true
        titleErrorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBImagePickerView.errroViewContentHeight).isActive = true
        titleErrorLabel.leadingAnchor.constraint(equalTo: errorMessageView.leadingAnchor, constant: UBDimensions.UBImagePickerView.errroViewMargin).isActive = true
        titleErrorLabel.trailingAnchor.constraint(equalTo: errorMessageView.trailingAnchor, constant: -UBDimensions.UBImagePickerView.errroViewMargin).isActive = true

        describtionErrorLabel.topAnchor.constraint(equalTo: titleErrorLabel.bottomAnchor, constant: UBDimensions.UBImagePickerView.errroViewMargin).isActive = true
        describtionErrorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: UBDimensions.UBImagePickerView.errroViewContentHeight).isActive = true
        describtionErrorLabel.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        describtionErrorLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UBDimensions.UBImagePickerView.errroViewDescribtionMaxWidth).isActive = true

        settingsErrorButton.topAnchor.constraint(equalTo: describtionErrorLabel.bottomAnchor, constant: UBDimensions.UBImagePickerView.errroViewMargin).isActive = true
        settingsErrorButton.centerXAnchor.constraint(equalTo: errorMessageView.centerXAnchor).isActive = true
        settingsErrorButton.bottomAnchor.constraint(equalTo: errorMessageView.bottomAnchor, constant: -UBDimensions.UBImagePickerView.errroViewContentHeight).isActive = true
    }

    /// Asks for acces to the photolibrary. If granted, fetches the newest photo from the camera roll
    /// and installs it in the button view
    fileprivate func testAndGetLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.authorized {
            imageManager = PHCachingImageManager()
            libraryAcces = true
            queryForCameraRollPhoto()
            return
        }
        if status == PHAuthorizationStatus.denied {
            libraryAcces = false
            addErrorView()
        }
        PHPhotoLibrary.requestAuthorization({ [unowned self] (newStatus) in
            if newStatus == PHAuthorizationStatus.authorized {
                self.imageManager = PHCachingImageManager()
                self.libraryAcces = true
                DispatchQueue.main.async {
                    self.queryForCameraRollPhoto()
                }
            }
        })
    }
    /// Retrieves the latest image from the Camera Roll,
    /// once found, it is set on the image of this class
    /// - Parameter size: size for the image, defaults to CGSize.zero
    ///
    fileprivate func queryForCameraRollPhoto() {

        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        //let allPhotos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumMyPhotoStream, options: nil)
        cameraRoll.enumerateObjects({ (object: AnyObject!, count: Int, _: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                if let obj: PHAssetCollection = object as? PHAssetCollection {

                    let fetchOptions = PHFetchOptions()
                    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                    let assets = PHAsset.fetchAssets(in: obj, options: fetchOptions)
                    if assets.count > 0 {
                        var fetchedAssets = [Date: [PHAsset]]()
                        assets.enumerateObjects({ (object, _, _) in
                            let asset: PHAsset = object
                            if let dateComponents = asset.creationDate?.stripTime() {
                                if fetchedAssets[dateComponents] == nil {
                                    fetchedAssets[dateComponents] = [asset]
                                } else {
                                    fetchedAssets[dateComponents]?.append(asset)
                                }
                            }
                        })
                        var data: [AlbumModel] = []
                        let keys = fetchedAssets.keys
                        keys.forEach {
                            if let models = fetchedAssets[$0] {
                                data.append(AlbumModel(date: $0, assets: models))
                            }
                        }
                        self.cameraRollAlbum = data.sorted(by: { $0.date < $1.date })
                    }
                }
            }
        })
    }

    func addErrorView() {
        errorMessageView.addSubview(titleErrorLabel)
        errorMessageView.addSubview(describtionErrorLabel)
        errorMessageView.addSubview(settingsErrorButton)

        view.addSubview(errorMessageView)
        titleErrorLabel.font = theme.fonts.boldFont
        addErrorViewConstraints()
    }

    // MARK: - Action methods
    @objc
    fileprivate func backButtonTouchUpInside() {
        if fallBackMode {
            dismiss(animated: true, completion: nil)
        }
        delegate?.imagePickerControllerDidCancel?(self)
    }
    func scrollToLastItem() {
        let lastSection = collectionView.numberOfSections - 1
        if lastSection < 0 { return }
        let lastRow = collectionView.numberOfItems(inSection: lastSection)
        let indexPath = IndexPath(row: lastRow - 1, section: lastSection)
        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
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
}

extension UBImagePickerController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension UBImagePickerController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numbers =  cameraRollAlbum?[section].assets.count {
            return numbers
        }
        return 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cameraRollAlbum?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let asset = cameraRollAlbum?[indexPath.section].assets[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "girdcell"), for: indexPath) as? GridViewCell
                else { fatalError("unexpected cell in collection view") }

            cell.representedAssetIdentifier = asset.localIdentifier
            imageManager?.requestImage(for: asset, targetSize: CGSize(width: self.thumbnailSize.height*2, height: self.thumbnailSize.height*2), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    // adjust the image to take the border into account
                    let size = CGSize(width: self.thumbnailSize.width-UBDimensions.UBImagePickerView.imageBorder, height: self.thumbnailSize.height-UBDimensions.UBImagePickerView.imageBorder)
                    cell.thumbnailImage = image?.crop(size)
                }
            })

            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: UBDimensions.UBImagePickerView.headerViewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "girdcellsection", for: indexPath) as? GridViewSectionCell {
                headerView.titleLabel.text = cameraRollAlbum?[indexPath.section].date.relativeDate()
                return headerView
            }
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let asset = cameraRollAlbum?[indexPath.section].assets[indexPath.row] {
            imageManager?.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
                if let aImage = image {
                    if self.fallBackMode {
                        self.fallBackSelection(image: aImage)
                        return
                    }
                    self.delegate?.imagePickerController?(self, didFinishPickingImage: aImage)
                }
            })
        }
    }
    // if we are in fallback mode we will send the image and statistics
    fileprivate func fallBackSelection(image: UIImage) {
        dismiss(animated: true, completion: nil)
        let imageType = ["image_type": UBimageSource.library.rawValue]
        client?.addBehaviour("screenshot_annotations", imageType)
        SwiftEventBus.postToMainThread("imagePicked", sender: image)
    }
 }
