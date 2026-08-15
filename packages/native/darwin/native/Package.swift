// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "native",
    platforms: [
        .iOS("13.0"),
        .macOS("10.15"),
    ],
    products: [
        .library(name: "native", targets: ["native"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "native",
            dependencies: [
                // Shared code
                .target(name: "native_darwin"),
                .target(name: "native_darwin_bindings"),

                // macOS specific code
                .target(name: "native_macos_bindings", condition: .when(platforms: [.macOS])),

                // iOS specific code
                .target(name: "native_ios_bindings", condition: .when(platforms: [.iOS]))
            ]
        ),
        .target(
            name: "native_darwin",
            path: "Sources/native_darwin"
        ),
        .target(
            name: "native_darwin_bindings",
            path: "Sources/native_darwin_bindings",
            publicHeadersPath: "."
        ),
        .target(
            name: "native_macos",
            path: "Sources/native_macos",
            packageAccess: true
        ),
        .target(
            name: "native_macos_bindings",
            path: "Sources/native_macos_bindings",
            publicHeadersPath: "."
        ),
        .target(
            name: "native_ios",
            path: "Sources/native_ios",
            packageAccess: true
        ),
        .target(
            name: "native_ios_bindings",
            path: "Sources/native_ios_bindings",
            publicHeadersPath: "."
        )
    ]
)
