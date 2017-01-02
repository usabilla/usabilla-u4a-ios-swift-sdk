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
    var reachability: Reachability!
    var pageController: PageController!
    var thankYouController: ThankYouController!
    var customVars: [String: Any]? = nil

    @IBOutlet weak var progressBar: UIProgressView!

    //Views

    @IBOutlet weak var leftNavItem: UIBarButtonItem!
    @IBOutlet weak var rightNavItem: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        swipeToPage(0)
        if formModel.pages.count == 2 || !formModel.showProgressBar {
            progressBar.isHidden = true
        } else {
            progressBar.progressTintColor =  formModel.themeConfig.accentColor
        }
       
        updateProgressBar()
        updateRightButton()
        UIApplication.shared.statusBarStyle = formModel.themeConfig.statusBarColor
        
        self.navigationController?.navigationBar.barTintColor = formModel.themeConfig.accentColor
        self.navigationController?.navigationBar.tintColor = formModel.themeConfig.textOnAccentColor

        SwiftEventBus.onMainThread(self, name: "restoreForm") { _ in
            self.restoreFeedbackFormController()
        }

        setUpLeftButton()
        setUpReachability()
    }


    func setUpLeftButton() {
        leftNavItem.title = formModel.copyModel.cancelButton

        if !UsabillaFeedbackForm.showCancelButton {
            leftNavItem.title = ""
            leftNavItem.isEnabled = false
        }
    }


    func setUpReachability() {
        do {
            reachability = Reachability.init()
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PageController, segue.identifier == "embedSegue" {
            self.pageController = vc
            pageController.initWithPage(formModel.pages[0])
        }
    }

    @IBAction func rightBarButtonPressed(_ sender: UIBarButtonItem) {

        if pageController.isCorrectlyFilled() {
            let newPageIndex = selectNewPage()
            //If I'm at the last page, submit and don't change
            if currentPage == formModel.pages.count - 2 || newPageIndex == formModel.pages.count - 1 {
                let (payload, screenshot) = createDictionaryForSubmission()
                if reachability.currentReachabilityStatus == .notReachable {
                    //Queue
                } else {
                    submitForm(payload, screenshotString: screenshot)
                }
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
        rightNavItem.isEnabled = false
        leftNavItem.title = formModel.copyModel.cancelButton
        leftNavItem.isEnabled = true

        let storyboard = UIStoryboard(name: "USAStoryboard", bundle: Bundle(identifier: "com.usabilla.UsabillaFeedbackForm"))
        thankYouController = storyboard.instantiateViewController(withIdentifier: "thankYou") as? ThankYouController
        thankYouController.themeConfig = formModel.themeConfig
        thankYouController.redirectEnabled = formModel.redirectToAppStore
        thankYouController.redirectToAppStore = formModel.copyModel.appStore
        thankYouController.giveMoreFeedback = formModel.copyModel.moreFeedback
        
        var headerFieldValue: String?
        var thanksFieldValue: String?
        if let lastPage = formModel.pages.last {
            if lastPage.fields.count > 0 {
                if let header: HeaderFieldModel = lastPage.fields[0] as? HeaderFieldModel {
                    headerFieldValue = header.fieldValue
                }
            }
            if lastPage.fields.count > 1 {
                if let thank: StringFieldModel = lastPage.fields[1] as? StringFieldModel {
                    thanksFieldValue = thank.fieldValue
                }
            }
        }

        let moodValue = formModel.pages.first?.fields[0] as? IntFieldModel

        pageController.willMove(toParentViewController: nil)
        addChildViewController(thankYouController)
        thankYouController.view.frame = containerView.bounds


        transition(from: pageController, to: thankYouController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        var rating: Int = 0
        if let temp = moodValue?.fieldValue {
            rating = temp
        }
        thankYouController.setUpController(rating > 3, thankTitle: headerFieldValue, thankMessage: thanksFieldValue)

    }

    func restoreFeedbackFormController() {
        resetAndRestartForm()
        thankYouController.willMove(toParentViewController: nil)
        addChildViewController(pageController)
        pageController.view.frame = containerView.bounds
        transition(from: thankYouController, to: pageController, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        updateRightButton()
        updateProgressBar()
        setUpLeftButton()
    }

    func resetAndRestartForm() {
        currentPage = 0
        formModel = JSONFormParser.parseFormJson(formModel.formJsonString, appId: formModel.appId, screenshot: nil, themeConfig: formModel.themeConfig)
        pageController.initWithPage(formModel.pages[0])
    }


    func selectNewPage() -> Int {
        var newPageIndex = -1
        if let pageToJump = pageController.whereShouldIJump() {
            for (index, page) in formModel.pages.enumerated() {
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
        rightNavItem.isEnabled = true
        if currentPage == formModel.pages.count - 2 {
            rightNavItem.title = formModel.copyModel.navigationSubmit
        } else if currentPage == formModel.pages.count - 1 {
            rightNavItem.title = formModel.copyModel.cancelButton
        } else {
            rightNavItem.title = formModel.copyModel.navigationNext
        }
    }

    func updateProgressBar() {
        let progress = Float(currentPage + 1) / Float(formModel.pages.count)
        progressBar.setProgress(progress, animated: true)
    }

    @IBAction func leftBarButtonPressed(_ sender: UIBarButtonItem) {
        deinitForm()
        self.dismiss(animated: true, completion: nil)
    }


    func deinitForm() {
        SwiftEventBus.postToMainThread("kill")
        SwiftEventBus.unregister(self)
        pageController.deinitPageController()
    }

    func initWithFormModel(_ formModel: FormModel) {
        self.formModel = formModel
    }

    func swipeToPage(_ page: Int) {
        pageController.initWithPage((formModel.pages[page]))
        currentPage = page
    }

    func convertFormToDictionary() -> [String: Any] {
        var formDictionary = [String: Any]()
        let indexToStop = formModel.pages.count - 1
        for index in 0...indexToStop - 1 {
            let page = formModel.pages[index]
            for field in page.fields {
                if let converted = field.convertToJSON() {
                    if field.fieldId.characters.count > 0 {
                        formDictionary[field.fieldId] = converted
                    }
                }
            }
        }
        return formDictionary
    }

    func createDictionaryForSubmission() -> ([String: Any], String? ) {
        let uiDevice = UIDevice()
        var contentDictionary: [String: Any] = [:]
        contentDictionary["app_id"] = formModel.appId   //String
        contentDictionary["version"] = formModel.version   //String
        contentDictionary["SDK_version"] = Bundle(identifier: "com.usabilla.UsabillaFeedbackForm")!.object(forInfoDictionaryKey: "CFBundleShortVersionString")  

        contentDictionary["data"] = convertFormToDictionary()  

        contentDictionary["timestamp"] = String(format: "%.0f", arguments: [Date().timeIntervalSince1970])  

        contentDictionary["device"] = uiDevice.modelName  

        contentDictionary["system"] = "ios"  
        contentDictionary["os_version"] = uiDevice.systemVersion
        UIDevice.current.isBatteryMonitoringEnabled = true
        contentDictionary["battery"] = UIDevice.current.batteryLevel
        contentDictionary["lang"] = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode)
        contentDictionary["orientation"] = UIDeviceOrientationIsLandscape(uiDevice.orientation) ? "Landscape": "Portrait"
        //contentDictionary["free_memory"] = Int(DeviceInfo.deviceRemainingFreeSpaceInBytes()! / 1024)
        //contentDictionary["total_memory"] = Int(DeviceInfo.totalRamOfDevice() / 1024)

        contentDictionary["reachability"] = reachability.currentReachabilityStatus.description

        contentDictionary["free_space"] = Int(DeviceInfo.DiskStatus.freeDiskSpaceInBytes / 1024)  
        contentDictionary["total_space"] = Int(DeviceInfo.DiskStatus.totalDiskSpaceInBytes / 1024)  
        contentDictionary["rooted"] = DeviceInfo.isJailbroken()  

        let screenBounds = UIScreen.main.bounds
        contentDictionary["screensize"] = "\(Int(screenBounds.width)) x \(Int(screenBounds.height))"  

        contentDictionary["app_version"] = Bundle.main.infoDictionary!["CFBundleVersion"]  
        contentDictionary["app_name"] = Bundle.main.infoDictionary![kCFBundleNameKey as String]  

        var screenshotString: String?
        if let screenshotModel = formModel.pages.first?.fields.last as? ScreenshotModel {
            if let screenshot = screenshotModel.base64Value {
                //contentDictionary["media"] = ["screenshot" : screenshot]
                screenshotString = screenshot
            }
        }

        if customVars != nil {
            contentDictionary["custom_variables"] = customVars  
        }

        if formModel.isDefault {
            contentDictionary["defaultForm"] = true  
        }


        var payload: [String: Any] = [:]

        payload["type"] = "app_feedback" 
        payload["subtype"] = "form"  
        payload["v"] = NSNumber(value: 1 as Int32)
        payload["done"] = true  
        payload["data"] = contentDictionary  


        //And now to send the request
        //print(screenshotString)
        return (payload, screenshotString)
    }

    func submitForm(_ payload: [String: Any], screenshotString: String? ) {
        NetworkManager.submitFormToUsabilla(payload: payload, screenshot:  screenshotString)
    }


    //    deinit {
    //        print("calling form controller deinit")
    //    }

}
