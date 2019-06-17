//
//  FontMetricsPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct FontMetricsPage {
    
    let fontFamily = FontHelper.Name.dejaVuSans
    let fontSize: CGFloat = 72.0
    
    func svg() -> String {
        // letter = NSRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        // 612.0 ÷ 72 = 8.5; 792.0 ÷ 72 = 11.0
        
        PrintTemplate.research(fontFamily: fontFamily, fontSize: fontSize)
        PrintTemplate.getStringWidth(fontFamily: fontFamily, fontSize: fontSize)

        let wxh: NSRect = PrintTemplate.PaperPointRect.letter
        let gcWidth = wxh.width
        let gcHeight = wxh.height
        
        let originX = 0.15 * gcWidth
        let originY = 0.25 * gcHeight
        let centerX = 0.50 * gcWidth
        let centerY = 0.50 * gcHeight
        let oneInch: CGFloat = 72.0

        var s = ""
        
        // page box
        s.svgAddRect(x: 0, y: 0, width: gcWidth, height: gcHeight, stroke: "black", strokeWidth: 0.25)
        // page box inset 1"
        s.svgAddRect(
            x: 0.0 + oneInch,
            y: 0.0 + oneInch,
            width: gcWidth - (2.0 * oneInch),
            height: gcHeight - (2.0 * oneInch),
            stroke: "black",
            strokeWidth: 0.25
        )

        // page registration
        s.svgAddRect(x: 0.0, y: 0.0, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: 0.0, y: wxh.height-oneInch, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: wxh.width-oneInch, y: 0.0, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)
        s.svgAddRect(x: wxh.width-oneInch, y: wxh.height-oneInch, width: oneInch, height: oneInch, stroke: "black", strokeWidth: 0.25)

        // center dot
        s.svgAddCircle(cx: centerX, cy: centerY, r: 1.0, stroke: "black", strokeWidth: 1.0, fill: "black")
        
        s.svgAddText(text: "MQ.01", x: originX, y: originY, fontFamily: fontFamily, fontSize: fontSize)
        // text origin line
        s.svgAddLine(x1: 0, y1: originY, x2: wxh.width, y2: originY, strokeWidth: 0.25, stroke: "red")
        // text origin dot
        s.svgAddCircle(cx: originX, cy: originY, r: 2.0, stroke: "magenta", strokeWidth: 0.5)

        // text optical box
        // opticalBox=(0.0, -16.98046875, 43.34765625, 83.8125) x, y, width, height
        s.svgAddRect(x: originX + 0.0, y: originY - 16.980, width: 43.34765, height: 83.8125, stroke: "blue", strokeWidth: 0.25)

        s.svgWrapTag(w: gcWidth, h: gcHeight, standalone: true)
        
        return s
    }
}
