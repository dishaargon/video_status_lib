// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "MyLibrary",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
//        .library(
//            name: "mobile-ffmpeg-full-gpl",
//            targets: ["mobile-ffmpeg-full-gpl"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/tanersener/mobile-ffmpeg", from: "4.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "MyLibrary",
            dependencies: []),
//        .target(
//            name: "mobile-ffmpeg-full-gpl",
//            dependencies: []),
    ]
)

