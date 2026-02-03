# swift-hashed

[![CI](https://github.com/CaptureContext/swift-hashed/actions/workflows/ci.yml/badge.svg)](https://github.com/CaptureContext/swift-hashed/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-hashed%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/CaptureContext/swift-hashed) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCaptureContext%2Fswift-hashed%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CaptureContext/swift-hashed)

Hashable wrapper type and a set of explicit hashing strategies.

## Table of Contents

  - [Motivation](#motivation)
  - [Features](#features)
    - [Predefined comparators](#predefined-comparators)
  - [Installation](#installation)
    - [Basic](#basic)
    - [Recommended](#recommended)
  - [License](#license)

## Motivation

Swift strongly encourages `Hashable`, especially when working with collections, diffing, and identity-based logic.

In practice, however, hashing often becomes problematic at API boundaries:

- values erased to `any`
- reference types without stable identity
- types you don’t own
- generic code that cannot add `Hashable` constraints
- contexts where different hashing strategies are required

This is especially visible when working with KeyPath-based APIs, where generic composition frequently destroys compile-time `Hashable` conformance.

## Features

`Hashed` is a lightweight `Hashable` container that lets you define equality explicitly, while keeping call sites terse.

### Predefined hashers

Choose how two values should be compared using a `Hashed.Hasher`:

#### Automatic

The `detectHashable` comparator attempts to cast values to `any Hashable` and compare them using native `hash(into hasher: inout Swift.Hasher)` method:

```swift
.detectHashable(fallback: Hasher = .dump)
```

If hashable cast is not possible, the provided `fallback` hasher is used.

#### Building blocks

- `.empty` – nothing is combined into `Swift.Hasher``
- `.custom((Value, inout Swift.Hasher) -> Void)` – full control
- `.dump` – hashes the textual `dump()` output

#### Hashable-driven

- `.defaultHashable` – equivalent to using native `hash(into hasher: Swift.Hasher)` method

#### Property-based

The `property` hashable hashes values by a derived hashable projection:

```swift
.property(\.someHashableProperty)
.property { String(reflecting: $0) }
```

- `.objectID` – hash reference identity (only when `Value: AnyObject`)

#### Error convenience

The `.localizedDescription` hasher is equivalent to `.property(\.localizedDescription)`.

It is typically most useful as a fallback, for example:

```swift
.detectHashable(fallback: .localizedDescription)
```

#### Concurrency escape hatches

- `.uncheckedSendable((Value) -> any Hashable)`

  _A `property`-style comparator for non-sendable projections_

- `.uncheckedSendable((Value, inout Swift.Hasher) -> Void)`

  _A `custom`-style comparator for non-sendable values_

> [!NOTE]
>
> _Most users should prefer `.detectHashable()` or `.property`_ hashers

## Installation

### Basic

You can add Hashed to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-hashed"`](https://github.com/capturecontext/swift-hashed) into the package repository URL text field
3. Choose products you need to link them to your project.

### Recommended

If you use SwiftPM for your project structure, add Hashed to your package file.

```swift
.package(
  url: "https://github.com/capturecontext/swift-hashed.git",
  .upToNextMinor(from: "0.0.1")
)
```

or via HTTPS

```swift
.package(
  url: "https://github.com/capturecontext/swift-hashed.git",
  .upToNextMinor("0.0.1")
)
```

Do not forget about target dependencies:

```swift
.product(
  name: "Hashed",
  package: "swift-hashed"
)
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
