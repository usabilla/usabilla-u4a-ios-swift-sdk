# Usabilla for Apps - iOS SDK
Usabilla for Apps allows you to collect feedback from your user with great ease and flexibility.

Take a look at our [Wiki](https://github.com/usabilla/usabilla-u4a-ios-sdk/wiki) for a complete and in depth guide on how to install and customize the SDK.

## Latest changes in v3.2.1
#### Added
- Carthage compatibility
- Caching for feedback: when there is no internet connection feedbacks are now saved and sent when a connection is back.

 Follow [these steps](#initialization) in order to enable the caching feature.

#### Removed
- Alamofire dependency
- PromiseKit dependency

#### Fixed
- Issue with the rating control (star and mood) where it was not reset correctly after reuse
- Synchronization (thread) issue that could freeze the user interface
- Textfield position when the keyboard is showing up

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 3.0+

For older versions of iOS you can use v2.3.0 of the SDK.

## Installation

### CocoaPods

The Usabilla SDK is available on [CocoaPods](http://cocoapods.org). You can install cocoapods the following way:

```bash
$ gem install cocoapods
```

To use the SDK in your project, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
    pod 'UsabillaFeedbackForm', '~> 3.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

The Usabilla SDK is also available through [Carthage](https://github.com/Carthage/Carthage).

Follow [these instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
to add carthage to your project.

And add this line to your `Cartfile`:

```yaml
github "usabilla/usabilla-u4a-ios-swift-sdk" "v3.2.1"
```

### Manual

Alternatively you can download the latest version of the repository and add **UsabillaFeedbackForm.framework** to your app’s embedded frameworks.

## How to get started

### On the web
- Create a new form on your [Usabilla](https://app.usabilla.com/member/) Live for Apps section.
- Copy the Form ID of the form you just created and use it to open it in the SDK.


### In the SDK

#### Initialization

Inside your **AppDelegate** add the following line at the top of your file to import the sdk.

```swift
import UsabillaFeedbackForm
```

Add the following line to the **didFinishLaunchingWithOptions**:
```swift
UsabillaFeedbackForm.load()
```
The **load** method is here in order to init the caching feature : submit the previously submitted feedbacks.

#### Using forms


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

## Usage

### Adding a screenshot

It is possible to attach a screenshot to a feedback form.

You can take a screenshot at any moment calling `let image = UsabillaFeedbackForm.takeScreenshot(self.view)`.

To attach the screenshot to the form, pass it as a parameter when calling `UsabillaFeedbackForm.loadFeedbackForm("Form Id", screenshot: image)`

Pass `nil` as the `screenshot` parameter if you don't want to have a screenshot of the current view.

**Custom Screenshot & Sensitive Informations**

Instead of taking the screenshot using the `UsabillaFeedbackForm.takeScreenshot()` method, you can provide any image you wish by passing it as the `image` parameter when calling `UsabillaFeedbackForm.loadFeedbackForm()`

This will allow you to hide any user sensitive or private information by, for example, taking the screenshot yourself, removing all unwanted information and submitting the censored version.

### Adding custom variables

You can pass along custom variables that will be attached to the feedback users send.
Custom variables are held in a dictionary.

After you have initialised your controller, you can easily set custom variables using
```
var customVariables: [String : Any] = [:]
customVariables["user"] = "Mario"
customVariables["age"] = 10
```

You can create one beforehand or on the fly, as shown in the example, and its content will be reported and displayed in the Usabilla web interface.

To make sure the variables are properly displayed in the web interface it is advised to keep the dictionary object fairly simple and to not nest more than one object into another.

Custom variables are added as a parameter when calling `UsabillaFeedbackForm.loadFeedbackForm("Form ID", screenshot: nil, customVariables: customVariables)
`


### Customising the form

You can customise the colors of all elements of the form.
For a more in depth guide on customisation see the [Wiki page](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/wiki/Changing-colors)


### App Store rating

It is possible to invite the user to leave a review of your application in the App Store once he has submitted the form.

This invitation will only be showed if:
* The user gave a positive rating (4-5 / 5) in the feedback form.
* You have set `UsabillaFeedbackForm.appStoreId = "id"` with the app store id of your application.
* You have enabled the feature in the Usabilla web interface, in the advanced edit settings of the form (default is disabled)  

You have to specify the app id omitting the initial "id", leaving only the numerical part.


## Integration with Obj-C application

To integrate the SDK in your Obj-C application, follow apple official guidelines on how to [use Swift and Objective-C in the Same Project](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)

A quick way to approach this problem is to create a Swift file from where you will handle your application. After creating the new file and having set up the Bridging Header, you can extend your exsisting view controllers inside the Swift class to seamlessy integrate the SDK in your app.

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
