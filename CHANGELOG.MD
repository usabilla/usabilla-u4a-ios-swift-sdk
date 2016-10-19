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
