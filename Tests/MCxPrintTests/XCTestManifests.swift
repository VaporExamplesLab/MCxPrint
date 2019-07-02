import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MCxPrintTests.allTests),
        testCase(MCxPrintCoreTests.allTests),
    ]
}
#endif
