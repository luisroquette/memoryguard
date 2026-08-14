// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MemoryGuard",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "MemoryGuardCore", targets: ["MemoryGuardCore"]),
        .executable(name: "MemoryGuard", targets: ["MemoryGuard"]),
    ],
    targets: [
        .target(name: "MemoryGuardCore"),
        .executableTarget(
            name: "MemoryGuard",
            dependencies: ["MemoryGuardCore"]
        ),
        .testTarget(
            name: "MemoryGuardCoreTests",
            dependencies: ["MemoryGuardCore"]
        ),
        .testTarget(
            name: "MemoryGuardTests",
            dependencies: ["MemoryGuard"]
        ),
    ]
)
