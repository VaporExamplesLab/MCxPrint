// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MCxPrintLabel",
    // products: [
    //     // Products define the executables and libraries produced by a package, and make them visible to other packages.
    //     .library(
    //         name: "MCxPrintLabelCore",
    //         type: .static,
    //         targets: ["MCxPrintLabelCore"]),
    // ],
    dependencies: [
        // .package( url: " ", from: "1.0.0" )
        .package( url: "git@gitlab.com.mepixtech:swift-lab/MCx/MCxLogger.git", .branch("master") )
    ],
    targets: [
        .target(
            name: "MCxPrintLabelCore",
            dependencies: ["MCxLogger"]
        ),
        .target(
            name: "MCxPrintLabel",
            dependencies: ["MCxPrintLabelCore"]
        ),
        .testTarget(
            name: "MCxPrintLabelTests",
            dependencies: ["MCxPrintLabelCore", "MCxLogger"]
        ),
    ],
    swiftLanguageVersions: [.v4_2]
)
