//
//  FontMetricsPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct FontMetricsPage {
    // Key Independent Parameters
    let fontFamily  = FontHelper.Name.dejaVuCondensed
    /// Font Size: Points Per Em
    let fontSize: CGFloat = 48.0
    
    // Secondary Values
    let lineWidth: CGFloat = 0.25
    // Derived Values
    let font: FontMetric
    let page: CGRect = PrintTemplate.PaperPointRect.letter
    let oneInch: CGFloat = 72.0
    
    public init() {
        self.font = try! FontMetric(fontFamily: fontFamily, fontSize: fontSize)
    }
    
    public func svg() -> String {
        font.getGlyphWithMaxAscent()
        
        let baselineX = 0.15 * page.width
        let baselineY = 0.20 * page.height
        let ascentY = baselineY - font.ascent()
        let decentY = baselineY - font.decent()
        
        var s = ""
        s = addPageRegistration(s)
        
        let text = "MQ.01Ofj⌘"
        font.showCharacters(string: text)
        
        ////////////////////
        // Show Advances //
        ///////////////////
        
        // Text String
        s.svgAddText(text: text, x: baselineX, y: baselineY, fontFamily: font.cgFontFamily, fontSize: font.cgFontSize)
        
        // text advances
        guard let advances = font.getAdvances(string: text) 
            else { 
                print("ERROR: getAdvances() failed")
                return ""
        } 
        var x: CGFloat = baselineX
        let advancesList: [CGSize] = advances.sizes
        for size in advancesList {
            s.svgAddLine(
                x1: x, y1: baselineY - font.ascent(),
                x2: x, y2: baselineY - font.decent())
            x = x + size.width
        }
        s.svgAddLine(
            x1: x, y1: baselineY - font.ascent(),
            x2: x, y2: baselineY - font.decent())
        
        if let psName = font.cgFont.postScriptName {
            print("postScriptName: \(psName)")
        }
        else {
            print("postScriptName: NOT_FOUND")
        }
        
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
        s.svgAddText(text: text, x: baselineX, y: boundsOriginY, fontFamily: font.cgFontFamily, fontSize: font.cgFontSize)
        
        guard let bounds = font.getBoundingRects(string: text) 
            else {
                print("ERROR: getBoundingRects() failed")
                return ""
        }
        
        let boundsList = bounds.list
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
        let opticalAscentY = opticalsY - font.ascent()
        let opticalDecentY = opticalsY - font.decent()
        
        // text origin line
        s.svgAddLine(x1: 0, y1: opticalsY, x2: page.width, y2: opticalsY, strokeWidth: 0.25, stroke: "red")
        // text ascent line
        s.svgAddLine(x1: 0, y1: opticalAscentY, x2: page.width, y2: opticalAscentY, strokeWidth: 0.25, stroke: "red")
        // text decent line
        s.svgAddLine(x1: 0, y1: opticalDecentY, x2: page.width, y2: opticalDecentY, strokeWidth: 0.25, stroke: "red")
        // text origin dot
        s.svgAddCircle(cx: baselineX, cy: opticalsY, r: 2.0, stroke: "magenta", strokeWidth: 0.5)

        
        // Text String
        s.svgAddText(text: text, x: baselineX, y: opticalsY, fontFamily: font.cgFontFamily, fontSize: font.cgFontSize)
        
        guard let opticals = font.getOpticalRects(string: text) 
            else {
                print("ERROR: getOpticalRects() failed")
                return ""
        }
        
        let opticalsList = opticals.list
        print("opticalsList \(opticalsList)")
        var opticalsX: CGFloat = baselineX
        
        for i in 0 ..< text.count {
            let opticalsRect = opticalsList[i]
            s.svgAddRect(
                x: opticalsX + opticalsRect.origin.x, // origin.x expected to be zero. 
                y: opticalsY - font.ascent(), 
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
            text: "         ascent  \(font.ascent()) max above baseline", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "      capHeight  \(font.capHeight())", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "         decent \(font.decent()) max below baseline", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0 + 16.0
        s.svgAddText(
            text: "FontSize   \(fontSize)       Points/Em     \(fontFamily.rawValue)", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "         \(font.glyphUnitsPerEm())       GlyphUnits/Em", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        s.svgAddText(
            text: "            \(font.pointsPerGlyphUnits()) Points/GlyphUnits", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
        infoY = infoY + 16.0
        infoY = infoY + 16.0
        s.svgAddText(
            text: " leading \(font.leading())", 
            x: infoX, y: infoY, 
            fontFamily: FontHelper.Name.dejaVuMono, fontSize: 12.0)
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
    
}
