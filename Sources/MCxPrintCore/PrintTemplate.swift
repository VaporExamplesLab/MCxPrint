//
//  PrintTemplate.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.11.
//

import Foundation

/// Forked from PrintSampler_macOS PrintTemplate
public class PrintTemplate {
    
    // Custom Paper Point Size
    public struct PaperPointRect {
        static let card3x5 = CGRect(x: 0.0, y: 0.0, width: 216.0, height: 360.0)
        static let card3x5Landscape = CGRect(x: 0.0, y: 0.0, width: 360.0, height: 216.0)
        static let card4x6 = CGRect(x: 0.0, y: 0.0, width: 288.0, height: 432.0)
        static let card4x6Landscape = CGRect(x: 0.0, y: 0.0, width: 432.0, height: 288.0)
        // *PageSize Letter/US Letter: [612.00 792.00]
        // *PageSize Letter.NMgn/US Letter Borderless, Auto Expand: [612.00 792.00], cupsBorderlessScalingFactor 1.03
        // *PageSize Letter.4SideNMgnRet/US Letter Borderless, Retain Size: [626.40 811.80]
        // *ImageableArea Letter/US Letter: "9.00 9.00 603.00 783.00"
        static let letter = CGRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        static let letterLandscape = CGRect(x: 0.0, y: 0.0, width: 792.0, height: 612.0)
        // *PageSize 24mm/0.94":      [ 68, 198.4]/ImagingBBox
        // *ImageableArea 24mm/0.94": [2  2.8  66  195.6]
        //static let ptouch = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 198.4)
        //static let ptouchLandscape = CGRect(x: 0.0, y: 0.0, width: 198.4, height: 68.0)
        // 198.4 points = 2.7555 in = 69.991 mm, 68.0 points = 0.94444 inch = 23.989 mm
        // 240.0 points = 3.3333 in = 84.6658 8.4667 mm
        static let ptouchPortrait = CGRect(x: 0.0, y: 0.0, width: 68.0, height: 240.0)
        static let ptouchLandscape = CGRect(x: 0.0, y: 0.0, width: 240.0, height: 68.0)
        /// Avery 5027 1/3 cut extra large 3-7/16"x15/16"  18/sheet
        /// 3.4375 x 0.9375 inch = 87.3125 x 23.8125 mm = 247.5 x 67.5 points
        static let avery5027 = CGRect(x: 0.0, y: 0.0, width: 247.0, height: 66.0)
    }
        
    /// ##8##
    public static func generateSvgTagBookAlignment(rect: CGRect, text: String) -> String {
        return generatedSvgTagBookAlignment(width: rect.width, height: rect.height, text: text)
    }
    public static func generatedSvgTagBookAlignment(width w: CGFloat, height h: CGFloat, text: String) -> String {
        let side: CGFloat = 72.0 / 2
        
        var s = ""
        // Centered "X"
        s.svgAddLine(x1: 0, y1: 0, x2: w, y2: h)
        s.svgAddLine(x1: 0, y1: h, x2: w, y2: 0)
        
        // Centered Circle
        s.svgAddCircle(cx: w/2, cy: h/2, r: 72.0 / 2)
        
        // Border Rectangle
        s.svgAddRect(x: 0, y: 0, width: w, height: h)
        
        // Centered Square
        var middleSquare = ""
        middleSquare.svgAddRect(x: 0, y: 0, width: side, height: side)
        middleSquare.svgWrapGroup(translate: (x: w/2 - side/2, y: h/2 - side/2))
        s.append(middleSquare)
        
        // Upper Right Box and Text
        let edge: CGFloat = 72.0 / 4
        s.svgAddRect(x: 0, y: 0, width: edge, height: edge)
        s.svgAddText(text: text, x: edge, y: edge)
        
        s.svgWrapSvgTag(w: w, h: h)
        
        s.htmlWrapMinimal()
        
        print("PrintTemplate.generatedSvgTagBookAlignment()\n\(s)")
        return s
    }
    

}
