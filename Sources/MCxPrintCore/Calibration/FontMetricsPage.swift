//
//  FontMetricsPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct FontMetricsPage: MCxPrintJsonSpoolable, MCxPrintSvgSpoolable {

    // Key Independent Parameters
    // .dejaVuCondensed, .mswImpact .gaugeRegular
    let fontFamily  = FontHelper.PostscriptName.gaugeHeavy
    /// Font Size: Points Per Em
    let fontSize: CGFloat = 48.0
    
    // Secondary Values
    let lineWidth: CGFloat = 0.25
    // Derived Values
    let font: FontPointFamilyMetrics
    let page: CGRect = PrintTemplate.PaperPointRect.letter
    let oneInch: CGFloat = 72.0
    
    public init() {
        self.font = FontPointFamilyMetrics.fileLoad(fontFamily: fontFamily, fontSize: fontSize)!
    }
    
    private func svg() -> String {
        let baselineX = 0.15 * page.width
        let baselineY = 0.20 * page.height
        let ascentY = baselineY - font.ptsAscent
        let decentY = baselineY - font.ptsDescent
        
        var s = ""
        s = addPageRegistration(s)
        
        let text = "MQ.01Ofj⌘"
        font.toValues(string: text)
        
        ////////////////////
        // Show Advances //
        ///////////////////
        
        // Text String
        s.svgAddText(text: text, x: baselineX, y: baselineY, fontFamily: font.fontFamily, fontSize: font.fontSize)
        
        // text advances
        let advances = font.getAdvances(string: text) 
        var x: CGFloat = baselineX
        let advancesList: [CGSize] = advances.sizes
        for size in advancesList {
            s.svgAddLine(
                x1: x, y1: baselineY - font.ptsAscent,
                x2: x, y2: baselineY - font.ptsDescent,
                strokeWidth: 0.25)
            x = x + size.width
        }
        s.svgAddLine(
            x1: x, y1: baselineY - font.ptsAscent,
            x2: x, y2: baselineY - font.ptsDescent,
            strokeWidth: 0.25)
        
        let psName = font.fontFamily
        print("postScriptName: \(psName)")
        
        // text origin line
        s.svgAddLine(x1: 0, y1: baselineY, x2: page.width, y2: baselineY, strokeWidth: 0.25, stroke: "red")
        // text ascent line
        s.svgAddLine(x1: 0, y1: ascentY, x2: page.width, y2: ascentY, strokeWidth: 0.25, stroke: "red")
        // text decent line
        s.svgAddLine(x1: 0, y1: decentY, x2: page.width, y2: decentY, strokeWidth: 0.25, stroke: "red")
        // text origin dot
        s.svgAddCircle(cx: baselineX, cy: baselineY, r: 2.0, stroke: "magenta", strokeWidth: 0.5)
        
        /////////////////
        // Show Bounds //
        /////////////////
        
        let boundsOriginY: CGFloat = baselineY + 76.0
        // Text String
        s.svgAddText(text: text, x: baselineX, y: boundsOriginY, fontFamily: font.fontFamily, fontSize: font.fontSize)
        
        let boundsList = font.getBoundingRects(string: text) 
        
        print("boundsList \(boundsList)")
        var boundsOriginX: CGFloat = baselineX
        
        for i in 0 ..< text.count {
            let boundsRect: CGRect = boundsList[i]
            let glyphLeftSideBearing = boundsRect.origin.x
            let glyphTotalHeight = boundsRect.height
            let glyphDescent = -boundsRect.origin.y
            s.svgAddRect(
                x: boundsOriginX + glyphLeftSideBearing, 
                y: boundsOriginY - (glyphTotalHeight - glyphDescent),
                width: boundsRect.width, 
                height: boundsRect.height, 
                stroke: "green", strokeWidth: 0.25
            )
            boundsOriginX = boundsOriginX + advancesList[i].width
        }
        
        
        ///////////////////
        // Show Opticals //
        ///////////////////
        
        let opticalsY = boundsOriginY + 76.0
        let opticalAscentY = opticalsY - font.ptsAscent
        let opticalDecentY = opticalsY - font.ptsDescent
        
        // text origin line
        s.svgAddLine(x1: 0, y1: opticalsY, x2: page.width, y2: opticalsY, strokeWidth: 0.25, stroke: "red")
        // text ascent line
        s.svgAddLine(x1: 0, y1: opticalAscentY, x2: page.width, y2: opticalAscentY, strokeWidth: 0.25, stroke: "red")
        // text decent line
        s.svgAddLine(x1: 0, y1: opticalDecentY, x2: page.width, y2: opticalDecentY, strokeWidth: 0.25, stroke: "red")
        // text origin dot
        s.svgAddCircle(cx: baselineX, cy: opticalsY, r: 2.0, stroke: "magenta", strokeWidth: 0.5)

        
        // Text String
        s.svgAddText(text: text, x: baselineX, y: opticalsY, fontFamily: font.fontFamily, fontSize: font.fontSize)
        
        let opticalsList = font.getOpticalRects(string: text) 
        print("opticalsList \(opticalsList)")
        var opticalsX: CGFloat = baselineX
        
        for i in 0 ..< text.count {
            let opticalsRect = opticalsList[i]
            s.svgAddRect(
                x: opticalsX + opticalsRect.origin.x, // origin.x expected to be zero. 
                y: opticalsY - font.ptsAscent, 
                width: opticalsRect.width, 
                height: opticalsRect.height, 
                stroke: "blue", strokeWidth: 0.25
            )
            opticalsX = opticalsX + advancesList[i].width
        }
        
        
        ////////////////////
        // Metric Values //
        ///////////////////
        
        let infoX = baselineX
        var infoY = 0.72 * page.height
        // uses NO-BREAK SPACE ` ` U+00A0 UTF8: C2A0 for visual alignment
        s.svgAddText(
            text: "         ptsAscent  \(font.ptsAscent) max above baseline", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "         capHeight  \(font.ptsCapHeight)", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "            decent \(font.ptsDescent) max below baseline", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0 + 16.0
        s.svgAddText(
            text: "FontSize   \(fontSize)       Points/Em     \(fontFamily.rawValue)", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "         \(font.glyphUnitsPerEm)       GlyphUnits/Em", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "            \(font.ptsPerGlyphUnits) Points/GlyphUnits", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        infoY = infoY + 16.0
        s.svgAddText(
            text: " ptsLeading \(font.ptsLeading)", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.PostscriptName.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        
        s.svgWrapSvgTag(w: page.width, h: page.height, standalone: true)
        
        return s
    }
    
    private func addPageRegistration(_ string: String) -> String {
        var s = string
        
        // letter = CGRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        // 612.0 ÷ 72 = 8.5; 792.0 ÷ 72 = 11.0
        
        let centerX = 0.50 * page.width
        let centerY = 0.50 * page.height
        // center dot
        s.svgAddCircle(cx: centerX, cy: centerY, r: 1.0, stroke: "black", strokeWidth: 1.0, fill: "black")
        
        // page box
        s.svgAddRect(x: 0, y: 0, width: page.width, height: page.height, stroke: "black", strokeWidth: 0.25)
        // page box inset 1"
        s.svgAddRect(
            x: 0.0 + oneInch,
            y: 0.0 + oneInch,
            width: page.width - (2.0 * oneInch),
            height: page.height - (2.0 * oneInch),
            stroke: "black",
            strokeWidth: lineWidth
        )
        
        // page registration
        s.svgAddRect(x: 0.0, y: 0.0, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: 0.0, y: page.height - oneInch, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: page.width - oneInch, y: 0.0, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: page.width - oneInch, y: page.height - oneInch, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        
        return s
    }
    
    // /////////////////////////////
    // MARK: - MCxPrintJsonSpoolable
    // /////////////////////////////
    
    public func spoolAddStage1Json(spool: MCxPrintSpoolProtocol) -> URL? {
        fatalError(":NYI: FontMetricsPage spoolAddStage1Json()")
    }
    
    public func toSpoolJobBasename() -> String {
        return "TestFontMetricsPage"
    }
    
    public func toSpoolJsonData() -> Data? {
        fatalError(":NYI: FontMetricsPage toSpoolJsonData()")
    }
    
    public func toSpoolJsonStr() -> String? {
        fatalError(":NYI: FontMetricsPage toSpoolJsonStr()")
    }
    
    // ////////////////////////////
    // MARK: - MCxPrintSvgSpoolable
    // ////////////////////////////
    
    public init(jsonDataBlocks: [Data]) throws {
        self.init()
    }
    
    public init(jsonStrBlocks: [String]) throws {
        self.init()
    }
    
    public init(jsonUrlBlocks: [URL]) throws {
        self.init()
    }
    
    public static func jsonBatchAllowedSizes() -> [Int] {
        return [1]
    }
    
    public static func jsonBatchSupportsPartials() -> Bool {
        return false
    }
    
    public func toSpoolSvgStr() -> String {
        return self.svg()
    }

    public func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol) -> URL? {
        return spool.spoolAddStage2Svg(item: self, jobname: nil)
    }
    
    public func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol, jobname: String?) -> URL? {
        return spool.spoolAddStage2Svg(item: self, jobname: jobname)
    }
    
}
