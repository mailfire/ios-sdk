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
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        //.binaryTarget(name: "Mailfire", path: "./Sources/Mailfire.xcframework")
        .binaryTarget(name: "Mailfire", url: "https://github.com/mailfire/ios-sdk/blob/master/Mailfire.xcframework.zip", checksum: "2aa5eef4baacadae0c1083db997b55429dad789e3163432769128b11503f01ca")
    ]
)
