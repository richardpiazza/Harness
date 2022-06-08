#if canImport(XCTest) && canImport(UIKit)
import XCTest
import UIKit

public extension XCUIElement {
    /// Asserts that an element matches the conditions **exists**, **isEnabled**, and **isHittable**.
    var isVisible: Bool {
        return exists && isEnabled && isHittable
    }
    
    /// Waits for the existence of an element.
    ///
    /// If the check fails, an `XCTFail` assertion will be made.
    ///
    /// - parameters:
    ///   - timeout: Amount of time to wait for the elements `exist` property to become **true**.
    ///   - message: An optional description of the assertion, for inclusion in test results.
    ///   - file: The file where the originating assertion occurs. (This is provided automagically)
    ///   - line: The line where the originating assertion occurs. (This is provided automagically)
    func waitForExistence(timeout: TimeInterval = 5.0, message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        if !waitForExistence(timeout: timeout) {
            XCTFail(message, file: file, line: line)
        }
    }
    
    /// Confirms the elements existence and then _taps_ it a specified number of times.
    ///
    /// - parameters:
    ///   - timeout: Amount of time to wait for the elements `exist` property to become **true**.
    ///   - numberOfTaps: The number of taps.
    ///   - numberOfTouches: The number of touch points.
    ///   - message: An optional description of the assertion, for inclusion in test results.
    ///   - file: The file where the originating assertion occurs. (This is provided automagically)
    ///   - line: The line where the originating assertion occurs. (This is provided automagically)
    func tapAfterExistence(timeout: TimeInterval = 5.0, numberOfTaps: Int = 1, numberOfTouches: Int = 1, message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        waitForExistence(timeout: timeout, message: message, file: file, line: line)
        tap(withNumberOfTaps: numberOfTaps, numberOfTouches: numberOfTouches)
    }
    
    /// Confirms the elements existence and then _long-presses_ it for a specified amount of time.
    ///
    /// - parameters:
    ///   - timeout: Amount of time to wait for the elements `exist` property to become **true**.
    ///   - duration: The amount of time to hold the press.
    ///   - message: An optional description of the assertion, for inclusion in test results.
    ///   - file: The file where the originating assertion occurs. (This is provided automagically)
    ///   - line: The line where the originating assertion occurs. (This is provided automagically)
    func longPressAfterExistence(timeout: TimeInterval = 5.0, duration: TimeInterval = 1.0, message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        waitForExistence(timeout: timeout, message: message, file: file, line: line)
        press(forDuration: duration)
    }
    
    /// Activates the element with a _tap_ then types the specified text.
    ///
    /// - parameters:
    ///   - text: Value to be entered.
    ///   - message: An optional description of the assertion, for inclusion in test results.
    ///   - file: The file where the originating assertion occurs. (This is provided automagically)
    ///   - line: The line where the originating assertion occurs. (This is provided automagically)
    func enterText(_ text: String, message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        tapAfterExistence(message: message, file: file, line: line)
        typeText(text)
    }

    /// Activates the element with a _long press_ then uses the **Paste** menu item.
    ///
    /// - parameters:
    ///   - text: Value to be pasted.
    ///   - application: The `XCUIApplication` reference required for `menuItem` query.
    ///   - message: An optional description of the assertion, for inclusion in test results.
    ///   - file: The file where the originating assertion occurs. (This is provided automagically)
    ///   - line: The line where the originating assertion occurs. (This is provided automagically)
    func pasteText(_ text: String, application: XCUIApplication, message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        UIPasteboard.general.string = text
        longPressAfterExistence(message: message, file: file, line: line)
        let paste = application.menuItems["Paste"]
        paste.tapAfterExistence(message: message, file: file, line: line)
    }
}
#endif
