[![codecov](https://codecov.io/gh/usabilla/usabilla-u4a-ios-swift/branch/develop/graph/badge.svg?token=2LnXmvPDeU)](https://codecov.io/gh/usabilla/usabilla-u4a-ios-swift)

# Installation
## Software requirements
* Xcode 8.3.3 or Xcode 9+
* ruby 2.4.2 (use [rbenv](https://github.com/rbenv/rbenv) to manage multiple versions)
* [bundler](http://bundler.io)
* [carthage 0.27.0](https://github.com/Carthage/Carthage)
    * run `brew update && brew upgrade carthage` to get the latest version

## Fetching the project
* Clone the repository : `git clone git@github.com:usabilla/usabilla-u4a-ios-swift.git`
* Install submodules : `git submodule update --init --recursive` : this will fetch the [SDK-UI-Scenario](https://github.com/usabilla/SDK-UI-Scenarios) repository which is necessary for running UI and Integration tests.

## Install dependencies
* Gems: `bundle check --path=vendor/bundle || bundle install --path=vendor/bundle --jobs=4 --retry=3`
* Carthage: `carthage update --platform iOS --use-ssh --no-use-binaries`

## Setup the example project
* Make a copy of `UsabillaExample` directory and rename it to `UsabillaExample.custom`: this allows making local code changes within the example app project when developing with the SDK and not being annoyed by changes displayed by GIT as `UsabillaExample.custom` is in the *.gitignore* file.

# Working on the SDK
* Open **Usabilla.xcworkspace** to work on the SDK
* This workspace contains 4 schemes: 
    * **Usabilla**: This is the main scheme (the one that is publicly released)
    * **UsabillaInternal**: This scheme adds an additional API to the *Usabilla* scheme that is used by our [Internal Testing App](https://github.com/usabilla/usabilla-u4a-ios-internal-testing) and [Preview App](https://github.com/usabilla/usabilla-u4a-ios-new-preview)
    * **UsabillaUITestApp**: This scheme is linked to the **UsabillaUITestApp** folder and project that contains a project in order to run the UITests.
    * **SwiftDevApp**: This scheme is linked to the **UsabillaExample.custom** folder and project and is meant to be used to develop against the *Usabilla* scheme

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

## Releasing the SDK
* Follow the [Release Manual](ReleaseManual.md)

## Automation & CI

### Fastlane
This project uses Fastlane in order to automate, test, build and release the SDK. The *fastlane* folder contains all the scripts related to this.

### Jenkins
The **JenkinsFile** contains all the steps that are followed during continuous integration.

### ReleaseValidator
The *automation* folder contains the **ReleaseValidator** project that is used when performing a release. You can read more about validating a release in the [Release Manual](ReleaseManual.md)

# SDK Developer Manifest

## Code writing
* Write testable code
* Pass linter check
* No warnings
* Adopt language/platform conventions
* Early return
* Try not to use else
* Clear/Explicit/meaningful name for variables, constants, classes, methods, types…
* Follow the SOLID principles.

## Testing
* Never lower the percentage of code coverage
* Test expected and unexpected behaviour
* Write atomic test
* No stupid test

## Commits
* Prefix the commit messages with an Emoji like 📦 for **refactoring** or 🚨 for **unit tests**.

 See the complete list here:

 [GitHub - dannyfritz/commit-message-emoji: Every commit is important. So let’s celebrate each and every commit with a corresponding emoji!](https://github.com/dannyfritz/commit-message-emoji)
* Use explicit sentence for describing the commit e.g:

 🚨 **Add** unit tests for network manager class

 🐛 **Fix** issue #0123 where the placeholder was not set in the email field

 More info here:

 [How to Write a Git Commit Message](http://chris.beams.io/posts/git-commit/)