import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MCxPrintCoreTests.allTests),
        testCase(MCxPrintSpoolTests.allTests),
        testCase(MCxPrintTests.allTests),
    ]
}
#endif
