//
//  CalibrationPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public struct CalibrationPage {
        
    public static func svg() -> String {
        // letter = CGRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        // 612.0 ÷ 72 = 8.5; 792.0 ÷ 72 = 11.0
        let wxh: CGRect = PrintTemplate.PaperPointRect.letter
        let gcWidth = wxh.width
        let gcHeight = wxh.height
        
        let text = "0 DejaVu Sans Mono 12px (default) 1"
        
        let side: CGFloat = 72.0
        
        var middleSquare = ""
        middleSquare.svgAddRect(x: 0, y: 0, width: side, height: side)
        middleSquare.svgWrapGroup(translate: (x: gcWidth/2 - side/2, y: gcHeight/2 - side/2))
        
        var s = ""
        s.svgAddLine(x1: 0, y1: 0, x2: gcWidth, y2: gcHeight)
        s.svgAddLine(x1: 0, y1: gcHeight, x2: gcWidth, y2: 0)
        s.svgAddRect(x: 0, y: 0, width: gcWidth, height: gcHeight)
        s.svgAddRect(x: 0, y: 0, width: 72, height: 72)
        s.svgAddText(text: text, x: 72, y: 72)
        s.svgAddRect(x: gcWidth - 72, y: gcHeight - 72, width: gcWidth, height: gcHeight)
        
        s.svgAddLine(x1: gcWidth/2, y1: 0, x2: gcWidth/2, y2: gcHeight)
        s.svgAddLine(x1: 0, y1: gcHeight/2, x2: gcWidth, y2: gcHeight/2)
        s.svgAddCircle(cx: gcWidth/2, cy: gcHeight/2, r: 72)
        s.svgAddCircle(cx: gcWidth/2, cy: gcHeight/2, r: 144)
        s.svgAddCircle(cx: gcWidth/2, cy: gcHeight/2, r: 288)
        
        s.append(middleSquare)
        
        s.svgWrapSvgTag(w: gcWidth, h: gcHeight)
        s.htmlWrapMinimal()
        
        print("• CalibrationPage svg()\n\(s)")
        return s
    }
    
}
