//
//  FormViewController.swift
//  ubform_swift
//
//  Created by Giacomo Pinato on 01/03/16.
//  Copyright © 2016 Usabilla. All rights reserved.
//

import UIKit


class FormViewController: UIViewController {
    
    var currentPage = 0
    var formModel: FormModel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    //Views
    
    @IBOutlet weak var poweredLabel: UILabel!
    @IBOutlet weak var leftNavItem: UIBarButtonItem!
    @IBOutlet weak var rightNavItem: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    
    var pageController: PageController!
    var thankYouController: ThankYouController!
    
    
    var customVars: [String: AnyObject]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeToPage(0)
        if formModel.pages.count == 2 {
            progressBar.hidden = true
        } else {
            progressBar.progressTintColor = UsabillaThemeConfigurator.sharedInstance.accentColor
        }
        poweredLabel.textColor = UsabillaThemeConfigurator.sharedInstance.headerTextColor
        
        poweredLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FormViewController.openUsabilla)))
        updateProgressBar()
        updateRightButton()
        
        self.navigationController?.navigationBar.barStyle = UsabillaThemeConfigurator.sharedInstance.statusBarColor
        self.navigationController?.navigationBar.barTintColor = UsabillaThemeConfigurator.sharedInstance.headerColor
        self.navigationController?.navigationBar.tintColor = UsabillaThemeConfigurator.sharedInstance.headerTextColor
        footerView.backgroundColor = UsabillaThemeConfigurator.sharedInstance.headerColor
        
        SwiftEventBus.onMainThread(self, name: "restoreForm") { _ in
            self.restoreFeedbackFormController()
        }
        
        leftNavItem.title = NSLocalizedString("usa_form_close_button", tableName: UsabillaFeedbackForm.localizedStringFile, bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!, comment: "")
        
        if !UsabillaFeedbackForm.showCancelButton {
            leftNavItem.title = ""
            leftNavItem.enabled = false
        }
    }
    
    
    func openUsabilla() {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.usabilla.com")!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PageController
            where segue.identifier == "embedSegue" {
            self.pageController = vc
            pageController.initWithPage(formModel.pages[0])
        }
    }
    
    @IBAction func rightBarButtonPressed(sender: UIBarButtonItem) {
        
        if pageController.isCorrectlyFilled() {
            let newPageIndex = selectNewPage()
            //If I'm at the last page, submit and don't change
            if currentPage == formModel.pages.count - 2 || newPageIndex == formModel.pages.count - 1 {
                submitForm()
                showThankYouPage()
            } else {
                swipeToPage(newPageIndex)
                updateProgressBar()
                updateRightButton()
            }
        }
    }
    
    
    
    func showThankYouPage() {
        progressBar.setProgress(1, animated: true)
        rightNavItem.title = ""
        rightNavItem.enabled = false
        
        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        thankYouController = storyboard.instantiateViewControllerWithIdentifier("thankYou") as? ThankYouController
        
        var headerFieldValue: String?
        var thanksFieldValue: String?
        if let header: HeaderFieldModel = formModel.pages.last?.fields[0] as? HeaderFieldModel {
            headerFieldValue = header.fieldValue
        }
        if let thank: StringFieldModel = formModel.pages.last?.fields[1] as? StringFieldModel {
            thanksFieldValue = thank.fieldValue
        }
        
        let moodValue = formModel.pages.first?.fields[0] as? IntFieldModel

        pageController.willMoveToParentViewController(nil)
        addChildViewController(thankYouController)
        thankYouController.view.frame = containerView.bounds
        
        
        transitionFromViewController(pageController, toViewController: thankYouController, duration: 0.5, options: .TransitionCrossDissolve, animations: nil, completion: nil)
        
        thankYouController.setUpController(moodValue?.fieldValue > 3, thankTitle: headerFieldValue, thankMessage: thanksFieldValue)
        
    }
    
    func restoreFeedbackFormController() {
        resetAndRestartForm()
        thankYouController.willMoveToParentViewController(nil)
        addChildViewController(pageController)
        pageController.view.frame = containerView.bounds
        transitionFromViewController(thankYouController, toViewController: pageController, duration: 0.5, options: .TransitionCrossDissolve, animations: nil, completion: nil)
        updateRightButton()
        updateProgressBar()
    }
    
    func resetAndRestartForm() {
        currentPage = 0
        formModel = JSONFormParser.parseFormJson(formModel.formJsonString, appId: formModel.appId, screenshot: nil)
        pageController.initWithPage(formModel.pages[0])
    }
    
    
    func selectNewPage () -> Int {
        var newPageIndex = -1
        if let pageToJump = pageController.whereShouldIJump() {
            for (index, page) in formModel.pages.enumerate() {
                if page.pageName == pageToJump {
                    newPageIndex = index
                }
            }
        }
        
        if newPageIndex == -1 {
            newPageIndex = currentPage + 1
        }
        
        return newPageIndex
        
    }
    
    
    func updateRightButton() {
        rightNavItem.enabled = true
        if currentPage == formModel.pages.count - 2 {
            rightNavItem.title = formModel.appSubmitButton
        } else if currentPage == formModel.pages.count - 1 {
            rightNavItem.title = NSLocalizedString("usa_form_close_button", tableName: UsabillaFeedbackForm.localizedStringFile, bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!, comment: "")
        } else {
            rightNavItem.title = NSLocalizedString("usa_form_continue_button", tableName: UsabillaFeedbackForm.localizedStringFile, bundle: NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!, comment: "")
        }
    }
    
    func updateProgressBar() {
        let progress = Float(currentPage + 1) / Float(formModel.pages.count)
        progressBar.setProgress(progress, animated: true)
    }
    
    @IBAction func leftBarButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func initWithFormModel(formModel: FormModel) {
        self.formModel = formModel
    }
    
    func swipeToPage(page: Int) {
        pageController.initWithPage((formModel.pages[page]))
        currentPage = page
    }
    
    func convertFormToDictionary () -> [String: AnyObject] {
        var formDictionary = [String: AnyObject]()
        let indexToStop = formModel.pages.count - 1
        for index in 0...indexToStop - 1 {
            let page = formModel.pages[index]
            for field in page.fields {
                formDictionary[field.fieldId] = field.convertToJSON()
            }
        }
        return formDictionary
    }
    
    func submitForm() {
        let uiDevice = UIDevice()
        var contentDictionary: [String: AnyObject] = [:]
        contentDictionary["app_id"] = formModel.appId //String
        contentDictionary["version"] = formModel.version //String
        contentDictionary["SDK_version"] = NSBundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.objectForInfoDictionaryKey("CFBundleShortVersionString")
        
        contentDictionary["data"] = convertFormToDictionary()
        
        contentDictionary["timestamp"] = String(format: "%.0f", arguments: [NSDate().timeIntervalSince1970])
        
        contentDictionary["device"] = uiDevice.modelName
        
        contentDictionary["system"] = "ios"
        contentDictionary["os_version"] = uiDevice.systemVersion
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        contentDictionary["battery"] = UIDevice.currentDevice().batteryLevel
        contentDictionary["lang"] = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)
        contentDictionary["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape": "Portrait"
        //contentDictionary["free_memory"] = Int(DeviceInfo.deviceRemainingFreeSpaceInBytes()!) Broken
        //contentDictionary["total_memory"] = Int(DeviceInfo.totalRamOfDevice())
        //TODO put back
        
        contentDictionary["free_space"] = Int(DeviceInfo.DiskStatus.freeDiskSpaceInBytes / 1024)
        contentDictionary["total_space"] = Int(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)
        contentDictionary["rooted"] = DeviceInfo.isJailbroken()
        
        let screenBounds = UIScreen.mainScreen().bounds
        contentDictionary["screensize"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"
        
        contentDictionary["app_version"] = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]
        contentDictionary["app_name"] = NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"]
        if let screenshotModel = formModel.pages.first?.fields.last as? ScreenshotModel {
            if let screenshot = screenshotModel.base64Value {
                contentDictionary["media"] = ["screenshot" : screenshot]
            }
        }
        if customVars != nil {
            contentDictionary["custom_variables"] = customVars
        }
        
        if formModel.isDefault {
            contentDictionary["defaultForm"] = true
        }
        
        
        var payload: [String: AnyObject] = [:]
        
        payload["type"] = "app_feedback"
        payload["subtype"] = "form"
        payload["v"] = NSNumber(int: 1)
        payload["done"] = NSNumber(bool: true)
        payload["data"] = contentDictionary
        
        
        //And now to send the request
        //TODO: handle properly
        NetworkManager.submitFormToUsabilla(payload).then { _ in
            print("fuck yeah")
            }.error({ _ in
                print("fuck no")
            })         
    }
    
    
}
