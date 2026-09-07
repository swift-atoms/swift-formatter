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
        .library(name: "Formatter", targets: ["Formatter"]),
        .library(name: "Formatter Standard Library Integration", targets: ["Formatter Standard Library Integration"]),
        .library(name: "Formatter Foundation Library Integration", targets: ["Formatter Foundation Library Integration"]),
        .library(name: "Formatter Test Support", targets: ["Formatter Test Support"]),
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
            dependencies: [
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair", package: "swift-pair"),
            ],
            path: "Sources/Formatter"
        ),
        .target(
            name: "Formatter Standard Library Integration",
            dependencies: [
                .target(name: "Formatter"),
            ],
            path: "Sources/Formatter Standard Library Integration"
        ),
        .target(
            name: "Formatter Foundation Library Integration",
            dependencies: [
                .target(name: "Formatter"),
                .target(name: "Formatter Standard Library Integration"),
            ],
            path: "Sources/Formatter Foundation Library Integration"
        ),
        .target(
            name: "Formatter Test Support",
            dependencies: [
                .target(name: "Formatter"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Formatter Tests",
            dependencies: [
                .target(name: "Formatter"),
                .target(name: "Formatter Test Support"),
                .target(name: "Formatter Standard Library Integration"),
                .target(name: "Formatter Foundation Library Integration"),
            ],
            path: "Tests/Formatter Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
