//
//  MCxPrintCoreTests.swift
//  MCxPrintTests
//
//  Created by marc on 2019.06.18.
//

import XCTest
@testable import MCxPrintCore

/// MCxPrintCoreTests
class MCxPrintCoreTests: XCTestCase {

    /// Use `lpstat -p` to find available printers
    ///
    /// * Brother_PT_9500PC
    /// * EPSON_Stylus_Photo_R2880
    /// * EPSON_WF_7520
    ///
    /// See also: 
    /// * http://www.it.uu.se/datordrift/maskinpark/skrivare/cups/ 
    /// * https://www.cyberciti.biz/tips/linux-unix-sets-the-page-size-to-size.html
    ///
    /// CUPS configuration: http://localhost:631/ or /etc/cups/cupsd.conf 
    /// * Can pdf be printed manually?

    let printerDefault = "EPSON_WF_7520"
    let printerForBookLabels = "Brother_PT_9500PC"
    let printerForFileLabels = "EPSON_WF_7520"
    let enablePrinter = true
    
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

    func testInventoryPartLabel() throws {
//        let spool = try MCxPrintSpool( 
//            "/var/spool/mcxprint_spool/test/labelpart", 
//            batchSize: 12, 
//            jsonSpooler: <#T##MCxPrintJsonSpoolable.Type#>, 
//            svgSpooler: <#T##MCxPrintSvgSpoolable.Type#>
//        )
//        let cachedUrl = spool.stage2SvgUrl
//
//        let partA = InventoryPartsLabel(
//            name: "Resistor",
//            value: "100K",
//            description: "carbon"
//        )
//        let svgPartA = partA.svg()
//        try? svgPartA.write(to: cachedUrl.appendingPathComponent("TestPartA.svg"), atomically: false, encoding: .utf8)
//        
//        spool.svgToPdf(basename: "TestPartA")
//        
//        let partB = InventoryPartsLabel(
//            name: "9DOF Sensor",
//            value: "Adafruit-12345",
//            description: ""
//        )
//        let svgPartB = partB.svg()
//        try? svgPartB.write(to: cachedUrl.appendingPathComponent("TestPartB.svg"), atomically: false, encoding: .utf8)
//        
//        spool.svgToPdf(basename: "TestPartB")
    }

    func testLibraryBookLabel() throws {
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/labelbook", 
            batchSize: 1, 
            jsonSpooler: LibraryBookLabel.self, 
            svgSpooler: LibraryBookLabel.self, 
            printerName: printerForBookLabels
        )

        //let labelBook = LibraryBookLabel(
        //    udcCall: "004.52-•-MC-WEDN",
        //    udcLabel: "Generic Labels - SVG Layout Example",
        //    collectionSID: "Reference"
        //)
        
        let labelBook = LibraryBookLabel(
            udcCall: "621.382202855132-•-EgPyM-CLADSP-v1991",
            udcLabel: "Signal processing - Specific programming language",
            collectionSID: "Oversize"
        )
        
        // Add
        _ = spool.spoolAddStage1Json(item: labelBook)
        // Process
        _ = spool.processJobsStage1Json()
        _ = spool.processJobsStage2Svg()
        if enablePrinter {
            _ = spool.processJobsStage3Pdf()
        }
    }
    
    func testFontMetricsPage() throws {
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/scratch", 
            batchSize: 1, 
            jsonSpooler: FontMetricsPage.self, 
            svgSpooler: FontMetricsPage.self, 
            printerName: printerDefault
        )

        // ------------------
        // -- Font Metrics --
        let fontMetricsPage = FontMetricsPage()
        // Add
        _ = spool.spoolAddStage2Svg(item: fontMetricsPage)
        // Process
        _ = spool.processJobsStage2Svg()
        if enablePrinter {
            _ = spool.processJobsStage3Pdf()
        }
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
    
    func testLibraryFilePage() throws {
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/labelfile", 
            batchSize: 9, // 2 or 9
            jsonSpooler: LibraryFileLabel.self, 
            svgSpooler: LibraryFilePage.self, 
            printerName: printerDefault
        )
        
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
            title: "Business: Let's Go Do It",
            udcCall: "340-•-JoBah-BLGDI",
            udcLabel: "Terms of Use",
            collectionSID: "Business",
            collectionColor: LabelColorTheme.business
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
            udcCall: "005.7565-FMKR-Fil-PGMY",
            udcLabel: "Activity with goal & timetable",
            collectionSID: "People",
            collectionColor: LabelColorTheme.people
        )
        let fileLabelF = LibraryFileLabel(
            title: "FileMaker Pro 9 Advanced Software Migration From Project",
            udcCall: "005.7565-FMKR-Fil-FPAMP",
            udcLabel: "Specific relational database management system activity with goal & timetable",
            collectionSID: "Project",
            collectionColor: LabelColorTheme.project
        )
        let fileLabelG = LibraryFileLabel(
            title: "Records: Historic Documents",
            udcCall: "005.7565-FMKR-Fil-RHD",
            udcLabel: "Signed documents, etc.",
            collectionSID: "Record",
            collectionColor: LabelColorTheme.record
        )
        let fileLabelH = LibraryFileLabel(
            title: "Reference Materials",
            udcCall: "005.7565-FMKR-Fil-RM",
            udcLabel: "General catalog of knowledge",
            collectionSID: "Reference",
            collectionColor: LabelColorTheme.reference
        )
        let fileLabelI = LibraryFileLabel(
            title: "System: Infrastructure",
            udcCall: "005.7565-FMKR-Fil-SI",
            udcLabel: "For example, file section dividers.",
            collectionSID: "System",
            collectionColor: LabelColorTheme.system
        )
        
        let labelArray = [fileLabelA, fileLabelB, fileLabelC, fileLabelD, fileLabelE, fileLabelF, fileLabelG, fileLabelH, fileLabelI]
        
        for label in labelArray {
            // Add
            _ = spool.spoolAddStage1Json(item: label)
        }
        
        // Process
        _ = spool.processJobsStage1Json()
        _ = spool.processJobsStage2Svg()
        if enablePrinter {
            _ = spool.processJobsStage3Pdf()
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
    
    func testFilterToSvgAscii() {
        let testScratchUrl = URL(fileURLWithPath: "/var/spool/mcxprint_spool/test/scratch", isDirectory: true)
        do {
            let str = "it's"
            
            let svgPreFilter = "it's \\ < > & \" ⌘ ⭐️"
            let svgPostFilter = svgPreFilter.filteringToSvgAscii()
            try svgPostFilter.write(
                to: testScratchUrl.appendingPathComponent("00_filtered.txt"), 
                atomically: false, 
                encoding: String.Encoding.utf8)
            
            try str.write(
                to: testScratchUrl.appendingPathComponent("01_utf8.txt"), 
                atomically: false, 
                encoding: String.Encoding.utf8)
            // it's
            
            try str.write(
                to: testScratchUrl.appendingPathComponent("02_ascii.txt"), 
                atomically: false, 
                encoding: String.Encoding.ascii)
            // it's
            
            let label = LibraryFileLabel(
                title: "it's",
                udcCall: "",
                udcLabel: "",
                collectionSID: "",
                collectionColor: LabelColorTheme.business
            )
            let svglabelStr: String = label.svg()
            try svglabelStr.write(
                to: testScratchUrl.appendingPathComponent("03_label.txt"), 
                atomically: false, 
                encoding: String.Encoding.utf8)
            // it\'s
            
            var svgAddText = ""
            svgAddText.svgAddText(text: "it's", x: 0.0, y: 0.0)
            try svgAddText.write(
                to: testScratchUrl.appendingPathComponent("04_addtext.txt"), 
                atomically: false, 
                encoding: String.Encoding.utf8)
            // it\'s
            
            
        } catch {
        }
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
        ("testFilterToSvgAscii", testFilterToSvgAscii),        
        ("testPerformanceExample", testPerformanceExample)
    ]

}
