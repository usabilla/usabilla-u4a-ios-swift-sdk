// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.12.3-Xcode-14.0"
let checksum = "d3c895ccbefd8e8724321b83cd6778d6650455cd137b28940d8ef4e2a9fae5f2"
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
