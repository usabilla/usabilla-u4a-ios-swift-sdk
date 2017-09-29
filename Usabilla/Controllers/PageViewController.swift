//
//  PageViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

let footerHeight: CGFloat = 80.0

class PageViewController: UIViewController, UINavigationControllerDelegate {

    var viewModel: PageViewModel!
    var cellHeights: [IndexPath: CGFloat] = [IndexPath: CGFloat]()
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    var requiredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(self.requiredLabel)
        return headerView
    }()

    init(viewModel: PageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        customizeView()

        let gestureReCognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        gestureReCognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureReCognizer)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        registerEventsBus()
    }

    func setUpView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        tableView.topAnchor.constraint(equalTo: view.topAnchor).activate()
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).activate()
        tableView.register(RootCellView.self, forCellReuseIdentifier: "root")
        tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: "footer")
        tableView.canCancelContentTouches = false
        requiredLabel.text = viewModel.errorMessage

        handleHeaderViewVisibility()
    }

    func customizeView() {
        view.backgroundColor = viewModel.theme.colors.background
        tableView.backgroundColor = viewModel.theme.colors.background

        requiredLabel.textColor = viewModel.theme.colors.text
        requiredLabel.font = viewModel.theme.fonts.font.withSize(viewModel.theme.fonts.miniSize)
        requiredLabel.backgroundColor = viewModel.theme.colors.background
    }

    func handleHeaderViewVisibility() {
        if tableView.tableHeaderView == nil {
            tableView.tableHeaderView = headerView
            headerView.heightAnchor.constraint(equalToConstant: 40).activate()
            headerView.leftAnchor.constraint(equalTo: tableView.leftAnchor).activate()
            headerView.rightAnchor.constraint(equalTo: tableView.rightAnchor).activate()
            requiredLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).activate()
            requiredLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor).activate()
            requiredLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).activate()
            tableView.tableHeaderView?.layoutIfNeeded()
        }

        if !viewModel.shouldShowRequiredLabel {
            tableView.tableHeaderView = nil
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        guard viewModel.shouldAddMarginWhenKeyboardIsShown,
            var userInfo = notification.userInfo,
            var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }

        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }

    func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInset
    }

    func registerEventsBus() {
        SwiftEventBus.onMainThread(self, name: "pageUpdatedValues") { _ in
            self.reloadCellInTableAfterEvent()
        }

        SwiftEventBus.onMainThread(self, name: "pick") { _ in
            self.pickImageFromGallery()
        }

        SwiftEventBus.onMainThread(self, name: "updateMySize") { _ in
            let lastScrollOffset = self.tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            self.tableView.setContentOffset(lastScrollOffset, animated: false)
        }
    }

    func tableViewContentHeight() -> CGFloat {
        let sectionFrame = tableView.rect(forSection: 0)
        let emptySpaceHeight = tableView.frame.size.height - (sectionFrame.origin.y + sectionFrame.size.height)
        return emptySpaceHeight
    }

    func reloadCellInTableAfterEvent() {
        let listOfIndexes = viewModel.dynamicFields.filter {
            viewModel.viewModelForCellAt(index: $0)?.isViewCurrentlyVisible != viewModel.viewModelForCellAt(index: $0)?.shouldAppear
        }
        let indexPaths: [IndexPath] = listOfIndexes.map {
            IndexPath(row: $0, section: 0)
        }
        if listOfIndexes.count > 0 {
            self.reloadCellsWithAnimation(indexPaths)
        }
    }

    func deinitPageController() {
        SwiftEventBus.unregister(self)
    }

    func setupViewModel(_ viewModel: PageViewModel) {
        self.viewModel = viewModel
        cellHeights = [:]

        tableView.reloadData()
        tableView.scrollTo(indexPath: IndexPath(row: 0, section: 0), animated: true)
        handleHeaderViewVisibility()
    }

    func reloadTableWithAnimation() {
        let range = 0..<tableView.numberOfSections
        let sections = IndexSet(integersIn: range)
        self.tableView.reloadSections(sections, with: .automatic)
    }

    func reloadCellsWithAnimation(_ indexPaths: [IndexPath]) {

        let tableViewOffset = tableView.contentOffset
        tableView.beginUpdates()

        self.tableView.reloadRows(at: Array(Set(indexPaths)), with: .automatic)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(false)
        tableView.layer.removeAllAnimations()
        tableView.setContentOffset(tableViewOffset, animated: false)
        UIView.setAnimationsEnabled(true)
    }

    func gotToNextErrorField() {
        viewModel.verifyFields()
        if let index = viewModel.indexOfInvalidField() {
            tableView.scrollTo(indexPath: IndexPath(row: index, section: 0), animated: true)
            tableView.reloadData()
        }
    }

    //Image handling stuff
    func pickImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
            present(imagePicker, animated: true, completion: nil)
        }
    }

    static func openUsabilla() {
        // swiftlint:disable:next force_unwrapping
        UIApplication.shared.openURL(URL(string: "http://www.usabilla.com")!)
    }
}

extension PageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.numberOfCells : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer", for: indexPath)
            if let cell = cell as? FooterTableViewCell {
                cell.footerView = ViewUtils.generateFooter(theme: viewModel.theme)
            }
            cell.backgroundColor = viewModel.theme.colors.background
            return cell
        }

        let cellViewModel = viewModel.viewModelForCellAt(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "root", for: indexPath)
        if let cell = cell as? RootCellView {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cellViewModel = cellViewModel
        }
        return cell
    }
}

extension PageViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellViewModel = viewModel.viewModelForCellAt(index: indexPath.row)
            cellViewModel?.updateVisibility()
            return cellViewModel?.isViewCurrentlyVisible == false ? 0 : UITableViewAutomaticDimension
        }
        if indexPath.section == 1 {
            let emptySpace = tableViewContentHeight()
            return emptySpace < footerHeight ? footerHeight : emptySpace
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 0, let cell = viewModel.viewModelForCellAt(index: indexPath.row), !cell.shouldAppear else { return cellHeights[indexPath] ?? UITableViewAutomaticDimension
        }
        return 0
    }
}

extension PageViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: nil)
        SwiftEventBus.postToMainThread("imagePicked", sender: image)
    }
}