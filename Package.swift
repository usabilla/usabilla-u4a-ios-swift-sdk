// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.9.0-Xcode-13.1"
let checksum = "ad32fe6c2adc367155a58eaea62a75ea41fbf652fe676bdb52a4beec30e314ac"
let url = "https://github.com/usabilla/usabilla-u4a-ios-swift-sdk/releases/download/v\(version)/UsabillaXCFramework.zip"

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
