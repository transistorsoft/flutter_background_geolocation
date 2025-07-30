// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_background_geolocation",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(
            name: "flutter-background-geolocation",
            targets: ["flutter_background_geolocation"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.5")
    ],
    targets: [
        .target(
            name: "flutter_background_geolocation",
            dependencies: ["TSLocationManager", "CocoaLumberjack"],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/flutter_background_geolocation")
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3"),
                .linkedLibrary("stdc++")
            ]
        ),
        .binaryTarget(
            name: "TSLocationManager",
            path: "Frameworks/TSLocationManager.xcframework"
        )
    ]
)
