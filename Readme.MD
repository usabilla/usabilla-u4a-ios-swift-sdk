# Usabilla for Apps - iOS SDK
Usabilla for Apps allows you to collect feedback from your users with great ease and flexibility.

Read the [Default Events](#defaultevents) section for a explanation of the new fetures introduces in SDK 6.12.0
* * *

- [Usabilla for Apps - iOS SDK](#usabilla-for-apps---ios-sdk)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Swift Package Manager](#SPM)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Manual](#manual)
  - [Initialization](#initialization)
    - [DebugMode](#debugmode)
    - [FooterLogoClickable](#FooterLogoClickable)
  - [Campaigns](#campaigns)
    - [The App Id](#the-app-id)
    - [Targeting options](#targeting-options)
    - [Campaign toggling](#campaign-toggling)
    - [Campaign submission callback](#campaign-submission-callback)
    - [Reactivate a campaign](#reactivate-a-campaign)
    - [Resetting all campaigns](#resetting-all-campaigns)
    - [Managing an existing campaign](#managing-an-existing-campaign)
    - [Campaign results](#campaign-results)
  - [Passive feedback](#passive-feedback)
    - [Loading a form](#loading-a-form)
    - [Preloading a form](#preloading-a-form)
    - [iPad display](#ipad-display)
    - [Adding a screenshot](#adding-a-screenshot)
    - [Feedback submission callback](#feedback-submission-callback)
      - [FeedbackResult](#feedbackresult)
    - [Handle manual dismiss](#handle-manual-dismiss)
  - [Masking Private Identifiable Information](#masking-private-identifiable-information)
  - [Custom variables](#custom-variables)
  - [App Store rating](#app-store-rating)
  - [Programmatically remove a Form or a Campaign](#programmatically-remove-a-form-or-a-campaign)
  - [Force specific interface orientation](#force-specific-interface-orientation)
  - [UI Customisations](#ui-customisations)
    - [Custom Emoticons Rating](#custom-emoticons-rating)
      - [Provide only the selected version](#provide-only-the-selected-version)
      - [Provide both the selected and unselected version](#provide-both-the-selected-and-unselected-version)
    - [Custom Star Rating](#custom-star-rating)
    - [Custom Fonts](#custom-fonts)
    - [Custom colors](#custom-colors)
  - [Localization](#localization)
    - [String file contents](#string-file-contents)
  - [Permissions](#permissions)
  - [Integration with Obj-C applications](#integration-with-obj-c-applications)
  - [ThreadSafe](#ThreadSafe)
  - [Telemetry data collection](#Telemetry-data-collection)
  - [Getting User feedback in app](#Getting-user-feedback-in-app)
  - [Standard Events](#standardevents)
  - [prePopulateEmailComponent](#prepopulateemailcomponent)

* * *

## Requirements
- iOS 12+
- Xcode 15+
- Swift 4.0+

**Note : For `Xcode 15+` use v`6.13.3` onwards.**


## Installation

You can install the Usabilla SDK using Cocoapods, Carthage or manually.

The latest versions of SDK are build with Module Format Stability.
Previous versions are available at our git-repository. For Carthage please check the Carthage section
 
### SPM
Instructions for [Swift Package Manager](https://swift.org/package-manager/) support can be found at [SwiftPackageManager.md](SwiftPackageManager.MD).

### CocoaPods

The Usabilla SDK is available on [CocoaPods](http://cocoapods.org). You can install CocoaPods the following way:

```bash
$ gem install cocoapods
```

To use the SDK in your project, specify it in your `Podfile`:

```ruby
use_frameworks!

target 'YourProjectTarget' do

pod 'Usabilla', '~> 6.14.0'

End
```
The current pod is build for Xcode 16 and now uses xcframework.

For other Xcode version, use:
 
```ruby
pod 'Usabilla', :podspec => 'https://raw.githubusercontent.com/usabilla/usabilla-u4a-ios-swift-sdk/Xcode-x.y.z/Usabilla.podspec'
```
replace Xcode-x.y.z with the required version eg. Xcode-12.5.1. Available versions `Xcode-14.0`.

Then, run the following command:

```bash
$ pod install
```

### Carthage

The Usabilla SDK is also available through [Carthage](https://github.com/Carthage/Carthage).

Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
to add carthage to your project.
If you're migrating to xcframeworks please follow [these instructions] (https://github.com/Carthage/Carthage#migrating-a-project-from-framework-bundles-to-xcframeworks) and `Migration steps` mentioned there.

And add this line to your `Cartfile`:

```yaml
binary "https://raw.githubusercontent.com/usabilla/usabilla-u4a-ios-swift-sdk/master/Usabilla.json"
```
The current Carthage release is build for Xcode 15 .

For other Xcode version, use:
 
```yaml
binary "https://raw.githubusercontent.com/usabilla/usabilla-u4a-ios-swift-sdk/Xcode-x.y.z/Usabilla.json"
```
replace Xcode-x.y.z with the required version eg. Xcode-12.5.1. Available versions `Xcode-14.0`.

**Note : Carthage - `0.38.0` encourage using XCFrameworks and Usabilla SDK for carthage supports XCFrameworks from `6.9.0` onwards**

### Manual

You can download the latest version of the repository from [releases](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/releases/) and extract  **UsabillaXCFramework.zip**. Then add **Usabilla.xcframework** to your app’s embedded frameworks.

In doing so, you might encounter a problem while submitting your app to the App Store. This is due to a [bug in the App Store](http://www.openradar.me/radar?id=6409498411401216) itself.     

You can solve it by creating a new **Run Script Phase**, after the **Embed Frameworks** phase, in your app’s target’s **Build Phases**, and copying the script available [here](https://stackoverflow.com/a/30866648).

## Initialization

We recommend initializing the SDK in the AppDelegate. However this is not mandatory, and the initialization can be performed elsewhere without any problem.    

Import Usabilla SDK inside your **AppDelegate**.

```swift
import Usabilla
```

Add the following line to the **didFinishLaunchingWithOptions**:
```swift
Usabilla.initialize(appID: "appID")
```

You can also run a callback after the SDK is finished initializing by calling:

```swift
Usabilla.initialize(appID: "appID") {
    // Your callback code here
}
```

The **initialize** method will take care of:
* Submitting any pending feedback items.
* Fetching and updating all campaigns associated with the app ID.
* Initializing a few background processes of the SDK.

>⚠️ **Failure to call this method will prevent the SDK from running. No functionalities at all will be available.**

### DebugMode
In order to have more insights from the SDK while developing, you can enable logging with:
```swift
Usabilla.debugEnabled = true
```
This property is by default set to `false`.

### FooterLogoClickable
When user interacts with logo present at bottom area of the form , it opens a url `"http://www.usabilla.com"` into the mobile browser, you can disable that user interaction with:
```swift
Usabilla.setFooterLogoClickable = false
```
This property is by default set to `true`.

## Campaigns
Version 4 of the Usabilla for Apps SDK introduces the new campaigns feature.
This guide describes the Campaigns feature and all the steps necessary to work with it.

In the Usabilla for Apps Platform, a campaign is defined as a proactive survey targeted to a specific set of users.

Being able to run campaigns in your mobile app is great because it allows you to collect more specific insights from your targeted users. What is even better is that creating new and managing existing campaigns can be done without the need for a new release of your app. Everything can be managed from the Usabilla web interface.

You can run as many campaigns as you like and target them to be triggered when a specific set of targeting options are met.
The configuration of how a campaign is displayed to the user will be familiar to existing Usabilla customers. You can configure it to suit your needs just like you are used to from the Passive feedback forms.

The most important aspect of running a mobile campaign is 'Events'. Events are custom triggers that are configured in the SDK. When a pre-defined event occurs, it will allow you to trigger a campaign. A good example of an event is a successful purchase by a user in your app.

### The App Id
The app Id is an identifier used to associate campaigns to a mobile app.
By loading the SDK with a specific app Id, it will fetch all the campaigns connected to the given app Id.

It is possible to target a campaign to more than one app (e.g. iOS Production App, iOS Beta App) by associating it with multiple App Ids.

### Targeting options
Campaigns are triggered by events. Events are used to communicate with the SDK when something happens in your app. Consequently, the SDK will react to an event depending on the configuration of the Usabilla web interface.
To send an event to the SDK, use :
```swift
Usabilla.sendEvent(event: String)
```

There are multiple options which allow you to define more specific targeting rules of a campaign:
- You can set the number of times an event has to occur (e.g. 3 times).
- Specify the percentage of users for whom the campaign should be triggered (e.g. 10%).
- Define whether you would like to target a specific device language.

You can also segment your user base using custom variables.
**Custom variables** can be used to specify some traits of the user and target the campaign only to a specific subset.

For more on how to use custom variables, read [Custom Variables](#adding-custom-variables)

**Note: A campaign will never be triggered for the same user more than once.**

### Campaign toggling

The Usabilla SDK allows you to make sure no campaigns trigger at an inappropriate moment. For example, when the user of your app is in the middle of a delicate process and should not be disturbed. This can be done by setting the boolean property `canDisplayCampaigns` of `Usabilla` to suit your needs.
```swift
Usabilla.canDisplayCampaigns = false
```

Setting it to `true` will allow the SDK to display any campaign when it triggers.
Setting it to `false` will prevent all campaigns from being displayed.

**Even when `canDisplayCampaigns` is set to `false`, the SDK continues to receive all events. If a campaign happens to trigger, it won't be displayed nor delayed: that event instance will be lost.**

By default, `canDisplayCampaigns` is set to `true`.

If one or more of your campaigns trigger when the `canDisplayCampaigns` property is set to `false` and later on changed to `true`, the SDK will not display the campaign. The reasoning is because this moment, later in time, might be irrelevant to display the campaign to the user.

### Campaign submission callback

It is possible to get information about the feedback the user has left and you will also be notified if the user has left the form without submitting it, simply by implementing:

```swift
func campaignDidClose(withFeedbackResult result: FeedbackResult, isRedirectToAppStoreEnabled: Bool) {}
```
Unlike the Passive feedback method, the campaigns method only returns one [FeedbackResult](#feedbackresult) and is called only once.

### Reactivate a campaign
**Note: From 6.13.0 we are introducing campaign reactivation with these feature during campaign creation or after creation, a campaign can be added / modified with reactivation duration which is in days - for example if a campaign sets with reactivation in 7 days i.e. A campaign can be shown again after 7 days if all the prior conditions for campaign met again ( like language, percentage, repeatition/ trigger).**

### Resetting all campaigns

During development and testing, it might be useful to reset the status of your campaigns and allow them to be displayed again.    
You can do so by calling `Usabilla.resetCampaignData(completion: nil)`.    
You can include a closure that will be executed when the SDK is done resetting campaign data.    
This method will synchronize your data with the Usabilla server, so it will fetch all the new campaigns and remove the deactivated ones as well.

### Managing an existing campaign

You can start collecting campaign results right after you create a new campaign in the Usabilla for Apps [Campaign Editor](https://app.usabilla.com/member/live/apps/campaigns/add).
By default, new campaigns are marked as inactive. On the Usabilla for Apps [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/) page, you can activate or deactivate an existing campaign at any moment to reflect your specific needs.

Moreover, you can update the content of your campaign (e.g. questions) at any time. Keep in mind that the changes you make to an existing active campaign might affect the integrity of the data you collect (different responses before and after a change).

Furthermore, you can also change the targeting options of a campaign. Keep in mind that updating the targeting options of an active campaign will reset any progression previously made on the user's device.

### Campaign results

Aggregated campaign results are available for download from the [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/). Here you can download the results per campaign, in the CSV format.

Campaign results will contain the answers that your users provided. Responses from a campaign are collected and sent to Usabilla page by page. This means that even if a user decides to abandon the campaign halfway through, you will still collect valuable insights. When a user continues to the next page, then the results of the previous page are submitted to Usabilla. Besides campaign results showing the answers to your campaign questions, you will be able to view the device metadata and custom variables.

As for campaign results. Please note that editing the form of an existing campaign will affect the aggregated campaign results:

- Adding new questions to a form will add additional columns to the CSV file.
- Removing questions from an existing form will not affect the previously collected results. The associated column and its data will still be in the CSV file.
- Replacing the question type with a different question is also possible. When you give the same 'name' in the Usabilla for Apps Campaign Editor, then results are represented in the same column.



## Passive feedback
Passive feedback are feedback forms that are not triggered by events.
They are mostly, but not necessarily, initiated by the user.


### Loading a form

The SDK uses the Form ID you get from [Usabilla](https://app.usabilla.com/member/apps/list) after creating a new form to fetch and display the form inside your app.

A basic implementation of the SDK would be the following:

```swift
class SomeViewController: UIViewController, UsabillaDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        Usabilla.delegate = self
        Usabilla.loadFeedbackForm("Form ID")
    }

    //Called when your form successfully load
    func formDidLoad(form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }

    //Called when your forms can not be loaded. Returns a default form
    func formDidFailLoading(error: UBError) {
        //...
    }

}
```

And for SWIFTUI implementation follow below steps:
`UIViewControllerRepresentable` instance is used to create and manage a UIViewController object in your SwiftUI interface.

```swift
import SwiftUI
import UIKit
import Usabilla

struct UsabillaFormView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UsabillaFormViewController {
        let vc = UsabillaFormViewController()
        return vc
    }
    func updateUIViewController(_ uiViewController: UsabillaFormViewController, context: Context) {
    }
    typealias UIViewControllerType = UsabillaFormViewController
}

class UsabillaFormViewController: UIViewController, UsabillaDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        Usabilla.delegate = self
        Usabilla.loadFeedbackForm("Form ID")
    }

    //Called when your form successfully load
    func formDidLoad(form: UINavigationController) {
        present(form, animated: true, completion: nil)
    }

    //Called when your forms can not be loaded. Returns a default form
    func formDidFailLoading(error: UBError) {
        //...
    }

}

 //Called from SWIFTUI view to load the form
struct ContentView: View {
    @State private var showingUsabillaForm:Bool = false

    var body: some View {
        Button(action: {
            self.showingUsabillaForm = !self.showingUsabillaForm
        })
        if(showingUsabillaForm) {
            UsabillaFormView()
        }
    }
}
```

### Preloading a form

If you know you will need to display a feedback form when the user is offline, you can preload and cache it to make it available at any given moment.   
To preload a form use
```
UsabillaFeedbackForm.preloadFeedbackForms(withFormIDs: ["FORM_ID_1", "FORM_ID_2"])
```
This will fetch the latest version of the form and cache it in the SDK.    
 When you will request that form, if there is no network connectivity, the SDK will use the cached version and your user will be able to submit his feedback

Feedback submitted while offline will be sent when connectivity is restored.

If you wish, you can empty the cache using
```
UsabillaFeedbackForm.removeCachedForms()
```


### iPad display

On iPad, the Passive feedback form has a presentation style set to [formSheet](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle/1621491-formsheet) by default.
If you want to override this behavior and have a full screen display you can achieve it with:

```swift
func formDidLoad(form: UINavigationController) {
    form.modalPresentationStyle = .fullScreen
    present(form, animated: true, completion: nil)
}
```

### Adding a screenshot

It is possible to attach a screenshot to a feedback form.

You can take a screenshot at any moment calling
```swift
let image = Usabilla.takeScreenshot(self.view)
```

To attach the screenshot to the form, pass it as a parameter when calling
```swift
Usabilla.loadFeedbackForm("Form Id", screenshot: image)
```

Pass `nil` as the `screenshot` parameter if you don't want to have a screenshot of the current view.

**Custom Screenshot & Sensitive Information**

Instead of taking the screenshot using the `Usabilla.takeScreenshot()` method, you can provide any image you wish by passing it as the `image` parameter when calling `Usabilla.loadFeedbackForm()`

This will allow you to hide any user sensitive information by, for example, taking the screenshot yourself, removing all unwanted information and submitting the censored version.

### Feedback submission callback
It is possible to get information about the feedback the user has left and you will also be notified if the user has left the form without submitting it, simply by implementing:

```swift
func formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    //...
}
```
This delegate method provides you with an array of `FeedbackResult` because the user may submit the form multiple times and this method will be called only once for all the feedback sent.

#### FeedbackResult

```swift
struct FeedbackResult {
    let rating: Int?
    let abandonedPageIndex: Int?
    var sent: Bool
}
```

The **rating** value is set as soon as the user interacts with it and will be reported even if the form is not submitted.

The **abandonedPageIndex** is only set if the user cancels the form before submission.

**Example**
```swift
func formDidClose(formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {

    guard let feedback = feedbackResults.first else {
    return
    }

    if feedback.sent == false {
        let abandonedPageIndex = feedback.abandonedPageIndex
        print("Hey why did you left the form here \(abandonedPageIndex)")
        return
    }

    if let rating = feedback.rating {
        if rating >= 4 && isRedirectToAppStoreEnabled {
            // Prompt the user for rating and review
        }
    }

}
```

### Handle manual dismiss

It is possible to customize the way the form is dismissed, you can achieve this by adding this line:

```swift
Usabilla.dismissAutomatically = false
```

and implement the **formWillClose** delegate method:

```swift
func formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
// handle your custom dismiss e.g: dismiss(animated: true, completion: nil)
}
```
**Warning**: by doing this the form will not dismiss by itself and you will be the only one responsible for its correct behavior. Also, the delegate method `formDidClose` will not be called.

## Masking Private Identifiable Information

The SDK has an option to mask (on the back-end side) the data from input texts, specifically `Text Input` and `Text Area`. Please note that the an email input field is not being masked.

It matches a list of RegEx and replaces them by the "X" character by default.

The SDK has a `setDataMasking` method that can be used as:
```swift
Usabilla.setDataMasking()
Usabilla.setDataMasking(masks: [String])
Usabilla.setDataMasking(masks: [String], maskCharacter: Character)
```
`masks` is a list of RegExes to mask data in input fields. It uses the default RegExes that the SDK provides.
`maskCharacter` is a character to replace the matched RegExes. By default it uses "X"".

The default RegExes that the SDK provides are: Email Addresses & Numbers

For email it uses:
```swift
[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9][a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+
```
For Numbers with the length 4 or more
```swift
[0-9]{4,}
```
The default RegEx can be accessed by:

```swift
Usabilla.defaultDataMasks
```

## Custom variables

You can pass along custom variables that will be attached to the feedback users send.
Custom variables are held in a dictionary object, in the public interface of the SDK, called `customVariables`.

You can set custom variables by simply modifying the dictionary object

```swift
Usabilla.customVariables["key"] = "value"
```

**Since the SDK is using [JSONSerialisation](https://developer.apple.com/documentation/foundation/jsonserialization) to convert the custom variables to JSON, its limitations have to be taken into account.
The `value` of a custom variable must then be an instance NSString, or String.**


Trying to set an invalid object as a custom variable will result in that object not being set and in an error being printed in the console.

You can always check whether an object is considered valid or not by calling `JSONSerialization.isValidJSONObject(object)`


Custom variables are added as extra feedback data with every feedback item sent by the SDK, whether from a passive feedback or a campaign.
Custom Variables **key / name** should not be an `empty string` and it should not contain `.` or `$`.
**Custom variables can be used as targeting options, as long as the `value` is a String.**

## App Store rating

To decide whether or not to prompt the user for a rating, you can read the information regarding the user's activity passed in the [Submission callback](#feedback-submission-callback) or the [Campaign submission callback](#campaign-submission-callback)

In the Usabilla web interface, it is possible to define whether a specific feedback form should prompt the user for a rating.

## Programmatically remove a Form or a Campaign

The SDK provides a way to programmatically dismiss all forms through the method:
```swift
let result = Usabilla.dismiss()
```
This will result in the Form or Campaign being removed. No delegate methods will get called eg. `formDidClose`

If there is a Form or a Campaign the method will return true, false otherwise.

## Force specific interface orientation

It is possible to force a Campaign or Form to be presented in specific orientation, regardless of the device orientation, or the supported orientations for the Application.

```swift
Usabilla.orientation = .landscapeLeft 
```
Set this property before presenting a Campaign or Form. It defaults to 

```swift
Usabilla.orientation = .all
```
which should also be used to reset the properties, to follow the Applications settings for supported orientations.


## UI Customisations

### Custom Emoticons Rating
It is possible to use custom images instead of the one provided natively in the SDK.

To do so, you must provide a list (or two, depending on what you want to achieve) of five `UIImage` that will be used instead of the Usabilla's default emoticons.
The first element of the array should be the lowest or leftmost item, while the 5th element will be the highest or rightmost.
At the moment, the SDK does not perform any check to make sure the lists are valid.

#### Provide only the selected version
You can provide only one list containing the selected version of the icons.

The images will be displayed with an alpha value of 0.5 when unselected, and with an alpha value of 1 when selected.


```swift
let a = UIImage(named: "1")!
let b = UIImage(named: "2")!
let c = UIImage(named: "3")!
let d = UIImage(named: "4")!
let e = UIImage(named: "5")!
Usabilla.theme.images.enabledEmoticons = [a, b, c, d, e]
```

#### Provide both the selected and unselected version
You can provide two lists containing the selected and the unselected version of the icons.

The icons drawable will be selected from one of the two lists according to its state.

```swift
let enabled = createEnabledArray()
let disabled = createDisabledArray()

Usabilla.theme.images.enabledEmoticons = enabled
Usabilla.theme.images.disabledEmoticons = disabled
```

### Custom Star Rating

You can change the appearance of the star in the Star Rating by setting both `star` and `starOutline` in the UsabillaTheme.

Keep in mind that, in order to display the Star Rating in your form, you must first enable it in the [Usabilla Web Interface](https://app.usabilla.com/member/apps/).

```swift
Usabilla.theme.images.star = UIImage(named: "starFilled")!
Usabilla.theme.images.starOutline = UIImage(named: "starOutline")!
```

### Custom Fonts

It is possible to change the font of the feedback form by setting the `regular` and `bold` properties of the `UsabillaTheme.fonts` structure.
If they are not set the SDK will use the default system font.

```swift
Usabilla.theme.fonts.regular = UIFont(name: "Helvetica-LightOblique", size: 20)
Usabilla.theme.fonts.bold = UIFont(name: "Helvetica-Bold", size: 20)
```

### Custom colors

All colors are set from the Usabilla website and not from the SDK. You can find a detailed explanation of the color's name and role in our [knowledge base](https://support.usabilla.com/hc/en-us/articles/211588989-How-do-I-change-the-feedback-form-colors-in-Usabilla-for-Apps).    


The only exception is for the `header` color, used to change the color of the navigation bar.    
You can set the header color by calling `Usabilla.theme.colors.header = UIColor.red` before displaying the form.

## Localization

For all the text that is not customizable in the web interface, you can provide your own translation using a `.string` localized file inside your application.

This file also includes all the accessibility labels read when VoiceOver is enabled.

### String file contents
If you want to provide your own translation, you need to provide the specific keys (mentioned below) with the custom text in the .string file.


The default file with the keys and the default text is the following:

```
///Default usabilla english localization
"usa_form_continue_button" = "Next";
"usa_form_close_button" = "Close";
"usa_form_required_field_error" = "Please check this field";
"usa_screenshot_placeholder" = "Add screenshot";

// Accessibility labels
"usa_mood_select_a_rating_out_of" = "select a rating out of";
"usa_accessibility_field_required" = "This field is required";
"usa_choose_from_options" = "Choose from %d options";
"usa_delete_screenshot" = "delete screenshot";
"usa_edit_screenshot" = "change screenshot";
"usa_powered_by_usabilla" = "powered by usabilla";
"usa_tap_to_visit_usabilla" = "tap to visit usabilla.com";
"usa_accessibility_button_label_continue" = "Continue";

// Emoticons
"usa_mood_hate" = "Hate";
"usa_mood_dislike" = "Dislike";
"usa_mood_neutral" = "Neutral";
"usa_mood_like" = "Like";
"usa_mood_love" = "Love";

// Stars
"usa_mood_one_star" = "1 star";
"usa_mood_two_star" = "2 stars";
"usa_mood_three_star" = "3 stars";
"usa_mood_four_star" = "4 stars";
"usa_mood_five_star" = "5 stars";

// checkbox & radio button
"usa_multiple_options_possible" = "Multiple options possible";
"usa_one_option_possible" = "One option possible";
"usa_selected" = "selected";
"usa_unselected" = "unselected";

// Added in SDK Version 6.4.0
//camera button
"usa_camera_navbar_left_button" = "Cancel";

// Screenshot anotation
"usa_retake_button_title" = "Retake";
"usa_back_button_title" = "Back";
"usa_cancel_button_title" = "Cancel";
"usa_add_button_title" = "Add";
"usa_done_button_title" = "Done";
"usa_back_button_library_title" = "Library";
"usa_library_title" = "Library";
"usa_edit_title" = "Edit";
"usa_add_title" = "Add photo";
"usa_camera_error_title" = "No access to camera";
"usa_camera_error_description" = "Allowing access lets you take photos to add to your feedback.";
"usa_camera_settings_title" = "Allow access to camera";

"usa_library_error_title" = "No access to library";
"usa_library_error_description" = "Allowing access lets you select a photo to add to your feedback.";
"usa_library_settings_title" = "Allow access to library";

```

If keys are not present in your file, the SDK will revert to the default keys.

If you want to use your custom .string file, you can do so by calling

```swift
Usabilla.localizedStringFile = "your_localization_file_name"
```

With the name of your file, without the .string extension.

## Permissions (Optional)
If the user tries to set a custom screenshot, the SDK will ask for the permission to access the gallery and camera.

These privacy permissions are needed on the main app:
    
    NSCameraUsageDescription
    NSPhotoLibraryUsageDescription

Please make sure there is a description string for each of these properties.

Refer to Apples [technical document](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html), on how to localize these 

If user wants to set only library or camera permissions than either only the camera view or the photo-library view will be displayed.
And incase if both permissions are not provided than end-user can only able to annotate or see the image passed via load form and also the camera and the photo-library will not be displayed.

NOTE: If you haven’t enabled the ‘Show screenshot’ option in the Advanced settings panel of a form, than `Add a photo` panel will not be displayed.

## Integration with Obj-C applications

To integrate the SDK in your Obj-C application, follow the Apple official guidelines on how to [use Swift and Objective-C in the Same Project](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).

A quick way to approach this problem is to create a Swift file from where you will handle your application. After creating the new file and having set up the Bridging Header, you can extend your existing view controllers inside the Swift class to seamlessly integrate the SDK in your app.

In this example you can see a ViewController in Obj-C:

```objectivec
#import "ViewController.h"

//Remember to import the auto-generated Swift header, otherwise, you won't see your Swift extension
#import "objctest-Swift.h"

@interface ViewController ()

@end


@implementation ViewController

    - (IBAction)buttonPressed:(id)sender {
        [self showForm];
    }

@end

```

And its Swift extension, implementing the SDK:

```swift
import Usabilla

extension ViewController : UsabillaDelegate {

    override open func viewDidLoad() {
        super.viewDidLoad()
        Usabilla.delegate = self
    }

    func formDidLoad(form: UINavigationController) {
        present(form, animated:  true)
    }

    func formDidFailLoading(error: UBError) {
        //...
    }

    @objc public func showForm() {
        Usabilla.loadFeedbackForm("Form ID")
    }
}

```
## ThreadSafe

The SDK is currently not Threadsafe. This requires the host-app to ensure all calls to the SDK are handle on the same thread. Not doing so can result in unexpected behavior.

## Telemetry data collection

The SDK collects diagnostic data to improve the performance and optimise usage on the variety of devices it can be run on.

**The information collected is not used to identify users, does not contain PII and it's not shared with external parties
For iOS developers the data collected falls under the category 'Diagnostics' of Apples Privacy data type**

Adding the SDK to your project will NOT send any information; information is sent only in the following cases:
- Call to `initialise()` completes
- Call to `loadFeedbackForm()` completes
- Call to `sendEvent()` completes
- Exiting a feedback form

The data collected is as follows:

```json
{
  "appVersion": "1.0.0",
  "appName": "AppName",
  "device": "iphone1.2",
  "freeMemory": "831172",
  "freeSpace": "582800",
  "orientation": "Portrait",
  "osVersion": "12.1.0",
  "reachability": "WiFi",
  "rooted": false,
  "screenSize": "1440x2392",
  "sdkVersion": "7.2.0",
  "system": "ios",
  "totalMemory": "1530604",
  "totalSpace": "793488",
  "id": "34e3e3123",
  "timestamp": "2021-04-04T12:34:23Z",
  "originClass": "com.usabilla.Usabilla",
  "action": {
    "duration": "102",
    "errorCode": "0",
    "errorMessage": "",
    "name": "function or property invoked on our public interface"
    ...
    function parameters are also collected here
    ...
  }
}
```

If you wish for us not to collect this diagnostic data you can set the public field (`true` by default) as follows

```swift
Usabilla.submitTelemetryData = false
```

If the property is set to false, submitting telemetry data is turned off.


## Getting user feedback in app

When a camping or form is closed, the data is submitted to the server. If there is a need to have the responses available in the App,
the hosting app can implement a optional delegate method

```swift
 func feedbackResultSubmitted(userResponse: Data)
```
This delegate method provides you with an ```Data``` object that holds the questions / answers
The data is ```Dictionary<String:Any>```
The dictionary holds all question in a random order where the key is the name of the question and the value is the answer to the question. 
If the question is not answered ```null``` will be the value

The data can be obtained like this
```swift

	func feedbackResultSubmitted(userResponse: Data) {
        if let jsonString = String(data: userResponse, encoding: String.Encoding.ascii) {
            //// use the data
        }
    
    }
	
```

## Standard Events

From SDK **`v6.12.2`** onwards we are introducing a new feature **Standard Events**.

**Note : Now with Standard Events you can show campaigns in your application(Host application embedded with GetFeedback Digital/ Usabilla SDK) without adding any extra lines of code. You just have to create Standard Campaigns(Campaigns with Default/System Events) with your `User-Account` at `GetFeedback`.**

Currently we are supporting these lifecycle / system events : 
 - `LAUNCH` : Define as when the app is entering foreground
 - `EXIT` : Define as when the app is entering to the background
 - `CRASH` : Define as when the app is crashed ( terminated due to an unexpected behaviour)

**Note : SDK will not listen to any Default / System events, until it has been initialised and it is recommended to initialise only once. In order to make this work properly, SDK has to be initialize using `Usabilla.initialize` at the earliest possibility, preferably in the AppDelegate method:**

`func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil)`

Once the `SDK` has been initialised and is transition from the background, at this point SDK updates itself and fetches new / updated data from the server. `SDK`  will update itself periodically which is in every 12 hour once the application is entered to the foreground.
While if the application is in the background, `SDK` doesn't perform any activty, nor listening to any events.

For Default events,`SDK` only listen to system events and based on these events SDK will show a campaign. If more than one campaigns is triggered, only the oldest will be displayed, and the other(s) will be disregarded, and left to have a chance being triggered at a later time.

For the campaigns eligible with the **EXIT or CRASH** events will be added to a queue and it will be given a chance to show on the next launch, together with any other default-events triggered.

[Click here](https://support.usabilla.com/hc/en-us/articles/4747575452562) to read more about events.

##prePopulateEmailComponent

Pre-populates the email component in Usabilla forms or Campaigns with a specified email address and controls whether the user can edit it.

`swift 
	Usabilla.prePopulateEmailComponent(email: "user@example.com", editable: true)	
`

Parameters
- email: String - The email address to pre-populate in the email field
- editable: Bool - Whether the user can edit the pre-populated email address

Important Notes
⚠️ Email Validation: If the provided email is in an incorrect email format, the editable parameter will always be set to true, regardless of the value passed.
⚠️ Temporary Storage: The email string will be automatically removed once a campaign or form closes. This method should only be used at the first showing of a survey to ensure the email is properly captured.
Best Practices
Call this method before presenting a form or campaign to ensure the email is available when the user sees the survey
Validate email format on your end before calling this method if you need strict control over editability
Consider the user experience - if you're unsure about the email validity, allow editing to prevent user frustration
