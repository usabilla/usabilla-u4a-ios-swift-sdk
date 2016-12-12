//
//  PageController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit

class PageController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        self.tableView.register(NPSCellView.self, forCellReuseIdentifier: "nps")
        self.tableView.register(ChoiceCellView.self, forCellReuseIdentifier: "choice")
        self.tableView.register(ScreenshotCellView.self, forCellReuseIdentifier: "screenshot")

        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = headerView()

        self.view.backgroundColor = pageModel.themeConfig.backgroundColor
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
        
        SwiftEventBus.onMainThread(self, name: "updateMySize" ) { _ in
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

    func reloadCellInTableAfterEvent () {
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
        let constraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[label]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["label": requiredLabel])

        requiredLabel.addConstraints(constraint)

        return requiredLabel
    }


    func deinitPageController () {
        SwiftEventBus.unregister(self)
    }


    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !pageModel.fields[indexPath.row].shouldAppear() {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = false
            }
            return 0
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = true
            }
            return UITableViewAutomaticDimension
        }
    }


    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if  !pageModel.fields[indexPath.row].shouldAppear() {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageModel.fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = pageModel.fields[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: item.type, for:indexPath) as! RootCellView
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
        if item.rule != nil {
            dynamicFields.append(indexPath)
        }
        return cell
    }


    func initWithPage(_ page: PageModel) {
        pageModel = page
        dynamicFields = []
        self.tableView.reloadData()
        //Magic
    }


    func reloadTableWithAnimation() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = IndexSet(integersIn: range.toRange() ?? 0..<0)
        //self.tableView.reloadData()
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

    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismiss(animated: true, completion: nil)
        SwiftEventBus.postToMainThread("imagePicked", sender: image)
    }


    //    deinit {
    //        print("calling pagecontroller deinit of page \(pageModel.pageName),\(pageModel.pageNumber)")
    //
    //    }
}
