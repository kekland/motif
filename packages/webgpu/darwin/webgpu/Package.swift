// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "webgpu",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15"),
    ],
    products: [
        .library(name: "webgpu", type: .dynamic, targets: ["webgpu"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "webgpu",
            dependencies: [
                .target(name: "webgpu_shared"),
            ]
        ),
        .target(
            name: "webgpu_shared",
            path: "Sources/webgpu_shared",
            packageAccess: true
        )
    ]
)
