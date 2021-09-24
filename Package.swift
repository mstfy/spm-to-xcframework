// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "spm-to-xcframework",
    products: [
        .executable(name: "spm-to-xcframework", targets: ["spm-to-xcframework"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.3")
    ],
    targets: [
        .executableTarget(
            name: "spm-to-xcframework",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "spm-to-xcframework-tests",
            dependencies: [
                "spm-to-xcframework"
            ]
        )
    ]
)
