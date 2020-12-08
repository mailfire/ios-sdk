// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mailfire",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Mailfire",
            targets: ["Mailfire"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets  can depend on other targets in this package, and on products in packages this package depends on.
        //.binaryTarget(name: "Mailfire", path: "./Sources/Mailfire.xcframework")
        .binaryTarget(name: "Mailfire", url: "https://github.com/mailfire/ios-sdk/blob/master/Mailfire.xcframework.zip", checksum: "640cb306ad15f8cd3d27b0d6428fc7561645000080bf07e8d0e168371cf1ab65")
    ]
)
