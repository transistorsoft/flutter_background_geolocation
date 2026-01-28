// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "flutter_background_geolocation",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "flutter-background-geolocation",
            targets: ["flutter_background_geolocation"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.5"),
        .package(url: "https://github.com/transistorsoft/native-background-geolocation.git", from: "4.0.10"),
        .package(url: "https://github.com/transistorsoft/transistor-background-fetch.git", from: "4.0.5")
    ],
    targets: [
        .target(
            name: "flutter_background_geolocation",
            dependencies: [
                .product(name: "TSLocationManager", package: "native-background-geolocation"),
                .product(name: "TSBackgroundFetch", package: "transistor-background-fetch"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            cSettings: [
                .headerSearchPath("include/flutter_background_geolocation")
            ],
            linkerSettings: [
                .linkedLibrary("z"),
                .linkedLibrary("sqlite3")
                // .linkedLibrary("c++")  // only if you truly need it
            ]
        )
    ]
)
