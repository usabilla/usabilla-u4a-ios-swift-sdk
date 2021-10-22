# Swift Package Manager for Usabilla

## Introduction

Starting with the 6.5.0 release, Usabilla supports installation via [Swift
Package Manager](https://swift.org/package-manager/).


## Limitations

- Requires Xcode 12.
- iOS support is only available.

## Installation

If you've previously used CocoaPods, remove them from the project with `pod deintegrate`.

### In Xcode

Install Usabilla via Swift Package Manager:

<img width="720" alt="Install" src="https://user-images.githubusercontent.com/42991157/94566222-64735100-026a-11eb-9471-b95a52f2a68b.png">

Select the Usabilla GitHub repository - `https://github.com/usabilla/usabilla-u4a-ios-swift-sdk.git`:

<img width="720" alt="Select Repository" src="https://user-images.githubusercontent.com/42991157/94566514-b61bdb80-026a-11eb-8610-a38ef3a79e8a.png">

Select the version.

Note: Starting with the 6.5.0 release.

<img width="720" alt="Select Version" src="https://user-images.githubusercontent.com/42991157/94566638-dcda1200-026a-11eb-80ee-42e2f97f700a.png">

Choose the Usabilla product to be installed in your app.

<img width="720" alt="Select Usabilla" src="https://user-images.githubusercontent.com/42991157/94566811-14e15500-026b-11eb-8e42-00bd648f2623.png">

### Alternatively, add Usabilla to a `Package.swift` manifest

To integrate via a `Package.swift` manifest instead of Xcode, you can add
Usabilla to your dependencies array of your package with:

```
dependencies: [
  .package(name: "Usabilla",
           url: "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk.git",
           from: "X.Y.Z")
],
```

Then in any target that depends on a Usabilla product, add it to the `dependencies`
array of that target:

```
.target(
    name: "YourProjectTarget",
    dependencies: [
      .product(name: "Usabilla", package: "Usabilla"),
    ]
),
```
