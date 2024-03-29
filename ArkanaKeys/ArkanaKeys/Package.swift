// swift-tools-version: 5.6

// DO NOT MODIFY
// Automatically generated by Arkana (https://github.com/rogerluan/arkana)

import PackageDescription

let package = Package(
    name: "ArkanaKeys",
    platforms: [
        .macOS(.v11),
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ArkanaKeys",
            targets: ["ArkanaKeys"]
        ),
    ],
    dependencies: [
        .package(name: "ArkanaKeysInterfaces", path: "../ArkanaKeysInterfaces"),
    ],
    targets: [
        .target(
            name: "ArkanaKeys",
            dependencies: ["ArkanaKeysInterfaces"],
            path: "Sources"
        ),
        .testTarget(
            name: "ArkanaKeysTests",
            dependencies: ["ArkanaKeys"],
            path: "Tests"
        ),
    ]
)
