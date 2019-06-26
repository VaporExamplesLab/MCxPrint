import XCTest
import class Foundation.Bundle

/// MCxPrintTests exercises the command line interface
final class MCxPrintTests: XCTestCase {
    func testExample() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let executableUrl = productsDirectory.appendingPathComponent("MCxPrint")

        let process = Process()
        process.executableURL = executableUrl

        let pipe = Pipe()
        process.standardOutput = pipe
        
        

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        //XCTAssertEqual(output, "Hello, world!\n")
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func testBookLabel() {
        
    }
    
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
