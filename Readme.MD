# Usabilla for Apps - iOS SDK
This repository contains the SDK for iOS and relative CocoaPods spec.
Take a look at our [Wiki](https://github.com/usabilla/usabilla-u4a-ios-sdk/wiki) for a complete and in depth guide on how to install and customize the SDK.

# Installation 

## Using CocoaPods

Include `use_frameworks!` and `pod 'UsabillaFeedbackForm', '~> 2.1'` in your Pod file and run `pod install` to install the SDK.


## How to get started

### On the web
- Create a new form on your [Usabilla for Apps](https://app.usabilla.com/member/) section.
- Copy the FormId from the form you wish to use in your SDK.


### On the SDK
- Include `import UsabillaFeedbackForm` in your ViewController.
- Save the FormId you created on the web on a local variable.
- If you want, you can take an optional screenshot of the current view wherever you feel is appropriate with `let image = UsabillaFeedbackForm.takeScreenshot(self.view)`
- Implement the `UsabillaFeedbackFormDelegate` protocol in your ViewController and set your controller as delegate with `UsabillaFeedbackForm.delegate = self`
- Launch the form with: 

```
UsabillaFeedbackForm.loadFeedbackForm("appId", screenshot: nil, customVariables: nil)

```

Pass `nil` as the `screenshot` parameter if you don't want to have a screenshot of the current view

