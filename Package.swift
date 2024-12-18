// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftUIPageView",
    platforms: [.iOS(.v14), .watchOS(.v7), .macOS(.v11)],
    products: [.library(name: "SwiftUIPageView", targets: ["SwiftUIPageView"])],
    targets: [.target(name: "SwiftUIPageView")]
)
