#if canImport(XCTest) && os(iOS)
import XCTest

public extension XCUIApplication {
    /// Removes an app with a specific name from the simulator.
    func uninstallApplication(_ name: String, file: StaticString = #filePath, line: UInt = #line) throws {
        let app = otherElements["Home screen icons"].icons[name]
        
        guard app.exists else {
            return
        }
        
        if !app.isHittable {
            try swipeToIcon(app)
        }
        
        app.press(forDuration: 2.0)
        
        let removeApp = buttons["Remove App"]
        guard removeApp.waitForExistence(timeout: 5.0) else {
            return XCTFail("'Remove App' does not exist.", file: file, line: line)
        }
        
        removeApp.tap()
        
        let deleteApp = buttons["Delete App"]
        guard deleteApp.waitForExistence(timeout: 5.0) else {
            return XCTFail("'Delete App' does not exist.", file: file, line: line)
        }
        
        deleteApp.tap()
        
        let delete = buttons["Delete"]
        guard delete.waitForExistence(timeout: 5.0) else {
            return XCTFail("'Delete' does not exist.", file: file, line: line)
        }
        
        delete.tap()
        
        XCUIDevice.shared.press(.home)
    }
    
    /// Attempt to locate a springboard icon.
    func swipeToIcon(_ element: XCUIElement, limit: Int = 3) throws {
        struct SwipeLimitReached: Error {}
        
        // Navigate to the first page (two taps in the case of being on the 'App Library' screen.
        XCUIDevice.shared.press(.home)
        XCUIDevice.shared.press(.home)
        
        var swipe = 0
        while !element.isHittable && swipe < limit {
            swipeLeft()
            swipe += 1
        }
        
        if swipe == limit {
            throw SwipeLimitReached()
        }
    }
}
#endif
