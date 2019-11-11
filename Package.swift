// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MCxPrint",
    platforms: [
        // specify each minimum deployment requirement, 
        // otherwise the platform default minimum is used.
        SupportedPlatform.macOS(SupportedPlatform.MacOSVersion.v10_13),
        SupportedPlatform.iOS(SupportedPlatform.IOSVersion.v12),
    ],
    products: [
        // Products define the executables and libraries produced by a package, 
        // and make them visible to other packages.
        Product.executable(
            name: "MCxPrintExec", 
            targets: ["MCxPrintCLI"]),
        Product.library(
            name: "MCxPrintLib",
            type: Product.Library.LibraryType.static,
            targets: ["MCxPrintCore"]),
    ],
    dependencies: [
        // .package( url: " ", from: "1.0.0" )
        // .package( url: " ", .branch("master") )
    ],
    targets: [
        Target.target(
            name: "MCxPrintCore",
            dependencies: []
        ),
        Target.target(
            name: "MCxPrintCLI",
            dependencies: ["MCxPrintCore"]
        ),
        Target.testTarget(
            name: "MCxPrintTests",
            dependencies: ["MCxPrintCore"]
        ),
    ],
    swiftLanguageVersions: [SwiftVersion.v5]
)
