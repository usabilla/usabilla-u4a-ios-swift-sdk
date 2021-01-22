## 6.6.1
### Fix
- voiceover issue for mood component
- header element cut off due to scroll

### Update
- Xcode supported above 10.3

## 6.6.0
### Fix
- SDK now randomize questions, marked as random
- fix a bug, where campaigns would resize incorrectly when returning from background
- localised string file, can now be partial adopted. Missing string in customer file, will be read from default
### Update
- added properties to disable "powered by" logo click-ability

## 6.5.0
### Fix
- Fix crash under iOS 13 & 14, after dismissing campaign.

## 6.4.7
### Fix
- Fixes crash under iOS 13, after dismissing campaign, and rotating device
- Fixes swipe-to-remove campaigns under iOS 13, in some situation causing a UI freeze

## 6.4.6
### Update
- build with Xcode 11.4, to support Carthage

## 6.4.5
### Fix
- Fixes issue where banner could overlap safe-area 
- Fixes issue where targeting on other languages could fail
- Fixes issue with font in HTML enabled paragraphs
- Fixes issue with crash under iOS 13 

## 6.4.4
### Fix
- Fixes issue where SDK, in some cases could crash if a campaign was canceled by user, and a new was triggered
- Fixes issue where error-text in form could overlap card components (iOS 10+)

## 6.4.3
### Add
-  Framework compiled for Module Format Stability

## 6.4.2
### fix
-  issue where error message is truncated

## 6.4.1
### Fixed
- iPad iOS 13 issue
- Font issue for title
- Truncation of title in elements

## 6.4.0
### Added
- User can, after selecting an image, draw on the image to mask or highlight features
### Fixed 
- crash when only landscape was selected in Device Orientation 
### Change
- Carthage changed to use binary (thanks to Igor Palaguta)  

## 6.3.0
### Added
- User can choose between camera or image library as source when adding screenshot
### Fixed
- Issue where form didn't always scroll up when keyboard was presented
- Issue where jump-rules on end page didn't work correctly 

## 6.2.0
### Added
- Method to mask personal identifiable information in the public interface.
- Method to remove a displayed form programmatically.
### Fixed
- Runtime warning

## 6.1.0
### Added
- Support for **Xcode 10.2**
- Developer can force a specific orientation for the SDK, overriding the device orientation
#### Fixed
- ProgressBar hides or shows, according to settings in Form or Campaign editor
- ProgressBar displays progress correct
- Drop-downs now react correctly on touch
- Changed secondary button color to text color
- Links in Paragraphs now appears with the right text color
- Alignment issue on text in banner
- Fixed an issue where a malformed Campaign could make the SDK crash
- Header layout corrected
- Typo in "usa_localizable.strings"; usa_screnshot_placeholder changed to usa_screenshot_placeholder
### Change
- Improved SDK documentation

## 6.0.2
#### Fixed
- Fixing rotation issue, that could occur in Campaigns 

## 6.0.1
#### Fixed
- Release issue
#### Change
- Minor change to podspec file


## 6.0.0
#### Fixed
- Support for 32 and 64 bit
- Code changed to handle statusBarStyle under iOS 12 as well
#### Change
- Design changes to Forms and Campaigns

## 5.1.4
#### Fixed
- LLVM issue

## 5.1.3
#### Fixed
- Paragraph component cells overlay on top of other cells.

## 5.1.0
#### Added
- Support for **Xcode 10**
- Accessibility/VoiceOver: Better Accessibilty for the slider component.
- Accessibility/VoiceOver: Change the mood component labels.

## 5.0.2
#### Added
- Support for **Xcode 10 beta**
- Add animations to the Mood component.

## 5.0.1
#### Added
- Support for **Xcode 9.4**
- Minor improvements in the SDK.

## 5.0.0
#### Added
- Accessibility/VoiceOver: Support Dynamic type only for iOS 11+. 
- Accessibility/VoiceOver: Toast duration is increased depending on the text length.
#### Fixed
- Accessibility/VoiceOver: Fix the banner mood component moving to the next page when the campaign has no continue button.
- Fix the color of `Powered by usabilla` to be setup by the theme.
#### Updated
- Rename `preloadFroms` to `preloadFeedbackForms`
#### Removed
- Remove `giveMoreFeedback` option from the SDK interface.

## 4.1.2
#### Added
- Support for **Xcode 9.3**
#### Fixed
- Accessibility/VoiceOver: Fix the NPS Component value that was not changing.
- Accessibility/VoiceOver: fix for the PickerView component.
- Accessibility/VoiceOver: fix an unhandeled jump while the screenshot component is visible.

## 4.1.1
#### Added
- Accessibility/VoiceOver support for Screenshot and PickerView components.
- Added callback parameter to the initialize method to notify when it's finished. See the Readme for more information

## 4.0.3
#### Added
- Accessibility/VoiceOver support for Checkboxes, radio buttons and other minor components

#### Updated
- Moved the cancel button to the right side on the end page
- Screenshot component UI

#### Fixed
- Fixed the placeholder on the text area not correctly displaying on multiple lines

## 4.0.2
#### Added
- Add accessibility/VoiceOver support for
    - Rating control (mood, star)
    - Navigation/Focus management between views
    - Required fields indicator

#### Fixed
- Fix UIBarButtonItem appearance customizations that may affect the host application

## 4.0.1
#### Added
- Support for **Xcode 9.1**
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
