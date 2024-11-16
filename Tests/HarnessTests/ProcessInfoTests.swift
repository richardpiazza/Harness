import XCTest
@testable import Harness

final class ProcessInfoTests: XCTestCase {
    
    func testTargetChecks() throws {
        XCTAssertTrue(ProcessInfo.processInfo.isTargetTest)
    }
}
