// swift-tools-version: 5.6

// DO NOT MODIFY
// Automatically generated by Arkana (https://github.com/rogerluan/arkana)

import PackageDescription

let package = Package(
    name: "ArkanaKeysInterfaces",
    platforms: [
        .macOS(.v11),
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ArkanaKeysInterfaces",
            targets: ["ArkanaKeysInterfaces"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ArkanaKeysInterfaces",
            dependencies: [],
            path: "Sources"
        ),
    ]
)
