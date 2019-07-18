//
//  MCxPrintSpoolTests.swift
//  MCxPrintTests
//
//  Created by marc on 2019.07.13.
//

import XCTest
@testable import MCxPrintCore

class MCxPrintSpoolTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLibraryFilelabelRemainder1Page() {
        let spool = MCxPrintSpoolManager("/var/spool/mcxprint_spool/test/labelfile", batchSize: 1)
        
        let fileLabel = LibraryFileLabel(
            title: "Business: Let's Go Do It",
            udcCall: "340-•-JoBah-BLGDI",
            udcLabel: "Terms of Use",
            collectionSID: "Business",
            collectionColor: LabelColorTheme.business
        )
        
        fileLabel.spoolWrite(spool: spool)
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    static var allTests = [
        ("testLibraryFilelabelRemainder1Page", testLibraryFilelabelRemainder1Page)
    ]

}
