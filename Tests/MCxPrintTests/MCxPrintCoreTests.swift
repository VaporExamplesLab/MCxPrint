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

    /*
     sudo apt install cups-bsd ## to install BSD lpr
     
     lpstat -p
     
     ---------------------------------
     lpoptions -p Brother_PT_9500PC -l
     
     PageSize/Media Size: 6mm 9mm 12mm 18mm 24mm *36mm 12mmx2 18mmx2 24mmx2 36mmx2 12mmx3 18mmx3 24mmx3 36mmx3 12mmx4 18mmx4 24mmx4 36mmx4 AV1789 AV1957 AV2067 C_36mm_01 C_24mm_02 C_6mm_03 C_18mm_04 C_9mm_05 C_18mm_06 C_9mm_07 C_12mm_08 C_6mm_09 C_9mm_10 C_24mm_11 C_6mm_12 C_36mm_13 Custom.WIDTHxHEIGHT
     
     BrTapeLength/Length: *4
     BrMargin/Margin: *1
     Resolution/Quality: *360x360dpi 360x720dpi
     BrHalftonePattern/Halftone: BrBinary BrDither *BrErrorDiffusion
     BrBrightness/Brightness: 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 *0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20
     BrContrast/Contrast: 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 *0 -1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12 -13 -14 -15 -16 -17 -18 -19 -20
     BrAutoTapeCut/Auto Cut: OFF *ON
     BrMirror/Mirror Printing: *OFF ON
     BrHalfCut/Half Cut: *OFF ON
     BrChainPrint/Chain Printing: *OFF ON
     
     Custom.WIDTHxHEIGHT
     
     -----------------------------
     lpoptions -p EPSON_WF_7520 -l
     
     ColorModel/Color Mode: Gray *RGB
     cupsPrintQuality/Quality: *Normal High
     Duplex/2-Sided Printing: None *DuplexNoTumble DuplexTumble
     PageSize/Media Size: 13x19 13x19.Fullbleed 3.5x5 3.5x5.Fullbleed 4x6 4x6.Fullbleed 5x7 5x7.Fullbleed 8x10 8x10.Fullbleed A3 A3.Fullbleed A4 A4.Fullbleed A5 A6 A6.Fullbleed B4 B5 Env10 EnvC6 EnvDL Legal *Letter Letter.Fullbleed PRC32K PRC32K.Fullbleed Postcard Postcard.Fullbleed Tabloid Tabloid.Fullbleed
     MediaType/MediaType: stationery photographic-high-gloss photographic photographic-glossy photographic-matte stationery-inkjet envelope *any
     InputSlot/Media Source: auto main alternate

     ----------------------------------------
     lpoptions -p EPSON_Stylus_Photo_R2880 -l
     
     EPIJ_PSrc/Page Setup: *2 3 40 11 12 13 31 32 41 33 25
     EPIJ_Size/Paper Size: *4 5 43 35 6 23 1 0 10 3 2 7 70 74 76 28 97 29 95 77 96
     EPIJ_PrStSlID/Print Settings Selection ID: *0 1
     EPIJ_Medi/Media Type: *13 97 15 27 14 12 2 46 53 88 17 0 26 76
     EPIJ_Ink_/Color: *1 3 0
     EPIJ_CoDp/16 bit/Channel: *0 1
     EPIJ_Mode/Mode: *0 3
     EPIJ_APri/Automatic: 0 1 *2
     EPIJ_Manu/Custom: *0
     EPIJ_Qual/Print Quality: 42 33 *35 36 52
     EPIJ_Bi_D/High Speed: 0 *1
     EPIJ_Hori/Mirror Image: *0 1
     EPIJ_FDet/Finest Detail: 0 *1
     EPIJ_ClTn/Color Toning: *0 1 2 3 255
     EPIJ_MoGm/Tone: 0 *1 2 3 4
     EPIJ_Mobr/Brightness: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_MoCo/Contrast: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_ShTo/Shadow Tonality: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_HiTo/Highlight Tonality: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_MxOD/Max Optical Density: -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0
     EPIJ_CirX/Horizontal: -75 -74 -73 -72 -71 -70 -69 -68 -67 -66 -65 -64 -63 -62 -61 -60 -59 -58 -57 -56 -55 -54 -53 -52 -51 -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75
     EPIJ_CirY/Vertical: -75 -74 -73 -72 -71 -70 -69 -68 -67 -66 -65 -64 -63 -62 -61 -60 -59 -58 -57 -56 -55 -54 -53 -52 -51 -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75
     EPIJ_HiPS/Highlight Point Shift: *0 2 1
     EPIJ_CMat/Color Settings: *0 1 3
     EPIJ_CCor/Mode: *4 6
     EPIJ_Gamm/Gamma: *0 1
     EPIJ_UEpL/EPSON Color LUT: *0 1
     EPIJ_ERGB/E-RGB: *0 1
     EPIJ_ECAv/Advanced Settings: *0 1
     EPIJ_Brit/Brightness: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_Cont/Contrast: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_Satu/Saturation: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_Cyan/Cyan: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_Mage/Magenta: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_Yell/Yellow: -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
     EPIJ_ATon/Scene Correction: *7 11 12 13 4 8
     EPIJ_AFil/Sharpen: *0 1
     EPIJ_AGai/Sharpness Option: *1 2
     EPIJ_ACam/Digital Camera Correction: *0 1
     EPIJ_DCCT/Image Purelyzer Option: *0 1
     EPIJ_OSColMat/ColorMatching: *1 2
     EPIJ_HdofClSp/Use Generic RGB: *0 1
     EPIJ_OSCMProf/CustomColorMatchingProfile: *0 1 2 3
     EPIJ_exmg/Expansion: 0 1 *2
     EPIJ_CutS/Roll Paper Option: 0 *1
     EPIJ_SRol/Save roll paper: *0 1
     EPIJ_PFra/Print page frame: *0 1
     EPIJ_IkDt/Color Density: -50 -49 -48 -47 -46 -45 -44 -43 -42 -41 -40 -39 -38 -37 -36 -35 -34 -33 -32 -31 -30 -29 -28 -27 -26 -25 -24 -23 -22 -21 -20 -19 -18 -17 -16 -15 -14 -13 -12 -11 -10 -9 -8 -7 -6 -5 -4 -3 -2 -1 *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
     EPIJ_DrTm/Drying Time per Print Head Pass: *0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
     EPIJ_GPPc/Check paper width before printing: *0 1
     EPIJ_PGDt/Platen Gap: *3 2
     EPIJProfileSpec/EPSON Profile: *0 1 2 3 4 5 6 7 8 9 10 11 12
     ColorModel/ColorModel: *RGB Mono ABWP RGB16
     MediaType/MediaType: *13 97 15 27 14 12 2 46 53 88 17 0 26 76
     Resolution/Resolution: 360x360dpi *720x720dpi
     PageSize/Media Size: *Letter Letter.NMgn Letter.4SideNMgnRet Letter.SheetMax Letter.SheetNMgn Letter.SheetNMgnRet Legal Legal.SheetMax Legal.SheetNMgn Legal.SheetNMgnRet EPHalfLetter EPUS_B EPUS_B.NMgn EPUS_B.4SideNMgnRet EPUS_B.SheetMax EPUS_B.SheetNMgn EPUS_B.SheetNMgnRet A6 A5 A4 A4.NMgn A4.4SideNMgnRet A4.SheetMax A4.SheetNMgn A4.SheetNMgnRet A4.ManuCDR A3 A3.NMgn A3.4SideNMgnRet A3.SheetMax A3.SheetNMgn A3.SheetNMgnRet EP13x19 EP13x19.NMgn EP13x19.4SideNMgnRet EP13x19.Roll EP13x19.RollTrimDefine EP13x19.RollTrimBanner EP13x19.SheetMax EP13x19.SheetNMgn EP13x19.SheetNMgnRet EP13x19.ManuFeed B5 B4 EP100x148mm EPPhotoPaperLRoll EPPhotoPaperLRoll.NMgn EPPhotoPaperLRoll.4SideNMgnRet EPKG EPKG.NMgn EPKG.4SideNMgnRet EPPhotoPaper2L EPPhotoPaper2L.NMgn EPPhotoPaper2L.4SideNMgnRet EPIndexCard5x8 EPIndexCard5x8.NMgn EPIndexCard5x8.4SideNMgnRet EPHiVision102x180 EPHiVision102x180.NMgn EPHiVision102x180.4SideNMgnRet EP8x10in EP8x10in.NMgn EP8x10in.4SideNMgnRet EPYotsugiri EP11x14 EP11x14.NMgn EP11x14.4SideNMgnRet EP11x14.SheetMax EP11x14.SheetNMgn EP11x14.SheetNMgnRet EP12x12 EP12x12.NMgn EP12x12.4SideNMgnRet EP12x12.SheetMax EP12x12.SheetNMgn EP12x12.SheetNMgnRet Custom.WIDTHxHEIGHT
         EPIJ_ENAL/Warning Notifications: 1-0_2-0_3-0_4-0 *1-1_2-1_3-1_4-1
     
     lp -o landscape -o scaling=75 -o media=A4 filename.jpg
     
     */
    
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

    let defaultPrinter = "EPSON_WF_7520"
    let booklabelPrinter = "Brother_PT_9500PC"
    let filelabelPrinter = "EPSON_WF_7520"
    let inPrinterEnabled = true
    
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

    // :NYI:!!!: based on pdf print, resize to 0.94" x 2.76" ~ 24mm x 70mm
    // if custom page size is not supported.
    func testLibraryBookLabel() throws {
        let jobOptions = MCxPrintJobOptions(
            printerName: booklabelPrinter, 
            options: ["Media=Custom.26x85mm", "Landscape", "Quality=360x720dpi"]
        )
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/labelbook", 
            batchSize: 1, 
            jsonSpooler: LibraryBookLabel.self, 
            svgSpooler: LibraryBookLabel.self, 
            jobOptions: jobOptions
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
        if inPrinterEnabled {
            _ = spool.processJobsStage3Pdf()
        }
    }
    
    func testFontMetricsPage() throws {
        let jobOptions = MCxPrintJobOptions(
            printerName: defaultPrinter, 
            options: [] 
        )
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/scratch", 
            batchSize: 1, 
            jsonSpooler: FontMetricsPage.self, 
            svgSpooler: FontMetricsPage.self, 
            jobOptions: jobOptions
        )

        // ------------------
        // -- Font Metrics --
        let fontMetricsPage = FontMetricsPage()
        // Add
        _ = spool.spoolAddStage2Svg(item: fontMetricsPage, jobname: nil)
        // Process
        _ = spool.processJobsStage2Svg()
        if inPrinterEnabled {
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
        let jobOptions = MCxPrintJobOptions(
            printerName: filelabelPrinter, 
            options: [] 
        )
        let spool = try MCxPrintSpool(
            "/var/spool/mcxprint_spool/test/labelfile", 
            batchSize: 9, // 2 or 9
            jsonSpooler: LibraryFileLabel.self, 
            svgSpooler: LibraryFilePage.self, 
            jobOptions: jobOptions
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
        if inPrinterEnabled {
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
