//
//  FontMetricsPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct FontMetricsPage {
    
    let fontFamily = FontHelper.Name.dejaVuMono
    let fontSize: CGFloat = 48.0
    let lineWidth: CGFloat = 1.0
    
    let page: CGRect = PrintTemplate.PaperPointRect.letter
    let oneInch: CGFloat = 72.0
    
    func svg() -> String {        
        let baselineX = 0.15 * page.width
        let baselineY = 0.25 * page.height

        var s = ""
        s = addPageRegistration(s)
        
        let font = try! FontMetric(
            fontFamily: fontFamily,
            fontSize: fontSize)
        let text = "MQ.01Ofj⌘"
        font.showCharacters(string: text)
        
        s.svgAddText(text: text, x: baselineX, y: baselineY, fontFamily: fontFamily, fontSize: fontSize)
        // text origin line
        s.svgAddLine(x1: 0, y1: baselineY, x2: page.width, y2: baselineY, strokeWidth: 0.25, stroke: "red")
        // text origin dot
        s.svgAddCircle(cx: baselineX, cy: baselineY, r: 2.0, stroke: "magenta", strokeWidth: 0.5)

        // text advances
        if let advances = font.getAdvances(string: text) {
            var x: CGFloat = baselineX
            for size in advances.sizes {
                s.svgAddLine(
                    x1: x, y1: baselineY - font.ascent(),
                    x2: x, y2: baselineY - font.decent())
                x = x + size.width
            }
            s.svgAddLine(
                x1: x, y1: baselineY - font.ascent(),
                x2: x, y2: baselineY - font.decent())
        }
        
        if let psName = font.cgFont.postScriptName {
            print("postScriptName: \(psName)")
        }
        else {
            print("postScriptName: NOT_FOUND")
        }
        
        print("font.ascent() \(font.ascent()) max above baseline")
        print("font.capHeight() \(font.capHeight())")
        print("font.decent() \(font.decent()) max below baseline")
        print("font.glyphUnitsPerEm() \(font.glyphUnitsPerEm())")
        print("font.pointsPerGlyphUnits() \(font.pointsPerGlyphUnits())")
        print("font.leading() \(font.leading())")

        s.svgWrapTag(w: page.width, h: page.height, standalone: true)
        
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
