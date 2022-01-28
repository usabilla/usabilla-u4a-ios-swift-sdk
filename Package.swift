// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.11.0-Xcode-11.7"
let checksum = "32de259907ed03457729afbb588b03919c6ac2aff1db7b7a36c56de1cee7f840"
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
