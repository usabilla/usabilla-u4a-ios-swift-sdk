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
    var dynamicFields: [NSIndexPath] = []
    var requiredLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(StarCellView.self, forCellReuseIdentifier: "stars")
        self.tableView.registerClass(MoodCellView.self, forCellReuseIdentifier: "mood")
        self.tableView.registerClass(SliderCellView.self, forCellReuseIdentifier: "rating")
        self.tableView.registerClass(CheckboxCellView.self, forCellReuseIdentifier: "checkbox")
        self.tableView.registerClass(RadioCellView.self, forCellReuseIdentifier: "radio")
        self.tableView.registerClass(EmailCellView.self, forCellReuseIdentifier: "email")
        self.tableView.registerClass(TextInputCellView.self, forCellReuseIdentifier: "text")
        self.tableView.registerClass(ParagraphCellView.self, forCellReuseIdentifier: "paragraph")
        self.tableView.registerClass(TextAreaCellView.self, forCellReuseIdentifier: "textArea")
        self.tableView.registerClass(NPSCellView.self, forCellReuseIdentifier: "nps")
        self.tableView.registerClass(ChoiceCellView.self, forCellReuseIdentifier: "choice")
        self.tableView.registerClass(ScreenshotCellView.self, forCellReuseIdentifier: "screenshot")
        
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
    }
    
    
    func updateScreenshotHeight(){
        for index in self.tableView.visibleCells {
            if let cell = index as? ScreenshotCellView {
                self.reloadCellsWithAnimation([self.tableView.indexPathForCell(cell)!])
            }
        }
    }
    
    func reloadCellInTableAfterEvent (){
        var listOfIndexes: [NSIndexPath] = []
        for index in dynamicFields {
            if let cell = tableView.cellForRowAtIndexPath(index) as? RootCellView {
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
        requiredLabel.textAlignment = .Right
        requiredLabel.textColor = pageModel.themeConfig.textColor
        let constraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[label]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["label": requiredLabel])
        
        requiredLabel.addConstraints(constraint)
        
        return requiredLabel
    }
    
    
    func deinitPageController (){
        SwiftEventBus.unregister(self)
    }
    
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if !pageModel.fields[indexPath.row].shouldAppear() {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = false
            }
            return 0
        } else {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? RootCellView {
                cell.isCurrentlyDisplayed = true
            }
            return UITableViewAutomaticDimension
        }
    }
    
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  !pageModel.fields[indexPath.row].shouldAppear() {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageModel.fields.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = pageModel.fields[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(item.type, forIndexPath:indexPath) as! RootCellView
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.setFeedbackItem(item)
        cell.applyCustomisations()
        if !item.shouldAppear() {
            cell.hidden = true
            cell.userInteractionEnabled = false
            cell.isCurrentlyDisplayed = false
        } else {
            cell.hidden = false
            cell.userInteractionEnabled = true
            cell.isCurrentlyDisplayed = true
        }
        if item.rule != nil {
            dynamicFields.append(indexPath)
        }
        return cell
    }
    
    
    func initWithPage(page: PageModel) {
        pageModel = page
        dynamicFields = []
        self.tableView.reloadData()
        //Magic
    }
    
    
    func reloadTableWithAnimation() {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesInRange: range)
        self.tableView.reloadData()
        self.tableView.reloadSections(sections, withRowAnimation: .Automatic)
    }
    
    func reloadCellsWithAnimation(indexPaths: [NSIndexPath]) {
        
        let tableViewOffset = tableView.contentOffset
        tableView.beginUpdates()
        
        self.tableView.reloadRowsAtIndexPaths(Array(Set(indexPaths)), withRowAnimation: .Automatic)
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
            reloadTableWithAnimation()
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        SwiftEventBus.postToMainThread("imagePicked", sender: image)
    }
    
    
//    deinit {
//        print("calling pagecontroller deinit of page \(pageModel.pageName),\(pageModel.pageNumber)")
//        
//    }
}
