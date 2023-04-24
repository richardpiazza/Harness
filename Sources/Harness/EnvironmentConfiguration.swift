import Foundation

/// A service configuration that can be expressed via JSON.
public protocol EnvironmentConfiguration: Codable {
    /// The ENVIRONMENT key used for the configuration.
    static var environmentKey: String { get }
}

internal struct EnvironmentKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

public extension EnvironmentConfiguration {
    /// Constructs a an instance of a `EnvironmentConfiguration` from the provided environment dictionary.
    ///
    /// The environment variables in a swift application are typically accessed via `ProcessInfo.processInfo.environment`.
    ///
    /// - throws: `DecodingError`
    /// - parameters:
    ///   - environment: A _Key-Value_ dictionary that contains the configuration.
    ///   - decoder: The `JSONDecoder` used for decoding the environment data.
    /// - returns: The configuration, when decoded successfully.
    static func make(from environment: [String: String], decoder: JSONDecoder = .init()) throws -> Self {
        guard let json = environment[environmentKey] else {
            let key = EnvironmentKey(stringValue: environmentKey)
            let context = DecodingError.Context(codingPath: [key], debugDescription: "An environment key was not found in the provided dictionary.")
            throw DecodingError.keyNotFound(key, context)
        }
        
        let data = json.data(using: .utf8) ?? Data()
        
        return try decoder.decode(Self.self, from: data)
    }
    
    /// Constructs a _Key-Value_ dictionary for a given configuration.
    ///
    /// - parameters:
    ///   - config: The `EnvironmentConfiguration` which needs encoding.
    ///   - encoder: The `JSONEncoder` used for encoding the configuration.
    /// - returns: A dictionary keyed by the `environmentKey` of the configuration type.
    static func environmentVariables(forConfiguration config: Self?, encoder: JSONEncoder = .init()) -> [String: String] {
        var environment: [String: String] = [:]
        
        if let configuration = config, let data = try? encoder.encode(configuration) {
            let json = String(data: data, encoding: .utf8)
            environment[environmentKey] = json
        }
        
        return environment
    }
    
    /// A JSON representation of the configuration that does not 'escaping slashes'.
    var unescapedJSON: String {
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
        do {
            let data = try encoder.encode(self)
            if let json = String(data: data, encoding: .utf8) {
                return json
            }
        } catch {
            print(error)
        }
        
        return "{}"
    }
}
