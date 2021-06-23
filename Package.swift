// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.8.2"
let checksum = "d3e5ac0a74a178796f94dfe171d26d6d2dea76b342de7432bd765820a51276fe"
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
