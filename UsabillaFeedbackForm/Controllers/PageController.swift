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

    @IBOutlet weak var tableView: UITableView!
    var pageViewModel: PageViewModel!
    var requiredLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(RootCellView.self, forCellReuseIdentifier: "root")
        self.tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: "footer")

        addHeaderView()

        self.view.backgroundColor = pageViewModel.theme.backgroundColor
        self.tableView.backgroundColor = pageViewModel.theme.backgroundColor

        let gestureReCognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        gestureReCognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureReCognizer)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        registerEventsBus()
    }

    func keyboardWillShow(notification: NSNotification) {
        guard var userInfo = notification.userInfo else {
            return
        }
        guard var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
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
        let indexPath = IndexPath(row: pageViewModel.numberOfCells - 1, section: 0)
        let lastRowFrame = tableView.rectForRow(at: indexPath)
        let emptySpaceHeight = tableView.frame.size.height - (lastRowFrame.origin.y + lastRowFrame.size.height)
        return emptySpaceHeight
    }

    func reloadCellInTableAfterEvent() {
        let listOfIndexes = pageViewModel.dynamicFields.filter {
            pageViewModel.viewModelForCellAt(index: $0)?.isViewCurrentlyVisible != pageViewModel.viewModelForCellAt(index: $0)?.shouldAppear
        }
        let indexPaths: [IndexPath] = listOfIndexes.map {
            IndexPath(row: $0, section: 0)
        }
        if listOfIndexes.count > 0 {
            self.reloadCellsWithAnimation(indexPaths)
        }
    }

    func addHeaderView() {
        requiredLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        requiredLabel.text = pageViewModel.errorMessage
        requiredLabel.textAlignment = .left
        requiredLabel.textColor = pageViewModel.theme.textColor
        requiredLabel.font = pageViewModel.theme.font.withSize(pageViewModel.theme.miniFontSize)
        requiredLabel.backgroundColor = pageViewModel.theme.backgroundColor
        requiredLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = requiredLabel

        requiredLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10).isActive = true
        requiredLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16).isActive = true
    }

    func deinitPageController() {
        SwiftEventBus.unregister(self)
    }

    func initWithViewModel(_ viewModel: PageViewModel) {
        pageViewModel = viewModel
        tableView?.reloadData()
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
        pageViewModel.verifyFields()
        if let index = pageViewModel.indexOfInvalidField() {
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
        return section == 0 ? pageViewModel.numberOfCells : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer", for: indexPath)
            if let cell = cell as? FooterTableViewCell {
                cell.footerView = ViewUtils.generateFooter(themeConfig: pageViewModel.theme)
            }
            cell.backgroundColor = pageViewModel.theme.backgroundColor
            return cell
        }

        let cellViewModel = pageViewModel.viewModelForCellAt(index: indexPath.row)!
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
        if indexPath.section == 0 && !pageViewModel.viewModelForCellAt(index: indexPath.row)!.shouldAppear {
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
        if indexPath.section == 0 && !pageViewModel.viewModelForCellAt(index: indexPath.row)!.shouldAppear {
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
