// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Trinity",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "TrinityTokens", targets: ["TrinityTokens"]),
        .library(name: "TrinityTheme", targets: ["TrinityTheme"]),
        .library(name: "TrinityComponents", targets: ["TrinityComponents"])
    ],
    targets: [
        .target(name: "TrinityTokens"),
        .target(name: "TrinityTheme", dependencies: ["TrinityTokens"]),
        .target(name: "TrinityComponents", dependencies: ["TrinityTokens", "TrinityTheme"]),
        .testTarget(name: "TrinityTokensTests", dependencies: ["TrinityTokens"]),
        .testTarget(name: "TrinityThemeTests", dependencies: ["TrinityTheme"])
    ]
)
