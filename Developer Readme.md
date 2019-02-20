# Working on the SDK
* Open **Usabilla.xcworkspace** to work on the SDK
* This workspace contains 4 schemes: 
    * **Usabilla**: This is the main scheme (public released)
    * **UsabillaInternal**: Adds an additional API to the *Usabilla* scheme that is used by our development team
    * **UsabillaUITestApp**: Linked to the **UsabillaUITestApp** folder and contains a project used to run the UITests.
    * **SwiftDevApp**: Linked to the **UsabillaExample.custom** folder, is to be used to develop against the *Usabilla* scheme

# Building 
## Using Fastlane
* The project builds for a number of Xcode versions. They are found in the **config.json** file
 * **lastXcodeVersion** is the version to use in test
 * **xcodeVersions** is the array of Xcode version to build for
 * **uiTestDevices** is the identifier of the Simulator device tests are run on
 * **unitTestDevices** is the device unitTest are run on

* The fastlane lane **buildAllAndGenerateArtefacts** or the **BuildAll** will create the library. Both carthage and Pods library are created, and store in a folder with the Xcode & version number eg Xcode-9.4 

* Use the appropriate version in Your project

# Installing
* Run fastlane **buildAllAndGenerateArtefacts** or **BuildAll**, to create the Usabilla.framework files
* Drag the Usabilla.framework into Your project
* Make sure it's added as a **Embedded Binaries** as well as a **Linked Frameworks and Libraries**
* Add **'import Usabilla'** in the swift files where You call Usabilla methods.

* Refer to the public manual, on how to use the SDK [Readme.Md](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/blob/master/Readme.MD)


# Tests
## Running unit tests
### With Xcode
* Select **Usabilla** Scheme and run *Product* -> *Test*

### From the Command line (using Fastlane)
* `bundle exec fastlane buildForUnitTesting && bundle exec fastlane unitTest deviceModel:"iPhone 6"`

## Running UI tests
### With Xcode
* Select **UsabillaUITest** Scheme and run *Product* -> *Test*

### From the Command line (using Fastlane)
* `bundle exec fastlane buildForUITesting && bundle exec fastlane uiTest`

## Running Integration tests
### With Xcode
* Open *automation/UsabillaIntegrationTest/UsabillaIntegrationTest.xcodeproj* and run *Product* -> *Test*

### From the Command line (using Fastlane)
* `bundle exec fastlane integrationTests`

