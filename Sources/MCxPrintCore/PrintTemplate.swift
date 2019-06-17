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
        static let card3x5 = NSRect(x: 0.0, y: 0.0, width: 216.0, height: 360.0)
        static let card3x5Landscape = NSRect(x: 0.0, y: 0.0, width: 360.0, height: 216.0)
        static let card4x6 = NSRect(x: 0.0, y: 0.0, width: 288.0, height: 432.0)
        static let card4x6Landscape = NSRect(x: 0.0, y: 0.0, width: 432.0, height: 288.0)
        // *PageSize Letter/US Letter: [612.00 792.00]
        // *PageSize Letter.NMgn/US Letter Borderless, Auto Expand: [612.00 792.00], cupsBorderlessScalingFactor 1.03
        // *PageSize Letter.4SideNMgnRet/US Letter Borderless, Retain Size: [626.40 811.80]
        // *ImageableArea Letter/US Letter: "9.00 9.00 603.00 783.00"
        static let letter = NSRect(x: 0.0, y: 0.0, width: 612.0, height: 792.0)
        static let letterLandscape = NSRect(x: 0.0, y: 0.0, width: 792.0, height: 612.0)
        // *PageSize 24mm/0.94":      [ 68, 198.4]/ImagingBBox
        // *ImageableArea 24mm/0.94": [2  2.8  66  195.6]
        //static let ptouch = NSRect(x: 0.0, y: 0.0, width: 68.0, height: 198.4)
        //static let ptouchLandscape = NSRect(x: 0.0, y: 0.0, width: 198.4, height: 68.0)
        // 198.4 points = 2.7555 in = 69.991 mm, 68.0 points = 0.94444 inch = 23.989 mm
        // 240.0 points = 3.3333 in = 8.4667 mm
        static let ptouchPortrait = NSRect(x: 0.0, y: 0.0, width: 68.0, height: 240.0)
        static let ptouchLandscape = NSRect(x: 0.0, y: 0.0, width: 240.0, height: 68.0)
    }
    
    /// :WIP:
    public static func research(fontFamily: FontHelper.Name, fontSize: CGFloat) {
        printStdout("• PrintTemplate.research()")
        // :!!!:WIP: Typography CGSize sizeWithAttributes
        //let value_Double = 2.4
        //let cgFloat = CGFloat(value_Double)
        //let cgSize = CGSize(width: cgFloat, height: cgFloat)
        //let cgSizeD = CGSize(width: 3.1, height: 2.3) // Double, Double
        
        //let string = "Hello"
        //let nsString = NSString(string: "Hello")
        
        printCGFontInfo(fontFamily: fontFamily, fontSize: fontSize)
        
    }
    
    // https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/CoreText_Programming/FontOperations/FontOperations.html#//apple_ref/doc/uid/TP40005533-CH4-SW12
    
    // https://github.com/sanderfrenken/MoreSpriteKit/blob/d0c35585fb8b156d38d97a1f4586d8402bded12b/MoreSpriteKit/UIBezierPath%2BCharacter.swift
    
    // https://developer.apple.com/documentation/coretext/1508745-ctfontcreatewithgraphicsfont
    public static func getStringWidth(fontFamily: FontHelper.Name, fontSize: CGFloat) {
        let cfsFontName: CFString = fontFamily.rawValue as CFString
        let cfsFontSize: CGFloat = fontSize
        
        // Use either the font's PostScript name or full name
        guard let cgFont = CGFont(cfsFontName) else {
            return
        }

        let ctFont: CTFont = CTFontCreateWithGraphicsFont(
            cgFont,      // graphicsFont: CGFont
            cfsFontSize, // size: CGFloat. 0.0 defaults to 12.0
            nil, // matrix: UnsafePointer<CGAffineTransforms>?
            nil  // attributes: CTFontDescriptor?
        )
        
        
        // Return the glyph space units/em for `font'.
        print("fontname=\(cfsFontName)")
        print("fontsize=\(cfsFontSize) points")
        print("cgFont.unitsPerEm=\(cgFont.unitsPerEm)")
        let str = "MQ.10" // Hello
        print("str=\(str)")
        
        //
        let cfStr = str as CFString
        let range = CFRange(location: 0, length: str.utf16.count)
        var buffer = [UniChar](repeating: 0, count: str.utf16.count)
        CFStringGetCharacters(
            cfStr,  // theString: CFString!
            range,  // range: CFRange
            &buffer // buffer: UnsafeMutablePointer<UniChar>!
        )
        
        var i = 0
        for idx in str.indices {
            let unichar: UniChar = buffer[i] // UInt16
            let character = str[idx]
            let hexcode = String(format: "%04x", unichar)
            print("Unicode \(unichar) U+\(hexcode) '\(character)'")
            i = i + 1
        }

        
        var unichars = [UniChar](str.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)

        guard CTFontGetGlyphsForCharacters(
            ctFont, // font: CTFont
            &unichars, // characters: UnsafePointer<UniChar>
            &glyphs, // UnsafeMutablePointer<CGGlyph>
            unichars.count // count: CFIndex
            )
            else {
            return
        }

        let glyphsCount = glyphs.count
        var advances = [CGSize](repeating: CGSize(width: 0.0, height: 0.0), count: glyphsCount)
        let width = CTFontGetAdvancesForGlyphs(
            ctFont,      // font: CTFont
            .horizontal, // orientation: CFFontOrientation
            glyphs,      // glyphs: UnsafePointer<CGGlyph>
            &advances,   // advances: UnsafeMutablePointer<CGSize>?
            glyphsCount  // count: CFIndex
        )
        print("width=\(width) font space")
        print("advances=\(advances) font space")

        var boundingRects = [CGRect](repeating: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), count: glyphsCount)
        // Result: font design metrics transformed into font space.
        let boundingBox = CTFontGetBoundingRectsForGlyphs(
            ctFont,         // font: CTFont
            .horizontal,    // orientation: CFFontOrientation
            glyphs,         // glyphs: UnsafePointer<CGGlyph>
            &boundingRects, // boundingRects: UnsafeMutablePointer<CGRect>?
            glyphsCount     // count: CFIndex
        )
        print("boundingBox=\(boundingBox)")
        print("boundingRects=\(boundingRects)")
        
        print("boundingBox.height=\(boundingBox.height)")
        print("boundingBox.width=\(boundingBox.width)")
        print("boundingBox.size (WxH)=\(boundingBox.size)")

        print("boundingBox.origin.x=\(boundingBox.origin.x)")
        print("boundingBox.origin.y=\(boundingBox.origin.y)")

        let options: CFOptionFlags = 0 // Reserved, set to zero.
        var opticalRects = [CGRect](repeating: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), count: glyphsCount)
        let opticalBox = CTFontGetOpticalBoundsForGlyphs(
            ctFont,        // font: CTFont
            glyphs,        // glyphs: UnsafePointer<CGGlyph>
            &opticalRects, // boundingRects: UnsafeMutablePointer<CGRect>?
            glyphsCount,   // count: CFIndex
            options        // options: CFOptionFlags aka UInt
        )
        print("opticalBox=\(opticalBox)")
        print("opticalRects=\(opticalRects)")
        
        
    }
    
    //width=43.34765625   =6*7.224609375
    //advances=[
    //  (7.224609375, 0.0),  H
    //  (7.224609375, 0.0),  e
    //  (7.224609375, 0.0),  l
    //  (7.224609375, 0.0),  l
    //  (7.224609375, 0.0),  o
    //  (7.224609375, 0.0)   !
    //]
    //
    //
    //          (x,           y,            width,       height   )
    //boundingBox=(0.720703125, -0.169921875, 5.794921875, 9.3515625)
    //boundingRects=[
    //  (0.802734375,  0.0,         5.619140625, 8.748046875),  H
    //  (0.720703125, -0.169921875, 5.794921875, 6.890625   ),  e
    //  (0.9375,       0.0,         5.12109375,  9.181640625),  l
    //  (0.9375,       0.0,         5.12109375,  9.181640625),  l
    //  (0.802734375, -0.169921875, 5.619140625, 6.890625   ),  o
    //  (3.0234375,    0.0,         1.189453125, 8.748046875)   !
    //]
    //
    //boundingBox.height=     9.3515625
    //boundingBox.width=      5.794921875
    //boundingBox.size.height=9.3515625
    //boundingBox.size.width= 5.794921875
    //
    //boundingBox.origin.x=0.720703125
    //boundingBox.origin.y=-0.169921875
    //boundingBox.standardized.height=9.3515625
    //boundingBox.standardized.width=5.794921875
    //
    //opticalBox=(0.0, -2.830078125, 7.224609375, 13.96875)
    //opticalRects=[
    //  (0.0, -2.830078125, 7.224609375, 13.96875),  H
    //  (0.0, -2.830078125, 7.224609375, 13.96875),  e
    //  (0.0, -2.830078125, 7.224609375, 13.96875),  l
    //  (0.0, -2.830078125, 7.224609375, 13.96875),  l
    //  (0.0, -2.830078125, 7.224609375, 13.96875),  o
    //  (0.0, -2.830078125, 7.224609375, 13.96875)   !
    //]

    // https://developer.apple.com/fonts/TrueType-Reference-Manual/RM06/Chap6opbd.html
 
    
    public static func printCGFontInfo(fontFamily: FontHelper.Name, fontSize: CGFloat) {
        let cfsFontName: CFString = fontFamily.rawValue as CFString
        
        // Use either the font's PostScript name or full name
        guard let cgFont = CGFont(cfsFontName) else {
            return
        }
        
        // public typealias CGGlyph = CGFontIndex = UInt16
        print("typealias CGGlyph = CGFontIndex = UInt16")
        
        let cfStringDefault = "nil" as CFString
        for i in 0 ..< 10 {
            let glyphName = cgFont.name(for: CGGlyph(i))
            print("[\(i)] \(glyphName ?? cfStringDefault)")
        }
    
        
        // `CGGlyph` for the glyph name associated with the specified font object, else 0 (nil)
//        cgFont.getGlyphWithGlyphName(name: <#T##CFString#>)
//        // Advance width of each glyph in the provided array, else false
//        cgFont.getGlyphAdvances(glyphs: <#T##UnsafePointer<CGGlyph>#>, count: <#T##Int#>, advances: <#T##UnsafeMutablePointer<Int32>#>)
//
//        // Bounding box of each glyph in an array, else false
//        cgFont.getGlyphBBoxes(glyphs: <#T##UnsafePointer<CGGlyph>#>, count: <#T##Int#>, bboxes: <#T##UnsafeMutablePointer<CGRect>#>)
//
//        cgFont.name(for: <#T##CGGlyph#>)
        
        // :???: cgFont.tableTags
        // :???: cgFont.table(for: <#T##UInt32#>)
        
        
        // Glyph count: 3,377 (expected & actual)
        print("cgFont.numberOfGlyphs=\(cgFont.numberOfGlyphs)")
        
        print("canCreatePostScriptSubset aka `CGFontPostScriptFormat.type*`")
        print("   type1: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type1))")
        print("   type3: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type3))")
        print("  type42: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type42))")
        
        
        // Return the glyph space units/em for `font'.
        print("cgFont.unitsPerEm=\(cgFont.unitsPerEm)")
        
        // Each variation axis dictionary contains values for the variation axis keys listed below.
        // RESULT: nil
        print("cgFont.variationAxes=\(String(describing: cgFont.variationAxes))")
        
        // RESULT: nil
        print("cgFont.variations=\(String(describing: cgFont.variations))")
        
        ///////////////////////
        // Glyph Space Units //
        ///////////////////////
        
        // ascent: max distance above glyph baseline in glyph space units
        print("cgFont.ascent=\(cgFont.ascent)")
        // descent: max distance below glyph baseline in glyph space units
        print("cgFont.descent=\(cgFont.descent)")
        // leading: spacing between consecutive lines of text in a font
        print("cgFont.leading=\(cgFont.leading)")
        // capHeight: distance baseline to flat capital letters top
        print("cgFont.capHeight=\(cgFont.capHeight)")
        // xHeight: distance baseline to top of flat, non-ascending lowercase letters (e.g. "x")
        print("cgFont.xHeight=\(cgFont.xHeight)")
        
        // italicAngle: degrees counter-clockwise from the vertical
        print("cgFont.italicAngle=\(cgFont.italicAngle)")
        // stemV: thickness of the dominant vertical stems
        print("cgFont.stemV=\(cgFont.stemV)")
        
        // The union of all of the bounding boxes for all the glyphs in a font.
        // The value is specified in glyph space units.
        print("cgFont.fontBBox=\(cgFont.fontBBox)")

    }
    
    /// ##8##
    public static func generateSvgTagBookAlignment(rect: NSRect, text: String) -> String {
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
        
        s.svgWrapTag(w: w, h: h)
        
        s.htmlWrapMinimal()
        
        print("PrintTemplate.generatedSvgTagBookAlignment()\n\(s)")
        return s
    }
    

}
