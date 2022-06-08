import XCTest
@testable import Harness

final class EnvironmentConfigurationTests: XCTestCase {
    
    struct TestConfiguration: EnvironmentConfiguration {
        static let environmentKey: String = "mock_config"
        
        let userName: String
        let userId: Int
    }
    
    func testMake() throws {
        var environment: [String: String] = ["some_config": "{\"userName\":\"Bob\",\"userId\":\"42\"}"]
        var config: TestConfiguration?
        
        config = try? TestConfiguration.make(from: environment)
        XCTAssertNil(config, "Unexpectedly found configuration for non-matching key")
        
        environment = ["mock_config": "{\"userName\":\"Bob\",\"userId\":\"42\"}"]
        
        config = try? TestConfiguration.make(from: environment)
        XCTAssertNil(config, "Unexpectedly decoded configuration for invalid data type")
        
        environment = ["mock_config": "{\"userName\":\"Bob\",\"userId\":42}"]
        config = try? TestConfiguration.make(from: environment)
        
        let testConfiguration = try XCTUnwrap(config)
        XCTAssertEqual(testConfiguration.userName, "Bob")
        XCTAssertEqual(testConfiguration.userId, 42)
        
        XCTAssertNoThrow(try TestConfiguration.make(from: environment))
    }
    
    func testEnvironmentVariables() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        var config: TestConfiguration? = nil
        var environment: [String: String] = TestConfiguration.environmentVariables(forConfiguration: config)
        
        XCTAssertTrue(environment.isEmpty)
        
        config = TestConfiguration(userName: "Paul", userId: 179)
        environment = TestConfiguration.environmentVariables(forConfiguration: config, encoder: encoder)
        
        XCTAssertTrue(environment.keys.contains("mock_config"))
        let json = try XCTUnwrap(environment["mock_config"])
        
        XCTAssertEqual(json, "{\"userId\":179,\"userName\":\"Paul\"}")
    }
    
    func testUnescapedJSON() throws {
        let config = TestConfiguration(userName: "Marty", userId: 88)
        XCTAssertEqual(config.unescapedJSON, """
        {"userId":88,"userName":"Marty"}
        """)
    }
}
