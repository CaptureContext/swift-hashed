// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "swift-hashed",
	products: [
		.library(
			name: "Hashed",
			targets: ["Hashed"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/swift-equated.git",
			.upToNextMinor(from: "0.0.2")
		),
	],
	targets: [
		.target(
			name: "Hashed",
			dependencies: [
				.product(
					name: "Equated",
					package: "swift-equated"
				),
			]
		),
		.testTarget(
			name: "HashedTests",
			dependencies: ["Hashed"]
		),
	]
)
