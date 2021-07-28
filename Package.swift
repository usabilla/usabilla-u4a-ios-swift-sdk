// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.8.3"
let checksum = "55df91725724b5f0b5eafd57e2ac627506be231c9cac85fa691dad8a3466b2ef"
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
