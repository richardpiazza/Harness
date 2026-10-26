#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
@testable import Harness
import Testing

struct EnvironmentConfigurationTests {

    struct TestConfiguration: EnvironmentConfiguration {
        static let environmentKey: String = "mock_config"

        let userName: String
        let userId: Int
    }

    @Test func testMake() throws {
        var environment: [String: String] = ["some_config": "{\"userName\":\"Bob\",\"userId\":\"42\"}"]
        var config: TestConfiguration?

        config = try? TestConfiguration.make(from: environment)
        #expect(config == nil, "Unexpectedly found configuration for non-matching key")

        environment = ["mock_config": "{\"userName\":\"Bob\",\"userId\":\"42\"}"]

        config = try? TestConfiguration.make(from: environment)
        #expect(config == nil, "Unexpectedly decoded configuration for invalid data type")

        environment = ["mock_config": "{\"userName\":\"Bob\",\"userId\":42}"]
        config = try? TestConfiguration.make(from: environment)

        let testConfiguration = try #require(config)
        #expect(testConfiguration.userName == "Bob")
        #expect(testConfiguration.userId == 42)

        _ = try TestConfiguration.make(from: environment)
    }

    @Test func testEnvironmentVariables() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        var config: TestConfiguration?
        var environment: [String: String] = TestConfiguration.environmentVariables(forConfiguration: config)

        #expect(environment.isEmpty)

        config = TestConfiguration(userName: "Paul", userId: 179)
        environment = TestConfiguration.environmentVariables(forConfiguration: config, encoder: encoder)

        #expect(environment.keys.contains("mock_config"))
        let json = try #require(environment["mock_config"])

        #expect(json == "{\"userId\":179,\"userName\":\"Paul\"}")
    }

    @Test func testUnescapedJSON() {
        let config = TestConfiguration(userName: "Marty", userId: 88)
        #expect(config.unescapedJSON == """
        {"userId":88,"userName":"Marty"}
        """)
    }
}
