## 3.2.0
#### Added
- Carthage compatibility
- Caching for feedback: when there is no internet connection feedbacks are now saved and sent when a the connection is back

#### Removed
- Alamofire dependency
- PromiseKit dependency

#### Fixed
- Issue with the rating control (star and mood) where it was not reset correctly after reuse

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
