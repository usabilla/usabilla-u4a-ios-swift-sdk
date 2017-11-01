## 4.0.1
#### Added

- Ability to enable debug logs in order to have more insights from the SDK while developing:
```swift
Usabilla.debugEnabled = true
```
- Display Passive Feedback Forms as a formSheet on iPad by default

#### Updated
- Design improvements for iPhone X
- Design and interaction improvements of the picker component iPhone & iPad
- Internal networking optimisation to reducing network usage when using Campaigns 

#### Fixed
- Fix status bar colour for campaign modal window
- Fix campaign navigation bar button colour in iOS 11
- Fix capitalization behaviour in e-mail component
- Fix placeholder text display behaviour on text area component
- Fix for the ‘bold’ HTML tag in iOS 11

## 4.0.0

#### Added

- Added targeted active feedback functionalities. See the [readme](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#campaigns) for more detail.

#### Updated
- Update default smilies and stars.
- Renamed `UsabillaFeedbackForm` to `Usabilla`.
- Renamed `UsabillaFeedbackFormDelegate` to `UsabillaDelegate`.
- Renamed `load()` method to `initialize(appID: String?)`. Calling this method is now mandatory to start the SDK.
- Changed `formLoadedCorrectly(_ form: UINavigationController)` to `formDidLoad(form: UINavigationController)`.
- Changed `formFailedLoading(_ backupForm: UINavigationController)` to `formDidFailLoading(error: UBError)`.
- Changed `formDidClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)` to `formDidClose(formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)`.
- Changed `formWillClose(_ form: UINavigationController, formID: String, with feedbackResults: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)` to `formWillClose(form: UINavigationController, formID: String, withFeedbackResults results: [FeedbackResult], isRedirectToAppStoreEnabled: Bool)`.
- Changed `formFailedLoading(_ backupForm: UINavigationController)` to `formDidFailLoading(error: UBError)`.
- Changed `loadFeedbackForm(_ appId: String, screenshot: UIImage?, customVariables: [String: Any]?, themeConfig: UsabillaThemeConfigurator)` to `loadFeedbackForm(_ formID: String, screenshot: UIImage?, theme: UsabillaTheme)`.
- Refactored `UsabillaTheme`. See the [readme](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#ui-customisations) for more detail.
- Redesigned the NPS component


#### Fixed
- Fixed feedback title not being displayed

#### Removed
- Removed `showCancelButton` property. The cancel button will now be always displayed.
- Removed the possibility to add specialised custom variables to passive forms. The global custom variables will be used instead from now on.


## 3.6.1

#### Fixed
- Fixed an encoding problem that would sometimes corrupt the screenshot sent to our servers
- Fixed a crash that could occur in iOS 10 on specific forms

## 3.6.0

#### Updated
- Delegate methods `formWillClose` and `formDidClose` now have an extra parameter, called `isRedirectToAppStoreEnabled`, that will reflect the ratings prompt toggle present in the web interface

## 3.5.0
#### Added
- New delegate method called `formWillClose`, that will be called when the form needs to be dismissed (see documentation for more info)

#### Updated
- Delegate method `formDidClose` will now be called only after the form has actually been closed
- The redirect to the app store feature has been updated to be in accordance with [Apple's new guidelines on rating and reviews](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk#app-store-rating)

#### Fixed
- Wrong delegate method being called when a form failed loading
- Error label being incorrectly placed behind the slider

## 3.4.4

#### Fixed
- Crash when dealing with multiple end pages and jump rules

## 3.4.3

#### Fixed
- Nested visibility rule [#44](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/issues/44)
- Checkbox control multiple line display [#42](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/issues/42)
- Scrolling issue when typing within a title [#46](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/issues/46)

#### Updated
- Button text in Thank You Page are now limited to one line.

## 3.4.2

#### Fixed
- The screenshot title set in the web interface is now correctly applied in the SDK
- Fixed a bug that would not restore the status bar to it's original color
- HTML in paragraph is now correctly rendered

## 3.4.1

#### Added
- Added the possibility to preload a form to make it available to the user even when offline. See the wiki for more informations.

#### Fixed
- The title of the thank you page is no longer being truncateds

## 3.4.0

#### Added
- Form caching. Forms loaded from our servers will be now cached locally and will be correctly displayed even when the user is offline.


#### Updated

- Updated SDK to be compatible with Swift 3.1

#### Removed

- Removed some unecessary logs


## 3.3.2

#### Fixed

- Redirect to App Store button not working correctly
- The mood control now correctly displays the 2 or 3 options mode
- The feedback result access level has been set to public

#### Updated
- Added the `form` parameter to `formDidClose`

## 3.3.1

#### Fixed

- Importing framework issue: "cannot load underlying module for 'UsabillaFeedbackForm'"

## 3.3.0

#### Added
- **UsabillaFeedbackForm.dismissAutomatically** Bool attribute to handle automatic or manual form dismiss
- **formDidClose** delegate method of **UsabillaFeedbackFormDelegate** protocol, take a look at the [documentation](Readme.MD/#submission-callback)

#### Fixed

- Screenshot image picker orientation always in portrait: now showing in the same orientation as previous view controller
- Unexpected scrolling when typing in textfield

## 3.2.1
#### Fixed

- Synchronization (thread) issue that could freeze the user interface
- Textfield position when the keyboard is showing up

## 3.2.0
#### Added
- Carthage compatibility
- Caching for feedback: when there is no internet connection feedbacks are now saved and sent when a connection is back.

 Follow [these steps](Readme.MD/#initialization) in order to enable the caching feature.

#### Removed
- Alamofire dependency
- PromiseKit dependency

#### Fixed
- Issue with the rating control (star and mood) where it was not reset correctly after reuse

#### Updated

- The methods from `UsabillaFeedbackFormDelegate` protocol are now executed in the same thread of the one where the `UsabillaFeedbackForm.loadFeedbackForm` method is executed.

 *Be sure to execute the `present(form....)` on the Main thread if you are calling `UsabillaFeedbackForm.loadFeedbackForm` in a background thread and want the form to correctly show.*

## 3.1.0
#### Added
- Possibility to configure font size in the SDK. See the wiki for more info.
- Possibility to set the titles of the form in bold.
- Added new "Add screenshot" call to action. See the wiki for more info.
- New field specific error message. This error will appear, under the field title, when the user tries to move forward in the form without having filled all mandatory fields.
- The navigation bar now has it's own color 'headerColor', settable in the SDK. If set, it will override the default color group.

#### Updated
- Revamped and polsihed the UI.
- The screenshot will now keep its aspect ratio, stretching the form if necessary.

#### Fixed
- Small bug in the paragraph component.


## 3.0.0
#### Updated
- Updated to compile against Swift 3.0
- Improved email validation
- Renamed 'feedbackFormLoadedCorrectly' to 'formLoadedCorrectly'
- Renamed 'feedbackFormLoadedIncorrectly' to 'formFailedLoading'
- Updated all dependencies to version '~> 4.0.0'

#### Removed
- Removed support to 10 button NPS, now defaults to slider

## 2.3.0
#### Added
- It is now possible to set most text fields (like submit, cancel, redirect to play store) from the web interface


## 2.2.1
#### Fixed
- Fixed a bug that could occur in the last page of the form if the thank you message was too long

## 2.2

- The give more feedback button is now hidden by default. It is possible to show it by setting UsabillaFeedbackForm.hideGiveMoreFeedback = false
- Fixed a bug that would cause some element to be rendered incorrectly on their first appearance
- Colour customisation from the Usabilla web interface is now supported
- Reworked the theme configuration, now every form has its own configuration object


## 2.1.1

- Renamed initSDKWithScreenshot to loadFeedbackForm
- Fixed a memory leak what could cause problems with multiple openings of a form
- Fixed a crash that would occur when using a custom font that was not bundling the bold and italic version. It is still recommended to use the whole font family when setting a custom font.

## 2.1

- SDK updated to be compatible with Swift 2.3
- Fixed some broken constraint
- Fixed typo on UsabillaFeedbackFormDelegate
- Reduced number of dependencies
- In UsabillaThemeConfigurator, statusBarColor has been changed from UIBarStyle to UIStatusBarStyle
- SDK no longer use custom font as default
- Minor fixes and improvements

## 2.0.5

- Fixed a crash occurring when there was no internet connection
- Fixed some localisation issues
- Removed some unnecessary dependencies