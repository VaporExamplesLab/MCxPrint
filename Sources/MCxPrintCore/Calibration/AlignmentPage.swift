//
//  AlignmentPage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.16.
//

import Foundation

public struct AlignmentPage {
    
    public static func svg(rect: NSRect, text: String) -> String {
        return AlignmentPage.svg(width: rect.width, height: rect.height, text: text)
    }
    
    public static func svg(width gcWidth: CGFloat, height gcHeight: CGFloat, text: String) -> String {
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
        
        s.svgWrapTag(w: gcWidth, h: gcHeight)
        s.htmlWrapMinimal()
        
        print("• PrintTemplate.generateTestSvg()\n\(s)")
        return s
    }
}
