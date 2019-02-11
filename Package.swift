// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "DrawTheJoker",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
       // .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
      //  .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0")
    ],
//    targets: [
//        .target(name: "App", dependencies: ["FluentSQLite", "Vapor"]),
//        .target(name: "Run", dependencies: ["App"]),
//        .testTarget(name: "AppTests", dependencies: ["App"])
//    ]
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                    ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
