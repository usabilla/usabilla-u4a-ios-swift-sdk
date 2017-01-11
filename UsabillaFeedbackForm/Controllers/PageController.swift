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
    var pageModel: PageModel!
    var dynamicFields: [IndexPath] = []
    var requiredLabel: UILabel!
    var showErrorMessages = false

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
        self.tableView.register(FooterTableViewCell.self, forCellReuseIdentifier: "footer")

        self.tableView.tableHeaderView = headerView()

        self.view.backgroundColor = pageModel.themeConfig.backgroundColor
        self.tableView.backgroundColor = pageModel.themeConfig.backgroundColor

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
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

        SwiftEventBus.onMainThread(self, name: "reloadCellForModel") { info in
            guard let model = info.userInfo?["model"] as? BaseFieldModel,
                let row = self.pageModel.fields.index( where: { $0 === model })else {
                    return
            }
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
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
        let indexPath = IndexPath(row: pageModel.fields.count - 1, section: 0)
        let lastRowFrame = tableView.rectForRow(at: indexPath)
        let emptySpaceHeight = tableView.frame.size.height - (lastRowFrame.origin.y + lastRowFrame.size.height)
        return emptySpaceHeight
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
        requiredLabel.textAlignment = .left
        requiredLabel.textColor = pageModel.themeConfig.textColor
        requiredLabel.font = pageModel.themeConfig.font.withSize(pageModel.themeConfig.textFontSize)
        requiredLabel.backgroundColor = pageModel.themeConfig.backgroundColor

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
        showErrorMessages = false
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

    func isCorrectlyFilled() -> Bool {
        var correctlyFilled = true

        for (index, field) in pageModel.fields.enumerated() {
            if !field.isValid() {
                let indexPath = IndexPath(row: index, section: 0)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                correctlyFilled = false
            }
        }

        if !correctlyFilled {
            tableView.reloadData()
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

    static func openUsabilla() {
        UIApplication.shared.openURL(URL(string: "http://www.usabilla.com")!)
    }
}

extension PageController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pageModel.fields.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer", for: indexPath)
            if let cell = cell as? FooterTableViewCell {
                cell.footerView = ViewUtils.generateFooter(themeConfig: pageModel.themeConfig)
            }
            cell.backgroundColor = pageModel.themeConfig.backgroundColor
            return cell
        }

        let item: BaseFieldModel = pageModel.fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type, for: indexPath)
        if let cell = cell as? RootCellView {
            cell.showErrorMessage = showErrorMessages
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
