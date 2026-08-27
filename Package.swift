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
            name: "Formatter Standard Library Integration",
            targets: ["Formatter Standard Library Integration"]
        ),
        .library(
            name: "Formatter Apple Foundation Integration",
            targets: ["Formatter Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Formatter",
            dependencies: []
        ),
        .target(
            name: "Formatter Standard Library Integration",
            dependencies: ["Formatter"]
        ),
        .target(
            name: "Formatter Apple Foundation Integration",
            dependencies: [
                "Formatter",
                "Formatter Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Formatter Tests",
            dependencies: ["Formatter"],
            path: "Tests/Formatter Tests"
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
