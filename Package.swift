// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.8.3"
let checksum = "57e4624db1410a671f5c82f387288725531b2eaac3d68c1b9105b2728899b9cf"
let url = "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/blob/SP-xcode-6.8.3/UsabillaXCFramework.zip"

let package = Package(
    name: "Usabilla",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "Usabilla",
            targets: ["Usabilla"]),
    ],
    targets: [
        .binaryTarget(
            name: "Usabilla",
            url: url,
            checksum: checksum)
    ]
)
