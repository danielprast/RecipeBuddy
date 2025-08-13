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
  dependencies: [
    .package(
      url: "https://github.com/danielprast/BezetQit.git",
      from: Version("1.0.0")
    )
  ],
  targets: [
    .target(
      name: "RebudData",
      dependencies: [
        .product(
          name: "BZConnectionChecker",
          package: "BezetQit"
        ),
        .product(
          name: "BZUtil",
          package: "BezetQit"
        )
      ],
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
