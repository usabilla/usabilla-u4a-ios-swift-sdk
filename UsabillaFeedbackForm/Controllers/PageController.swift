//
//  PageController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit
let footerHeight: CGFloat = 80.0

class CustomTableView: UITableView {
    
    func tableViewContentHeight() -> CGFloat {
        var h: CGFloat = 0
        for i in 0..<(dataSource?.tableView(self, numberOfRowsInSection: 0))! {
            h += (delegate?.tableView!(self, heightForRowAt: IndexPath(row: i, section: 0)))!
        }
        return h
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.tableFooterView?.frame
        let contentHeight = self.contentSize.height
        let whiteSpace = self.frame.height - contentHeight
        var footerTop = (whiteSpace - footerHeight) < 0 ? contentHeight - footerHeight : contentHeight + whiteSpace - footerHeight
        frame?.origin.y = footerTop
        self.tableFooterView?.frame = frame!
    }
}

class PageController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var pageModel: PageModel!
    var dynamicFields: [IndexPath] = []
    var requiredLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(StarCellView.self, forCellReuseIdentifier: "stars")
        self.tableView.register(MoodCellView.self, forCellReuseIdentifier: "mood")
        self.tableView.register(SliderCellView.self, forCellReuseIdentifier: "rating")
        self.tableView.register(CheckboxCellView.self, forCellReuseIdentifier: "checkbox")
        self.tableView.register(RadioCellView.self, forCellReuseIdentifier: "radio")
        self.tableView.register(EmailCellView.self, forCellReuseIdentifier: "email")
        self.tableView.register(TextInputCellView.self, forCellReuseIdentifier: "text")
        self.tableView.register(ParagraphCellView.self, forCellReuseIdentifier: "paragraph")
        self.tableView.register(TextAreaCellView.self, forCellReuseIdentifier: "textArea")
        self.tableView.register(ChoiceCellView.self, forCellReuseIdentifier: "choice")
        self.tableView.register(ScreenshotCellView.self, forCellReuseIdentifier: "screenshot")

        self.tableView.tableHeaderView = headerView()

        self.view.backgroundColor = pageModel.themeConfig.backgroundColor
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

        let footer = ViewUtils.generateFooter(themeConfig: pageModel.themeConfig)
        tableView.tableFooterView = footer
        registerEventsBus()
    }

    func registerEventsBus() {
        SwiftEventBus.onMainThread(self, name: "pageUpdatedValues") { _ in
            self.reloadCellInTableAfterEvent()
        }

        SwiftEventBus.onMainThread(self, name: "pick") { _ in
            self.pickImageFromGallery()
        }

        SwiftEventBus.onMainThread(self, name: "updateScreenshotHeight") { _ in
            self.updateScreenshotHeight()
        }

        SwiftEventBus.onMainThread(self, name: "updateMySize") { _ in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }

    func updateScreenshotHeight() {
        for index in self.tableView.visibleCells {
            if let cell = index as? ScreenshotCellView {
                self.reloadCellsWithAnimation([self.tableView.indexPath(for: cell)!])
            }
        }
    }

    func tableViewContentHeight() -> CGFloat {

        var h: CGFloat = 0
        for (index, f) in pageModel.fields.enumerated() {
            h += self.tableView(tableView, heightForRowAt: IndexPath(row: index, section: 0))
        }
        return h
    }

    func reloadCellInTableAfterEvent() {
        var listOfIndexes: [IndexPath] = []
        for index in dynamicFields {
            if let cell = tableView.cellForRow(at: index) as? RootCellView {
                if cell.isCurrentlyDisplayed != cell.shoudlAppear() {
                    listOfIndexes.append(index)
                }
            }
        }
        if listOfIndexes.count > 0 {
            self.reloadCellsWithAnimation(listOfIndexes)
        }
    }

    func headerView() -> UIView? {
        requiredLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        requiredLabel.text = pageModel.errorMessage
        requiredLabel.textAlignment = .right
        requiredLabel.textColor = pageModel.themeConfig.textColor
        requiredLabel.font = pageModel.themeConfig.font.withSize(pageModel.themeConfig.textFontSize)

        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["label": requiredLabel])

        requiredLabel.addConstraints(constraint)

        return requiredLabel
    }

    func deinitPageController() {
        SwiftEventBus.unregister(self)
    }

    func initWithPage(_ page: PageModel) {
        pageModel = page
        dynamicFields = []
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

    func isCorrectlyFilled() -> Bool {
        var correctlyFilled = true

        for field in pageModel.fields {
            if !field.isValid() {
                correctlyFilled = false
            }
        }

        if !correctlyFilled {
            //reloadTableWithAnimation()
            tableView.reloadData()
            requiredLabel.textColor = pageModel.themeConfig.errorColor
        } else {
            requiredLabel.textColor = pageModel.themeConfig.hintColor
        }

        return correctlyFilled
    }

    func whereShouldIJump() -> String? {
        if pageModel.jumpRuleList != nil && pageModel.jumpRuleList!.count > 0 {
            for rule in pageModel.jumpRuleList! {
                if rule.isSatisfied() {
                    return rule.jumpTo
                }
            }
        }
        return pageModel.defaultJumpTo
    }

    //Image handling stuff
    func pickImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func openUsabilla() {
        UIApplication.shared.openURL(URL(string: "http://www.usabilla.com")!)
    }
}

extension PageController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pageModel.fields.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: BaseFieldModel = pageModel.fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type, for: indexPath) as! RootCellView
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.setFeedbackItem(item)
        cell.applyCustomisations()
        if !item.shouldAppear() {
            cell.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.isCurrentlyDisplayed = false
        } else {
            cell.isHidden = false
            cell.isUserInteractionEnabled = true
            cell.isCurrentlyDisplayed = true
        }
        if item.rule != nil && !dynamicFields.contains(indexPath) {
            dynamicFields.append(indexPath)
        }
        return cell
    }
}

extension PageController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !pageModel.fields[indexPath.row].shouldAppear() {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = false
            }
            return 0
        } else if indexPath.section == 1 {
            let whiteSpace = tableView.bounds.size.height - tableViewContentHeight()
            return whiteSpace < footerHeight ? footerHeight : whiteSpace
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = true
            }
            return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !pageModel.fields[indexPath.row].shouldAppear() {
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
