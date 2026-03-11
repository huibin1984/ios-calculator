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
            targets: ["App", "Core", "Models", "ViewModels", "Views"])
    ],
    dependencies: [
        // SwiftUI built-in
    ],
    targets: [
        // App Target
        .target(
            name: "App",
            dependencies: ["Core", "Models", "ViewModels", "Views"],
            path: "Sources/App"),
        
        // Core (Business Logic)
        .target(
            name: "Core",
            dependencies: [],
            path: "Sources/Core"),
        
        // Models (Data Layer)
        .target(
            name: "Models",
            dependencies: ["Core"],
            path: "Sources/Models"),
        
        // ViewModels (Presentation Logic)
        .target(
            name: "ViewModels",
            dependencies: ["Core", "Models"],
            path: "Sources/ViewModels"),
        
        // Views (UI Layer)
        .target(
            name: "Views",
            dependencies: ["ViewModels"],
            path: "Sources/Views"),
        
        // Test Target
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Core", "Models"],
            path: "Tests"),
    ]
)
