// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MCxPrint",
    // products: [
    //     // Products define the executables and libraries produced by a package, and make them visible to other packages.
    //     .library(
    //         name: "MCxPrintCore",
    //         type: .static,
    //         targets: ["MCxPrintCore"]),
    // ],
    dependencies: [
        // .package( url: " ", from: "1.0.0" )
        // .package( url: " ", .branch("master") )
    ],
    targets: [
        .target(
            name: "MCxPrintCore",
            dependencies: []
        ),
        .target(
            name: "MCxPrint",
            dependencies: ["MCxPrintCore"]
        ),
        .testTarget(
            name: "MCxPrintTests",
            dependencies: ["MCxPrintCore"]
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
