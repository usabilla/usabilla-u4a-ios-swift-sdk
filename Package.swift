// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.8.3"
let checksum = "55b79beb528800c74d4b03851c5441f1c7df324c5c6a359872bcb6bdb84fba78"
let url = "https://raw.githubusercontent.com/usabilla/usabilla-u4a-ios-swift-sdk/SP-xcode-6.8.3/UsabillaXCFramework.zip"
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
