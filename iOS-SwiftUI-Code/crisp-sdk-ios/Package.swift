// swift-tools-version:5.7
import PackageDescription

let package = Package(
  name: "Crisp",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "Crisp", targets: ["CrispTarget"]),
    .library(name: "CrispWebRTC", targets: ["CrispWebRTCTarget"])
  ],
  targets: [
    .target(
      name: "CrispTarget",
      dependencies: [
        .target(name: "Crisp")
      ]
    ),
    .target(
      name: "CrispWebRTCTarget",
      dependencies: [
        .target(name: "CrispWebRTC"),
        .target(name: "WebRTC")
      ]
    ),
    .binaryTarget(
      name: "Crisp",
      url: "https://github.com/crisp-im/crisp-sdk-ios/releases/download/2.6.0/Crisp_2.6.0.zip",
      checksum: "aca5fd52e08db4bd0de1a11a96eea061fe263d12f3f9fed81a38fd15cb26bb98"
    ),
    .binaryTarget(
      name: "CrispWebRTC",
      url: "https://github.com/crisp-im/crisp-sdk-ios/releases/download/2.6.0/CrispWebRTC_2.6.0.zip",
      checksum: "14097b69253daaeeaa4a2e55fad7e71e45e0e9e27b8554a0f2a7d812fefffa60"
    ),
    .binaryTarget(
      name: "WebRTC",
      url: "https://github.com/crisp-im/crisp-sdk-ios/releases/download/2.6.0/WebRTC_2.6.0.zip",
      checksum: "7c9214e39d1e6335b984aeb399aa2491218649aed30e7c96e18180ab8b5ff4fa"
    ),
  ]
)
