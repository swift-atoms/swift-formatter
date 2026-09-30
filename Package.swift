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
        .library(name: "Bit Formatter Test Support", targets: ["Bit Formatter Test Support"]),

        .library(name: "Formatter", targets: ["Formatter"]),

        .library(name: "Formatter Foundation Integration", targets: ["Formatter Foundation Integration"]),
        .library(name: "Formatter Test Support", targets: ["Formatter Test Support"]),
        .library(name: "Binary Formatter Test Support", targets: ["Binary Formatter Test Support"]),
        .library(name: "Byte Formatter Test Support", targets: ["Byte Formatter Test Support"]),
        .library(name: "Radix Formatter Test Support", targets: ["Radix Formatter Test Support"]),
    ],
    traits: [
        .trait(name: "Time", description: "Time integration", enabledTraits: ["Number"]),

        .trait(name: "Number", description: "Number integration"),

        .trait(name: "BitPattern", description: "BitPattern integration"),

        .trait(name: "Tagged", description: "Formatting tagged floating-point values"),
        .trait(name: "Binary", description: "Absorbed Binary integration", enabledTraits: ["Byte"]),
        .trait(name: "Byte", description: "Absorbed Byte integration", enabledTraits: ["Radix", "Conversions"]),
        .trait(name: "Conversions", description: "Absorbed Conversions integration"),
        .trait(name: "Radix", description: "Absorbed Radix integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-text.git", branch: "main", traits: [.trait(name: "Casing", condition: .when(traits: ["Conversions", "Binary", "Byte"]))]),

        .package(url: "https://github.com/swift-atoms/swift-bit-pattern.git", branch: "main"),

        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-binary.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-radix.git", branch: "main"),
    ],
    targets: [
        .testTarget(name: "Decision Time Format Tests", dependencies: [.target(name: "Formatter")], path: "Tests/Decision Time Format Tests"),

        .testTarget(name: "Decision Text Casing Tests", dependencies: [.target(name: "Formatter"), .product(name: "Text", package: "swift-text")], path: "Tests/Decision Text Casing Tests"),

        .testTarget(name: "Decision Format Tagged Tests", dependencies: [.target(name: "Formatter"), .product(name: "Tagged", package: "swift-tagged")], path: "Tests/Decision Format Tagged Tests"),

        .target(name: "Bit Formatter Test Support", dependencies: [.target(name: "Formatter")], path: "Tests/Decision Bit Formatter Support"),

        .testTarget(name: "Decision Bit Formatter Tests", dependencies: [.target(name: "Formatter"), .product(name: "Bit Pattern", package: "swift-bit-pattern")], path: "Tests/Decision Bit Formatter Tests"),

        .target(
            name: "Formatter",
            dependencies: [
                .product(name: "Bit Pattern", package: "swift-bit-pattern"),

                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Binary", package: "swift-binary"),
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Radix", package: "swift-radix"),
    ],
            path: "Sources/Formatter"
        ),

        .target(
            name: "Formatter Foundation Integration",
            dependencies: [
                .target(name: "Formatter"),
            ],
            path: "Sources/Formatter Foundation Integration"
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
                .target(name: "Formatter Foundation Integration"),
            ],
            path: "Tests/Formatter Tests"
        ),
        .testTarget(name: "Absorbed swift-binary-formatter Binary Formatter Tests", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-binary-formatter/Binary Formatter Tests"),
        .target(name: "Binary Formatter Test Support", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-binary-formatter/Support"),
        .testTarget(name: "Absorbed swift-byte-formatter Byte Formatter Tests", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-byte-formatter/Byte Formatter Tests"),
        .target(name: "Byte Formatter Test Support", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-byte-formatter/Support"),
        .testTarget(name: "Absorbed swift-radix-formatter Radix Formatter Tests", dependencies: [.target(name: "Formatter"), .target(name: "Radix Formatter Test Support")], path: "Tests/Absorbed/swift-radix-formatter/Radix Formatter Tests"),
        .target(name: "Radix Formatter Test Support", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-radix-formatter/Support"),
        .testTarget(name: "Absorbed swift-format-formatter Format Formatter Tests", dependencies: [.target(name: "Formatter")], path: "Tests/Absorbed/swift-format-formatter/Format Formatter Tests"),
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
