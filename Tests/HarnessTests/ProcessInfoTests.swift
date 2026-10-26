@testable import Harness
import XCTest

final class ProcessInfoTests: XCTestCase {

    func testTargetChecks() {
        XCTAssertTrue(ProcessInfo.processInfo.isTargetTest)
    }
}
