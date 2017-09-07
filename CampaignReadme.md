# Usabilla for Apps - iOS SDK
Usabilla for Apps allows you to collect feedback from your users with great ease and flexibility.


## Requirements
- iOS 9.0+
- Xcode 8.0+
- Swift 3.1+


## Installation

### Github setup

Since this is a temporary private repository, you will need to be authenticated with Github to be able to access it.
Our organization uses 2FA, you will also need to enable it for your Github account.

Fetching the SDK using SSH will only require you to configure your public key with Github.
Using HTTPS will require generating a [personal access token](https://github.com/settings/tokens) to log into Github.

### CocoaPods

The Usabilla SDK is available on [CocoaPods](http://cocoapods.org). You can install cocoapods the following way:

```bash
$ gem install cocoapods
```

To use the SDK in your project, specify it in your `Podfile`:

```
source 'https://github.com/usabilla/u4a-ios-pilot'

target 'YourProjectTarget' do
  use_frameworks!

  #With SSH
  pod 'UsabillaFeedbackForm', :git => 'git@github.com:usabilla/u4a-ios-pilot.git', :branch=> 'master'

  #Or with HTTPS
  pod 'UsabillaFeedbackForm', :git => 'https://github.com/usabilla/u4a-ios-pilot.git', :branch=> 'master'

  #Specifying a tag
  pod 'UsabillaFeedbackForm', :git => 'git@github.com:usabilla/u4a-ios-pilot.git', :tag=> '4.0.0-RC7'

End
```

Then, run the following command:

```bash
$ pod install
```

<!-- ### Carthage

The Usabilla SDK is also available through [Carthage](https://github.com/Carthage/Carthage).

Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
to add carthage to your project.

And add this line to your `Cartfile`:

```yaml
github "usabilla/usabilla-u4a-ios-swift-sdk" "v3.6.0"
``` -->

### Manual

Alternatively, you can download the latest version of the repository and add **UsabillaFeedbackForm.framework** to your app’s embedded frameworks.


- Create a new form on your [Usabilla](https://app.usabilla.com/member/) Live for Apps section.


## Implement the SDK

### Initialization

Inside your **AppDelegate** add the following line at the top of your file to import the SDK.

```swift
import UsabillaFeedbackForm
```

Add the following line to the **didFinishLaunchingWithOptions**:
```swift
UsabillaFeedbackForm.initialize(appID: "appID")
```
The **initialize** method will take care of:
* Submit any pending feedback item
* Fetch and update all campaign associated with the app ID
* Initialize a few background processes of the SDK



### Using Campaigns
Version 4 of the Usabilla for Apps Swift SDK introduces the new campaigns functionality.
This guide describes the Campaigns feature and all the steps necessary to work with it.

In the Usabilla for Apps Platform, we define a campaign as a proactive survey targeted to a specific set of users.

Being able to run campaigns in your mobile app is great because it allows you to collect more specific insights from your targeted users. What is even better is that creating new and managing existing campaigns can be done without the need for a new release of your app. Everything can be managed from the Usabilla web interface.

You can run as many campaigns as you like and target them to be triggered when a specific set of targeting options is met. The survey that is displayed to the user can be configured just like you are used to with the existing feedback forms in your app.

The most important aspect of running a mobile campaign are 'Events'. Events are custom triggers that are configured in the SDK. When a pre-defined event occurs, it will allow you to trigger a campaign. A good example of an event is a successful purchase by a user in your app.

### The App Id
The app Id is an identifier used to associate campaigns to a mobile app.
By loading the SDK with a specific App Id, it will fetch all campaigns connected to said App Id and start running them on the device.

It is possible to target a campaign to more than one app (e.g. iOS Production App, iOS Beta App) by associating it with multiple App Ids.

### Targeting options
Campaigns are triggered with events. Events are used to communicate to the SDK when something happens in your app, so that the SDK can react accordingly to what you have set in our web interface.
To send an event to the SDK, use `sendEvent(event: String)`.

When that event will be sent to the SDK, the campaign will appear.

There are a few options that allow you to have a more specific targeting:
- You can set a number of times that event has to occur (e.g. 3 times).
- Specify the percentage of users for whom the campaign should be triggered (e.g. 10%).

You can also segment your user base using custom variables.
Custom variables can be used to specify some traits of the user and limit the campaign only to a specific subset.

For more on how to use custom variables, read [Custom Variables](#adding_custom_variables)

**Note: A campaign will never be triggered for the same user more than once.**

### Campaign Toggling

Sometimes the user of your app is in the middle of a delicate process and should not be disturbed.
To make sure no campaigns trigger at an inappropriate moment, you can set the boolean property `canDisplayCampaigns` of `UsabillaFeedbackForm` to suit your needs.

Setting it to `true` will allow the SDK to display any campaign when it triggers.
Setting it to `false` will prevent any campaign from being displayed.

**If a campaign triggers while `canDisplayCampaigns` is `false`, it won't be displayed nor delayed: That event instance will be lost.**

By default, `canDisplayCampaigns` is set to `true`.

There is an important reason why a campaign is not delayed for display if the `canDisplayCampaigns` was `false` when the campaign is triggered and later changes to `true`. The reasoning is that displaying a campaign should happen when the targeted event occurs. We can assume that the events configured in your application are also triggered at a proper time in order to display it to your users.


### Managing an existing campaign

After you create a new campaign in the Usabilla for Apps [Campaign Editor](https://app.usabilla.com/member/live/apps/campaigns/add) you can start collecting results. By default, new campaigns are marked as inactive. From the Usabilla web interface, on the Usabilla for Apps [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/), you can activate a campaign. Once you have received a satisfying amount of responses you can deactivate it.

At any time you can update the survey content of your campaign (e.g. questions). Keep in mind that the changes you make to an existing campaign might affect the integrity of the data you collect (different responses before and after a change).

Furthermore, you can also change the targeting options of a campaign. Keep in mind that updating the targeting options of an active campaign will reset any progression previously made on the user's device.

### Campaign results

Aggregated campaign results are available for download from the [Campaign Overview](https://app.usabilla.com/member/#/apps/campaigns/overview/). Here you download the results per campaign, in the CSV format.

Campaign results will contain the answers that your users provided. The campaign feature collects campaign results page by page. This means that even if the user abandons the campaign halfway through, you will still collect valuable insights. When a user navigates to a new page, then the results of the previous page are submitted to Usabilla. Besides the results showing the answers to your questions, campaigns will always contain metadata from the device.

As for campaign results. Please note that editing the form of an existing campaign will affect the aggregated campaign results:

- Adding new questions to a form will add an additional column to the CSV file.
- Removing questions from an existing form will not affect the previously collected results. The associated column and its data will still be in the CSV file.
- Replacing the question type with a different question is also possible. When you give the same 'name' in the Usabilla for Apps Campaign Editor, then results are represented in the same column.




## Passive feedback
Passive feedback are feedback forms that are not triggered by events.
They are mostly, but not necessarily, initiated by the user.


### Loading a form

The SDK uses the Form ID you previously got from [Usabilla](https://app.usabilla.com/member/) to fetch and display your form inside your app.

A basic implementation of the SDK would be the following.

```swift
class ViewController: UIViewController, UsabillaFeedbackFormDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        UsabillaFeedbackForm.delegate = self
        UsabillaFeedbackForm.loadFeedbackForm("Form ID")
    }

    //Called when your form succesfully load
    func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {
        present(form, animated: true, completion: nil)
    }
    //Called when your forms can not be loaded. Returns a default form
    func formFailedLoading(_ backupForm: UINavigationController) {
        present(backupForm, animated: true, completion: nil)
    }

}
```


### Adding a screenshot

It is possible to attach a screenshot to a feedback form.

You can take a screenshot at any moment calling `let image = UsabillaFeedbackForm.takeScreenshot(self.view)`.

To attach the screenshot to the form, pass it as a parameter when calling `UsabillaFeedbackForm.loadFeedbackForm("Form Id", screenshot: image)`

Pass `nil` as the `screenshot` parameter if you don't want to have a screenshot of the current view.

**Custom Screenshot & Sensitive Information**

Instead of taking the screenshot using the `UsabillaFeedbackForm.takeScreenshot()` method, you can provide any image you wish by passing it as the `image` parameter when calling `UsabillaFeedbackForm.loadFeedbackForm()`

This will allow you to hide any user sensitive or private information by, for example, taking the screenshot yourself, removing all unwanted information and submitting the censored version.


<!-- ### Preloading a form
If you know you will need to display a feedback form when the user is offline, you can preload it a cache it in the SDK to make it available at any given moment.
To preload a form use
```
UsabillaFeedbackForm.preloadForms(withIds: ["myId", "myOtherId"])
```
This will fetch the latest version of the form and cache it in the SDK.
 When you will request that form, if there is no network connectivity, the SDK will use the cached version and your user will be able to submit his feedback

Feedback submitted while offline will be sent when connectivity is restored.

If you wish, you can empty the cache using
```
UsabillaFeedbackForm.removeCachedForms()
``` -->

### Handle manual dismiss

Since **v3.3.0** it is possible to customize the way the form is dismissed

Set the automatic UsabillaFeedbackForm dismissal attribute to false:

```swift
UsabillaFeedbackForm.dismissAutomatically = false
```

and implement the **formWillClose** delegate method:

```swift
func formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool) {
    // handle your custom dismiss e.g: dismiss(animated: true, completion: nil)
}
```

**Warning**: by doing this the form will not dismiss by itself and you will be the only one responsible for its correct behavior. Also, the delegate method `formDidClose` will not be called.


## Other configuration


### Adding custom variables

You can pass along custom variables that will be attached to the feedback users send.
Custom variables are held in a dictionary object, in the public interface of the SDK, called `customVariables`.

You can set custom variables using the public method
`UsabillaFeedbackForm.setCustomVariable(value: Any?, forKey: String)`

or by simply modifying the dictionary object

`UsabillaFeedbackForm.customVariables["key"] = "value"`

**Since the SDK is using [JSONSerialisation](https://developer.apple.com/documentation/foundation/jsonserialization) to convert the custom variables to JSON, its limitation have to be taken into account.
The `value` of a custom variable must then be an instance NSString, NSNumber, NSArray, NSDictionary, or NSNull.**   
Trying to set an invalid object as custom variable will result in that object not being set and in an error being printed in the console.   

You can always check whether an object is considered valid or not by calling `JSONSerialization.isValidJSONObject(object)`



Custom variables are added as extra feedback data with every feedback item sent by the SDK, whether from a passive form or a campaign.

**Custom variables will also be used as targeting option, as long as the value is a String.**

### App Store rating

To decide whether or not to prompt the user for a rating, you can read the information regarding the user's activity passed in the [Submission callback](#submission-callback)

In the Usabilla web interface, it is possible to define whether a specific feedback form should prompt the user for a rating.

### Submission callback

Since **v3.3.0** it is possible to get information about the feedback the user has left by implementing UsabillaFeedbackFormDelegate.**formDidClose** method, for the passive forms, and UsabillaFeedbackFormDelegate.**campaignDidClose** for the campaigns.

You will also be notified if the user has left the form without submitting it.

This method provides you with an array of (or a single) **FeedbackResult**:

```swift
struct FeedbackResult {
    let rating: Int?
    let abandonedPageIndex: Int?
    var sent: Bool
}
```

This is because, for the passive form, the user may submit the form multiple times and this method will be called only once for all feedback sent.

The **rating** value is set as soon as the user interacts with it and will be reported even if the form is not submitted.

The **abandonedPageIndex** is only set if the user cancels the form before submission.

Here is a sample implementation :

```swift
func formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool){
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


## Customisations

### Custom Emoticons
It is possible to use custom images instead of the one provided natively in the SDK.

To do so, you must provide a list (or two, depending on what you want to achieve) of five UIImage that will be used instead of the Usabilla's default emoticons.
The element 0 will be the lowest or leftmost item, while the 5th element will be the highest or rightmost.
At the moment, the SDK does not perform any check to make sure the lists are valid.

#### Provide only the selected version
You can provide only one list containing the selected version of the icons.

The images will be displayed with an alpha value of 0.5 when unselected, and with an alpha value of 1 when selected.


```
    let a = UIImage(named: "1")!
    let b = UIImage(named: "2")!
    let c = UIImage(named: "3")!
    let d = UIImage(named: "4")!
    let e = UIImage(named: "5")!
    UsabillaFeedbackForm.theme.enabledEmoticons = [a,b,c,d,e]

```

#### Provide both the selected and unselected version
You can provide two lists containing the selected and the unselected version of the icons.

The icons drawable will be selected from one of the two lists according to its state.
```

    let enabled = createEnabledArray()
    let disabled = createDisabledArray()

    UsabillaFeedbackForm.theme.enabledEmoticons = enabled
    UsabillaFeedbackForm.theme.disabledEmoticons = disabled

```

### Custom Stars

You can change the appearance of the star in the Star Rating by setting both fullStar and emptyStar in the UsabillaThemeConfigurator.
The first will be the full star, the second the empty version.

Keep in mind that, in order to see a Rating Bar in your form, you must first enable it in the [Usabilla for App](https://app.usabilla.com/member/apps/) page.

```
    UsabillaFeedbackForm.theme.fullStar = UIImage(named: "fullStar")!
    UsabillaFeedbackForm.theme.emptyStar = UIImage(named: "emptyStar")!

```

### Custom Fonts

It is possible to change the font of the feedback form setting the property `customFont` of the `UsabillaThemeConfigurator` object.

Since the SDK uses also the bold and italic version of the font, it is recommended to use a file containing the whole font family when setting a custom font.
If that is not the case, the SDK will use the default system font for the italic and bold phrases.


`UsabillaFeedbackForm.theme.customFont= UIFont(name: "Helvetica-LightOblique", size: 20)`

### Custom colors

You can customise the colors of all elements of the form.
For a more in depth guide on customisation see the [Wiki page](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/wiki/Changing-colors)


### Localisation

For all the text that is not customizable in the web interface, you can provide your own translation using a .string localized file inside your application.

### String file contents
If you want to provide your own translation, you need to override **all** the keys in the default .string file.


The default file with the keys and the default text is the following:
```
//Default usabilla english localisation
"usa_form_required_field_error" = "Please check this field";
"usa_screnshot_placeholder" = "Add screenshot";

```

Failure to override a key will display the key itself instead as the text.

If you want to use your custom .string file, you can do so by calling

`    UsabillaFeedbackForm.localizedStringFile = "your_localization_file_name"
`

With the name of your file, without the .string extension.

## Integration with Obj-C applications

To integrate the SDK in your Obj-C application, follow apple official guidelines on how to [use Swift and Objective-C in the Same Project](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

A quick way to approach this problem is to create a Swift file from where you will handle your application. After creating the new file and having set up the Bridging Header, you can extend your existing view controllers inside the Swift class to seamlessly integrate the SDK in your app.

In this example you can see a ViewController in Obj-C:

```objectivec
#import "ViewController.h"

//Remember to import the auto generated Swift header, otherwise you won't see you Swift extension
#import "objctest-Swift.h"


@interface ViewController ()

@end

@implementation ViewController


- (IBAction)buttonPressed:(id)sender {
      [self  showForm];

}


@end

```

And its Swift extension, implementing the SDK:

```swift
import UsabillaFeedbackForm

extension ViewController : UsabillaFeedbackFormDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        UsabillaFeedbackForm.delegate = self
    }


    public func formLoadedCorrectly(_ form: UINavigationController, active: Bool) {
        present(form, animated:  true)
    }

    public func formFailedLoading(_ backupForm: UINavigationController) {

    }

    @objc public func showForm(){
        UsabillaFeedbackForm.loadFeedbackForm("Form ID")
    }
}

```
