//
//  PageController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit
let footerHeight: CGFloat = 80.0

class PageController: UIViewController, UINavigationControllerDelegate {

    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    var requiredLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        label.textAlignment = .left
        return label
    }()

    var viewModel: PageViewModel!
    var addMarginWhenKeyboardIsShown: Bool = false

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

        requiredLabel.text = viewModel.errorMessage
        tableView.tableHeaderView = requiredLabel
        requiredLabel.translatesAutoresizingMaskIntoConstraints = false
        requiredLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10).isActive = true
        requiredLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16).isActive = true
    }

    func customizeView() {
        view.backgroundColor = viewModel.theme.backgroundColor
        tableView.backgroundColor = viewModel.theme.backgroundColor

        requiredLabel.textColor = viewModel.theme.textColor
        requiredLabel.font = viewModel.theme.font.withSize(viewModel.theme.miniFontSize)
        requiredLabel.backgroundColor = viewModel.theme.backgroundColor
    }

    func keyboardWillShow(notification: NSNotification) {
        guard addMarginWhenKeyboardIsShown,
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
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    func tableViewContentHeight() -> CGFloat {
        let indexPath = IndexPath(row: viewModel.numberOfCells - 1, section: 0)
        let lastRowFrame = tableView.rectForRow(at: indexPath)
        let emptySpaceHeight = tableView.frame.size.height - (lastRowFrame.origin.y + lastRowFrame.size.height)
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
        tableView.reloadData()
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
            let indexPath = IndexPath(row: index, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        UIApplication.shared.openURL(URL(string: "http://www.usabilla.com")!)
    }
}

extension PageController: UITableViewDataSource {
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
            cell.backgroundColor = viewModel.theme.backgroundColor
            return cell
        }

        let cellViewModel = viewModel.viewModelForCellAt(index: indexPath.row)!
        let cell = tableView.dequeueReusableCell(withIdentifier: "root", for: indexPath)
        if let cell = cell as? RootCellView {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.cellViewModel = cellViewModel
        }
        return cell
    }
}

extension PageController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !viewModel.viewModelForCellAt(index: indexPath.row)!.shouldAppear {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = false
            }
            return 0
        } else if indexPath.section == 1 {
            let emptySpace = tableViewContentHeight()
            return emptySpace < footerHeight ? footerHeight : emptySpace
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = true
            }
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !viewModel.viewModelForCellAt(index: indexPath.row)!.shouldAppear {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }

}

extension PageController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: nil)
        SwiftEventBus.postToMainThread("imagePicked", sender: image)
    }
}
