// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SLLog",
    products: [
        .library(
            name: "SLLog",
            targets: ["SLLog"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SLLog",
            dependencies: []),
        .testTarget(
            name: "SLLogTests",
            dependencies: ["SLLog"]),
    ]
)
