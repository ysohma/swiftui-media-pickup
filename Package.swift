// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaPickup",
    platforms: [
        .iOS(.v16)
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MediaPickup",
            path: "Sources/Lib"),
        .executableTarget(
            name: "MediaPickupDemo",
           dependencies: ["MediaPickup"],path: "Sources/App"),
    ]
)
