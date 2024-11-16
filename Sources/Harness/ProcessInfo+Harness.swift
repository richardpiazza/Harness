import Foundation

public extension ProcessInfo {
    /// Indication if the current process is running for SwiftUI Previews
    var isTargetPreviews: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    /// Indication if the current process is running for XC[Unit/UI]Tests
    var isTargetTest: Bool {
        if environment.keys.contains("XCTestBundlePath") {
            return true
        }
        
        if environment.keys.contains("XCTestConfigurationFilePath") {
            return true
        }
        
        if environment.keys.contains("XCTestSessionIdentifier") {
            return true
        }
        
        if arguments.contains("--testing-library") {
            return true
        }
        
        return arguments.contains(where: { arg in
            let path = URL(fileURLWithPath: arg)
            if path.lastPathComponent == "swiftpm-testing-helper" || path.lastPathComponent == "xctest" {
                return true
            }
            
            if path.pathExtension == "xctest" {
                return true
            }
            
            return false
        })
    }
}
