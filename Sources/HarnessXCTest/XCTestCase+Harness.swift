#if canImport(XCTest)
import XCTest

public extension XCTestCase {
    /// Waits for the specified amount of time to pass before continuing execution.
    ///
    /// This acts as a thread-safe replacement for using the `Darwin.sleep()` function.
    func delay(for timeout: TimeInterval) {
        _ = DispatchSemaphore(value: 0) .wait(timeout: .now() + timeout)
    }
}

#endif
