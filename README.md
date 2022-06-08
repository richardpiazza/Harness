# Harness

Swift toolkit for testing applications with the XCTest framework.

<p>
    <img src="https://github.com/richardpiazza/Harness/workflows/Swift/badge.svg?branch=main" />
</p>

## Usage

**Harness** is distributed using the [Swift Package Manager](https://swift.org/package-manager). To install it into a project, add it as a  dependency within 
your `Package.swift` manifest:

```swift
let package = Package(
    ...
    // Package Dependencies
    dependencies: [
        .package(url: "https://github.com/richardpiazza/Harness", .upToNextMinor(from: "0.1.0"))
    ],
    ...
    // Target Dependencies
    dependencies: [
        .product(name: "Harness", package: "Harness")
    ]
)
```

Then import the **Harness** packages wherever you'd like to use it:

```swift
import Harness
```

## Targets

### Harness

The **Harness** target includes tools that are common for creating testable environments.

* **EnvironmentConfiguration**: Protocol of any type that can express a service configuration via `JSON`.
* **DarwinBroadcaster**: A system-wide notification system available on Darwin (Apple) systems for simplistic inter-app communication.

### HarnessXCTest

The **HarnessXCTest** target contains extensions for working with the XCTest framework.
