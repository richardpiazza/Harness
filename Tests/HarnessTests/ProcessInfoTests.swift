#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
@testable import Harness
import Testing

struct ProcessInfoTests {

    let processInfo = ProcessInfo.processInfo

    @Test func testTargetChecks() {
        #expect(processInfo.isTargetTest)
        print(processInfo.environment)
        print(processInfo.arguments)
    }
}
