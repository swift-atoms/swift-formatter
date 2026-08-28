// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-formatter",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Formatter",
            targets: ["Formatter"]
        ),
        .library(
            name: "Formatter Protocol",
            targets: ["Formatter Protocol"]
        ),
        .library(
            name: "Formattable",
            targets: ["Formattable"]
        ),

        .library(
            name: "Format",
            targets: ["Format"]
        ),

        .library(
            name: "Formatter Pair",
            targets: ["Formatter Pair"]
        ),

    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Formatter",
            dependencies: []
        ),
        .target(
            name: "Formatter Protocol",
            dependencies: [
                .target(name: "Formatter")
            ]
        ),
        .target(
            name: "Formattable",
            dependencies: [
                .target(name: "Formatter Protocol")
            ]
        ),

        .target(
            name: "Format",
            dependencies: [
                .target(name: "Formatter Protocol")
            ]
        ),

        .target(
            name: "Formatter Pair",
            dependencies: [
                .target(name: "Formattable"),
                .target(name: "Formatter Protocol"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),

        .testTarget(
            name: "Formatter Tests",
            dependencies: [.target(name: "Formatter")]
        ),
        .testTarget(
            name: "Formatter Protocol Tests",
            dependencies: [.target(name: "Formatter Protocol")]
        ),
        .testTarget(
            name: "Formattable Tests",
            dependencies: [.target(name: "Formattable")]
        ),
        .testTarget(
            name: "Format Tests",
            dependencies: [.target(name: "Format")]
        ),
        .testTarget(
            name: "Formatter Pair Tests",
            dependencies: [
                .target(name: "Formatter Pair")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
