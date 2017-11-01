# iOS SDK Release Manual

Version: 0.2    
Last Modified: 15/05/2017

## Release process
This document will guide you through all necessary steps to release the iOS SDK.
This document will assume the following:
* You have the necessary keys and permission
* You are familiar with the [semantic versioning guidelines](http://semver.org/) and you have already decided the new version number according to them.
* You are familiar with the team SDK repositories and their structure
* You are familiar with [CocoaPods](https://github.com/CocoaPods/CocoaPods) and [Carthage](https://github.com/Carthage/Carthage)

The release process can be divided in two smaller releases, an internal one and a public one.
* The internal one is performed on the [private repository](https://github.com/usabilla/usabilla-u4a-ios-swift) and it's used by the development team to keep track of SDK versions and releases.
* The public one is performed on the [public repository](https://github.com/usabilla/usabilla-u4a-ios-swift-sdk) and it's used to deliver the new SDK to our customers.

The following is a summary of all the steps you need to follow. A more detailed explanation of each step is provided later in the document.

### Step list
1. Documentation update
   1. [Open a release branch in the public repository](#open-a-release-branch-in-the-public-repository)
   2. [Update the changelog.md file](#updating-changelog)
   3. [Update the readme.md file](#updating-the-readme)
   4. [Update the public wiki](#updating-the-wiki)
   5. [Update the example project](#updating-the-example-project)
2. Internal Release
   1. [Increase the SDK version](#increase-the-sdk-version)
   2. [Update the master branch](#update-the-master-branch)
3. External Release
   1. [Build the frameworks](#build-the-frameworks)
   2. [Publish the SDK to Cocoapods](#publish-the-SDK-to-cocoapods)
   3. [Update the public master branch](#update-the-public-master-branch)
   4. [Create a release on Github](#create-a-release-on-github)




## Step Description

### Documentation Update

#### Open a release branch in the public repository
During the release process, we will modify many files contained in the public repository, such as documentation and example projects.    
Before starting this process a release branch must be created.   
In the **public repository**, create a new branch from **`master`** called **`release/vX.Y.Z`**.       
All file modifications will be done on this branch which will be rebased on **master** after the release process is finished.    

#### Updating the podspec file
The podspec file holds the configuration of the pod published on CocoaPods.

To release a new version, it is sufficient to change the `s.version` line to the new version.   
The new version includes just the digits, in the `X.Y.Z` format.

#### Updating changelog

The changelog is a file containing all and only the changes relevant to an external SDK user. It is not a file used for documenting internal changes.       
The changelog must have the following structure:

```
## VERSION (ex. 3.3.1)
#### Added
- Here must be listed all new features or behaviours that were previously absent in the SDK.
- (ex. Possibility to set the titles in bold.)
#### Updated
- Here must be listed all changes made to existing features or behaviours. These do not include bug fixes.
- (ex. Revamped and polished UI and animations)
#### Removed
- Here must be listed all removed features or behaviours in the SDK. Also, any dropped support to OS versions or platform must be added.
- (ex. It's not possible anymore to force a user to submit a screenshot)
#### Fixed
- Here must be listed all fixes that were done in the SDK. If the issue had a relative github issue, the same must be liked at the end of the line.
- (ex. Fixed the wrong callback method being called with the default form. Fixes issue #45)
```

#### Updating the readme

The readme file is the first and most read SDK documentation. It is of primary importance that the file is kept updated, readable and understandable.    
The readme always contains the latest changes, so it must be updated after the changelog.   

To update the readme:
1. Copy the latest changes from the changelog and mirror them in the readme.
2. Raise the recommended version provided in the example if necessary. The recommended version always specifies only the first two digits and use the optimistic operator `~>`.
3. If new and prominent features were added with the release, add a paragraph to the readme describing their functionalities. If the feature has a complicated use case or needs more documentation, introduce it briefly in the readme and point to the appropriate wiki page for further instruction.

#### Updating the wiki

The wiki contains all the documentation relative to the public functionalities of the SDK.    
Any new feature that cannot be fully explained in the readme file must be added to the wiki.


When adding a wiki page, always try to place it in the correct section of the wiki.

The wiki page for a feature must contain all details regarding the functionalities and limitations of the feature.
Expected input and output must be specified if necessary.

#### Updating the example project

The repository contains a working example project that implements the latest version of the SDK.

If changes were made to the public interface of the SDK, this project must be updated to reflect them.

### Internal Release

#### Increase the SDK version

The SDK version must be increased in the General tab of the Usabilla project.

In order to do this, you must follow these steps:
1. Open a branch from **develop** called **`release/vX.Y.Z`**.
2. Change the project file according to what stated above. Do not perform any other change.
3. Merge the branch in **develop** with `vX.Y.Z` as commit message

#### Update the master branch

To update the **master** branch, open a PR from **develop** to **master**.    
This PR should not contain anything more than all the changes included in the release.    
Once the PR is accepted, the last commit on **master** should be `vX.Y.Z`.    

In the [release page of Github](https://github.com/usabilla/usabilla-u4a-ios-swift/releases):

1. Select `Draft a new release`.
2. Select the latest commit on **master** and name the release `vX.Y.Z`.
3. Publish the new release.

### External Release

#### Build the frameworks
Before building the frameworks, make sure you are on the correct branch (**master**) of the development repository.

Make sure to delete the old framework from the public repository folder before building the new one.

##### Manually
The framework is built using a script saved in the main folder of the repository.
To build the form:
1. Open the build phases of the project
2. Add a new Run Script phase at the end of the existing ones.
3. Open the new phase and copy paste the content of the `DirectRelease.txt` file into it.
4. Set the target build configuration to `Release`
5. Clean the project with `Shift + command + k` and `Shift + control + command + k`
6. Build the project.

This will produce a framework file ready to be released.
The new file will be copied into a folder called `generatedFramework` and a new window will be open on that folder.
To make sure the framework has been correctly built, run `pod lib lint --verbose`


If no error arises, the Carthage framework can be built:
1. Open a terminal in the private repository and run `carthage build --no-skip-current --platform iOS`
2. Once the previous command is done, run `carthage archive Usabilla`

This will create a Usabilla.zip containing the framework for Carthage.

Now, **Rename** (`Usabilla.zip`) to `Carthage.framework.zip`


At this point remember to:
1. Delete the Run Script phase added Before
2. Reset the project configuration to `Debug`

##### Semi-Automatically
The framework is built using Fastlane.

There are two ways of building the framework:

- All required Xcode versions at once (see fastlane/versions.json): 
    - `fastlane buildAll`
- A specific Xxcode version
    - `fastlane buildSdk version:X.X` where X.X is the xcode version you are using

Here are the steps taken by this script:
- Build Framework using Xcode
- Remove old Carthage symbols and framework
- Build Framework with Carthage
- Archive Carthage Framework
- Remove old release directory
- Create Release Directory name Xcode-X.X.X
- Copy Framework ans Symbols to Release Directory
- Copy Carthage framework to Release Directory
- Clean project folder from temporary created files

This will produce the library files ready to be released:
- Xcode-X.X/Pods/Usabilla.framework
- Xcode-X.X/Pods/Usabilla.DSYM
- Xcode-X.X/Carthage/Carthage.Framework.zip

Now, copy the `Usabilla.framework` and `Usabilla.DSYM` files in the public repository folder

#### Update the public master branch

At this point, all files should have been updated correctly.
Commit all changes with `release vX.Y.Z` as commit message and push the branch to the remote and rebase all changes on **master**.

#### Create a release on Github

In the [release page of Github](https://github.com/usabilla/usabilla-u4a-android-sdk/releases):

1. Select `Draft a new release`.
2. Select the latest tag on **master**
3. Copy the changelog section relative to this release in the release notes.
4. Upload the Carthage zip archive `Carthage.framework.zip`
5. Publish the new release.


#### Publish the SDK on Cocoapods

To publish the SDK on CocoaPods, run:

1. `pod spec lint --verbose`.
2. If no error arises, run `pod trunk push Usabilla.podspec` and the SDK will be published on CocoaPods.
