// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "wgpu",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15"),
    ],
    products: [
        .library(name: "wgpu", type: .dynamic, targets: ["wgpu"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "wgpu",
            dependencies: [
                .target(name: "wgpu_shared"),
            ]
        ),
        .target(
            name: "wgpu_shared",
            path: "Sources/wgpu_shared",
            packageAccess: true
        )
    ]
)
