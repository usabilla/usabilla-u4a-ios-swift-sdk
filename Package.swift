// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.8.0"
let checksum = "57a787afb66a5e04842b7d9e79f9f4bef7f4d572cb573186f3636a3296e0dbce"
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
