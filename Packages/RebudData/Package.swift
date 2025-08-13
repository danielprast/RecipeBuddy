// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "RebudData",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "RebudData",
      targets: ["RebudData"]
    ),
  ],
  targets: [
    .target(
      name: "RebudData",
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "RebudDataTests",
      dependencies: ["RebudData"]
    ),
  ]
)
