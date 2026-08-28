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
            name: "Formatter Primitive",
            targets: ["Formatter Primitive"]
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

        .library(
            name: "Formatter",
            targets: ["Formatter"]
        ),

        .library(
            name: "Formatter Test Support",
            targets: ["Formatter Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Formatter Primitive",
            dependencies: []
        ),
        .target(
            name: "Formatter Protocol",
            dependencies: [
                "Formatter Primitive"
            ]
        ),
        .target(
            name: "Formattable",
            dependencies: [
                "Formatter Protocol"
            ]
        ),

        .target(
            name: "Format",
            dependencies: [
                "Formatter Protocol"
            ]
        ),

        .target(
            name: "Formatter Pair",
            dependencies: [
                "Formattable",
                "Formatter Protocol",
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),

        .target(
            name: "Formatter",
            dependencies: [
                "Format",
                "Formattable",
                "Formatter Pair",
                "Formatter Primitive",
                "Formatter Protocol",
            ]
        ),

        .target(
            name: "Formatter Test Support",
            dependencies: [
                "Formatter"
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Formatter Pair Tests",
            dependencies: [
                "Formatter Test Support"
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
