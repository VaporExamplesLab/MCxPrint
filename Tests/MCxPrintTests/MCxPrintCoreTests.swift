//
//  MCxPrintCoreTests.swift
//  MCxPrintTests
//
//  Created by marc on 2019.06.18.
//

import XCTest
@testable import MCxPrintCore

class MCxPrintCoreTests: XCTestCase {

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
    }

    func testInventoryPartLabel() {
    let partA = InventoryPartLabel(
        name: "Resistor",
        value: "100K",
        description: "carbon"
        )
        let svgPartA = partA.svg()
        try? svgPartA.write(to: scratchUrl.appendingPathComponent("PartATest.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "PartATest")
        
        let partB = InventoryPartLabel(
            name: "9DOF Sensor",
            value: "Adafruit-12345",
            description: ""
        )
        let svgPartB = partB.svg()
        try? svgPartB.write(to: scratchUrl.appendingPathComponent("PartBTest.svg"), atomically: false, encoding: .utf8)
        
        printJob.svgToPdf(basename: "PartBTest")
    }

    func testLibraryBookLabel() {
        let bookA = LibraryBookLabel(
            udcCall: "004.52-•-MC-WEDN",
            udcLabel: "Generic Labels - SVG Layout Example",
            collectionSID: "ABCDEFgH",
            collectionColor: "green"
        )
        let svgBookA = bookA.svg()
        try? svgBookA.write(to: scratchUrl.appendingPathComponent("BookATest.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "BookATest")
        
        let bookB = LibraryBookLabel(
            udcCall: "621.382202855132-•-EgPyM-CLADSP-v1991",
            udcLabel: "Signal processing - Specific programming language",
            collectionSID: "ABCDEFgH",
            collectionColor: ""
        )
        let svgBookB = bookB.svg()
        try? svgBookB.write(to: scratchUrl.appendingPathComponent("BookBTest.svg"), atomically: false, encoding: .utf8)
        
        printJob.svgToPdf(basename: "BookBTest")
    }
    
    func testFontMetrics() {
        // ------------------
        // -- Font Metrics --
        let fontMetricsPage = FontMetricsPage()
        let fontMetricsPageSvg = fontMetricsPage.svg()
        try? fontMetricsPageSvg.write(to: scratchUrl.appendingPathComponent("FontMetricsPageTest.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "FontMetricsPageTest")
    }
    
    func testCreateUnicodeFontMap() {
        let fontFamily  = FontHelper.Name.dejaVuCondensed
        let fontSize: CGFloat = 12.0
        let font = try! FontMetric(fontFamily: fontFamily, fontSize: fontSize)
        
        font.createUnicodeFontMap()
    }
    
    func testLibraryFilePage() {
        let fileA = LibraryFileLabel(
            title: "Wingding Everest Dialog Network",
            udcCall: "004.52-•-MC-WEDN",
            udcLabel: "🅆 ⌘ ★ view & <ÿ¼> values",
            collectionSID: "ACADEMIC",
            collectionColor: LabelColorTheme.academic
        )
        
        let fileB = LibraryFileLabel(
            title: "FileMaker Pro 9 Advanced Software",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Specific relational database management systems",
            collectionSID: "FINANCES",
            collectionColor: LabelColorTheme.finances
        )
        
        let fileC = LibraryFileLabel(
            title: "Legal: Contracts",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Terms of Use",
            collectionSID: "Legal",
            collectionColor: LabelColorTheme.legal
        )

        let fileD = LibraryFileLabel(
            title: "Markcom: Next Big Thing",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Conferences & Trade Shows",
            collectionSID: "MarkCom",
            collectionColor: LabelColorTheme.markcom
        )
        let fileE = LibraryFileLabel(
            title: "People: Glad to meet you.",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Activity with goal & timetable",
            collectionSID: "People",
            collectionColor: LabelColorTheme.people
        )
        let fileF = LibraryFileLabel(
            title: "Project: Get It Done",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Activity with goal & timetable",
            collectionSID: "PROJECT",
            collectionColor: LabelColorTheme.project
        )
        let fileG = LibraryFileLabel(
            title: "Records: Historic Documents",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Signed documents, etc.",
            collectionSID: "RECORD",
            collectionColor: LabelColorTheme.record
        )
        let fileH = LibraryFileLabel(
            title: "Reference Materials",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "General catalog of knowledge",
            collectionSID: "Reference",
            collectionColor: LabelColorTheme.reference
        )
        let fileI = LibraryFileLabel(
            title: "System: Infrastructure",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "For example, file section dividers.",
            collectionSID: "SYSTEM",
            collectionColor: LabelColorTheme.system
        )
        
        let labelArray = [fileA, fileB, fileC, fileD, fileE, fileF, fileG, fileH, fileI]
        let page = LibraryFilePage(labels: labelArray)
        
        let pageSvg = page.svg(framed: true)
        try? pageSvg.write(to: scratchUrl.appendingPathComponent("LibraryFilePageTest.svg"), atomically: false, encoding: .utf8)
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "LibraryFilePageTest")
    }
    
    func testStringEncoding() {
        var textContainingUnicode: String =
        """
        Let's go 🏊 in the 🌊.
          & some “new” lines <ÿ¼>.
        """
        textContainingUnicode.filterToSvgAscii()
        print("🌊 \(textContainingUnicode)")
    }
    
    func testLabelJson() {
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
