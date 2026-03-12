// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "Calculator",
            targets: ["Calculator"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Calculator",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Calculator"],
            path: "Tests"),
    ]
)
