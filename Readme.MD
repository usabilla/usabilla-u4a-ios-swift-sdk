# Usabilla for Apps - iOS SDK
This repository contains the SDK for iOS and relative CocoaPods spec.
Take a look at our [Wiki](https://github.com/usabilla/usabilla-u4a-ios-sdk/wiki) for a complete and in depth guide on how to install and customize the SDK.

# Installation 

## Using CocoaPods

Include `pod 'UsabillaFeedbackForm', :git => 'https://github.com/usabilla/usabilla-u4a-ios-swift-sdk.git'` in your Pod file and run `pod install` to install the SDK.


## How to get started

### On the web
- Create a new app on your [Usabilla](https://app.usabilla.com/member/) Live for Apps section.
- Copy th AppId from the app you wish to use in your SDK.


### On the SDK
- Include `import UsabillaFeedbackForm` in your ViewController.
- Save the AppId you created on the web on a local variable.
- If you want, you can take an optional screenshot of the current view wherever you feel is appropriate with `let image = UsabillaFeedbackForm.takeScreenshot(self.view)`
- Implement the `UsabillaFeedbackFormDelegate` protocol in your ViewController
- Launch the form with: 

```
UsabillaFeedbackForm.initSDKWithScreenshot("appId", screenshot: nil, customVariables: nil)

```

Pass `nil` as the `screenshot` parameter if you don't want to have a screenshot of the current view

