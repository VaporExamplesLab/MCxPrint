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
        try? svgPartA.write(to: spoolTestUrl.appendingPathComponent("TestPartA.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "TestPartA")
        
        let partB = InventoryPartLabel(
            name: "9DOF Sensor",
            value: "Adafruit-12345",
            description: ""
        )
        let svgPartB = partB.svg()
        try? svgPartB.write(to: spoolTestUrl.appendingPathComponent("TestPartB.svg"), atomically: false, encoding: .utf8)
        
        printJob.svgToPdf(basename: "TestPartB")
    }

    func testLibraryBookLabel() {
        let labelBookA = LibraryBookLabel(
            udcCall: "004.52-•-MC-WEDN",
            udcLabel: "Generic Labels - SVG Layout Example",
            collectionSID: "ABCDEFgH",
            collectionColor: "green"
        )
        let svgBookA = labelBookA.svg()
        try? svgBookA.write(to: spoolTestUrl.appendingPathComponent("TestBookA.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "TestBookA")
        
        let labelBookB = LibraryBookLabel(
            udcCall: "621.382202855132-•-EgPyM-CLADSP-v1991",
            udcLabel: "Signal processing - Specific programming language",
            collectionSID: "ABCDEFgH",
            collectionColor: ""
        )
        let svgBookB = labelBookB.svg()
        try? svgBookB.write(to: spoolTestUrl.appendingPathComponent("TestBookB.svg"), atomically: false, encoding: .utf8)
        
        printJob.svgToPdf(basename: "TextBookB")
        
        // write to and read from spool directory
        if let spoolBookUrlA = LibraryBookLabel.spoolWrite(labelBookA),
            let spoolBookUrlB = LibraryBookLabel.spoolWrite(labelBookB)
        {
            print("spoolBookUrlA: \(spoolBookUrlA.path)")
            print("spoolBookUrlB: \(spoolBookUrlB.path)")
            
            if let spoolLabelA = LibraryBookLabel.spoolLoad(fileUrl: spoolBookUrlA),
                let spoolLabelB = LibraryBookLabel.spoolLoad(fileUrl: spoolBookUrlB) {
                XCTAssert(spoolLabelA.udcCall == labelBookA.udcCall)
                XCTAssert(spoolLabelB.udcCall == labelBookB.udcCall)
                XCTAssert(true, "read spool files OK.")
            }
        }
        else {
            XCTFail("testLibraryFilePage()")
        }

    }
    
    func testFontMetricsPage() {
        // ------------------
        // -- Font Metrics --
        let fontMetricsPage = FontMetricsPage()
        let fontMetricsPageSvg = fontMetricsPage.svg()
        try? fontMetricsPageSvg.write(to: spoolTestUrl.appendingPathComponent("TestFontMetricsPage.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "TestFontMetricsPage")
    }
    
    func testCreateUnicodeFontMap() {
        let fontFamily  = FontHelper.PostscriptName.dejaVuCondensed
        let fontSize: CGFloat = 12.0
        if let font = FontPointFamilyMetrics.fileLoad(fontFamily: fontFamily, fontSize: fontSize) {
            print("font.lookup.count = \(font.lookup.count)")
        }
        else {
            XCTFail("ERROR: could not load font \(fontFamily) \(fontFamily)")
        }
    }
    
    func testLibraryFilePage() {
        let fileLabelA = LibraryFileLabel(
            title: "Wingding Everest Dialog Network",
            udcCall: "004.52-•-MC-WEDN v12 n92 g88 w00 zaqt",
            udcLabel: "🅆 ⌘ ★ view & <ÿ¼> values",
            collectionSID: "Academic",
            collectionColor: LabelColorTheme.academic
        )
        
        let fileLabelB = LibraryFileLabel(
            title: "FileMaker Pro 9 Advanced Software",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Specific relational database management systems",
            collectionSID: "Finances",
            collectionColor: LabelColorTheme.finances
        )
        
        let fileLabelC = LibraryFileLabel(
            title: "Legal: Contracts",
            udcCall: "340-•-JoBah-LC",
            udcLabel: "Terms of Use",
            collectionSID: "Legal",
            collectionColor: LabelColorTheme.legal
        )

        let fileLabelD = LibraryFileLabel(
            title: "Next Big Thing in Pattern Information Processing",
            udcCall: "004.93-•-MCa-NBTPIP",
            udcLabel: "Conferences & Trade Shows",
            collectionSID: "MarkCom",
            collectionColor: LabelColorTheme.markcom
        )
        let fileLabelE = LibraryFileLabel(
            title: "People: Glad to meet you.",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Activity with goal & timetable",
            collectionSID: "People",
            collectionColor: LabelColorTheme.people
        )
        let fileLabelF = LibraryFileLabel(
            title: "FileMaker Pro 9 Advanced Software Migration From Project",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Specific relational database management system activity with goal & timetable",
            collectionSID: "Project",
            collectionColor: LabelColorTheme.project
        )
        let fileLabelG = LibraryFileLabel(
            title: "Records: Historic Documents",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "Signed documents, etc.",
            collectionSID: "Record",
            collectionColor: LabelColorTheme.record
        )
        let fileLabelH = LibraryFileLabel(
            title: "Reference Materials",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "General catalog of knowledge",
            collectionSID: "Reference",
            collectionColor: LabelColorTheme.reference
        )
        let fileLabelI = LibraryFileLabel(
            title: "System: Infrastructure",
            udcCall: "005.7565-FMKR-Fil-FPASC",
            udcLabel: "For example, file section dividers.",
            collectionSID: "System",
            collectionColor: LabelColorTheme.system
        )
        
        let labelArray = [fileLabelA, fileLabelB, fileLabelC, fileLabelD, fileLabelE, fileLabelF, fileLabelG, fileLabelH, fileLabelI]
        let page = LibraryFilePage(labels: labelArray)
        
        let pageSvg = page.svg(framed: false)
        try? pageSvg.write(to: spoolTestUrl.appendingPathComponent("TestLibraryFilePage.svg"), atomically: false, encoding: .utf8)
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "TestLibraryFilePage")
        
        // write to and read from spool directory
        if let spoolUrlA = LibraryFileLabel.spoolWrite(fileLabelA),
            let spoolUrlB = LibraryFileLabel.spoolWrite(fileLabelB),
            let spoolUrlC = LibraryFileLabel.spoolWrite(fileLabelC)
            {
                print("spoolUrlA: \(spoolUrlA.path)")
                print("spoolUrlB: \(spoolUrlB.path)")
                print("spoolUrlC: \(spoolUrlC.path)")
                
                if let spoolLabelA = LibraryFileLabel.spoolLoad(fileUrl: spoolUrlA),
                    let spoolLabelB = LibraryFileLabel.spoolLoad(fileUrl: spoolUrlB),
                    let spoolLabelC = LibraryFileLabel.spoolLoad(fileUrl: spoolUrlC) {
                    XCTAssert(spoolLabelA.udcCall == fileLabelA.udcCall)
                    XCTAssert(spoolLabelB.udcCall == fileLabelB.udcCall)
                    XCTAssert(spoolLabelC.udcCall == fileLabelC.udcCall)
                    XCTAssert(true, "read spool files OK.")
                }
        }
        else {
            XCTFail("testLibraryFilePage()")
        }
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
    
    static var allTests = [
        ("testExample", testExample),
        ("testInventoryPartLabel", testInventoryPartLabel),
        ("testLibraryBookLabel", testLibraryBookLabel),
        ("testFontMetricsPage", testFontMetricsPage),
        ("testCreateUnicodeFontMap", testCreateUnicodeFontMap),
        ("testLibraryFilePage", testLibraryFilePage),
        ("testStringEncoding", testStringEncoding),
        ("testLabelJson", testLabelJson),
        ("testPerformanceExample", testPerformanceExample)
    ]

}
