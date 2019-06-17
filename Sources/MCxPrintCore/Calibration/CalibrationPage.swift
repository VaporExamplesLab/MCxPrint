//
//  CalibrationPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct CalibrationPage {
        
    static func svg() -> String {
        // letter = NSRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        // 612.0 ÷ 72 = 8.5; 792.0 ÷ 72 = 11.0
        let wxh: NSRect = PrintTemplate.PaperPointRect.letter
        let gcWidth = wxh.width
        let gcHeight = wxh.height
        
        let originX = 0.20 * gcWidth
        let originY = 0.20 * gcHeight
        let centerX = 0.50 * gcWidth
        let centerY = 0.50 * gcHeight
        let oneInch: CGFloat = 72.0

        var s = ""
        
        // square inch box
        s.svgAddRect(x: 0, y: 0, width: 72, height: 72)

        // page box
        s.svgAddRect(x: 0, y: 0, width: gcWidth, height: gcHeight)
        s.svgAddRect(
            x: 0.0 + oneInch,
            y: 0.0 + oneInch,
            width: gcWidth - (2.0 * oneInch),
            height: gcHeight - (2.0 * oneInch)
        )

        // origin dot
        s.svgAddCircle(cx: originX, cy: originY, r: 1.0, stroke: "Black", strokeWidth: 1.0, fill: "Black")
        s.svgAddCircle(cx: centerX, cy: centerY, r: 1.0, stroke: "Black", strokeWidth: 1.0, fill: "Black")

        s.svgWrapTag(w: gcWidth, h: gcHeight, standalone: true)
        
        return s
    }
    
}
