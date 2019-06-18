//
//  FontMetric.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.17.
//

import Foundation

/// Provides metrics for a specific font.
///
/// `font_size = N_points / em`
///
/// `(N_points / em) / (glyph_units / em) = N_points / glyph_units`
///
internal struct FontMetric {
    
    let cgFont: CGFont
    let cgFontSize: CGFloat
    private let ctFont: CTFont
    
    init(fontFamily: FontHelper.Name, fontSize: CGFloat) throws {
        self.cgFontSize = fontSize
        let cfsFontName: CFString = fontFamily.rawValue as CFString
        
        // Use either the font's PostScript name or full name
        if let font = CGFont(cfsFontName) {
            self.cgFont = font
            self.ctFont = CTFontCreateWithGraphicsFont(
                font,     // graphicsFont: CGFont
                fontSize, // size: CGFloat. 0.0 defaults to 12.0
                nil,      // matrix: UnsafePointer<CGAffineTransforms>?
                nil       // attributes: CTFontDescriptor?
            )
        }
        else {
            throw MCxPrint.Error.fontNotFound
        }
    }
    
    /// - Returns: font space values
    func getAdvances(string: String) -> (width: CGFloat, sizes: [CGSize])? {
        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        guard CTFontGetGlyphsForCharacters(
            ctFont, // font: CTFont
            &unichars, // characters: UnsafePointer<UniChar>
            &glyphs, // UnsafeMutablePointer<CGGlyph>
            unichars.count // count: CFIndex
            )
            else {
                return nil
        }
        let glyphsCount = glyphs.count
        
        var advances = [CGSize](repeating: CGSize(width: 0.0, height: 0.0), count: glyphsCount)
        let width: Double = CTFontGetAdvancesForGlyphs(
            ctFont,      // font: CTFont
            .horizontal, // orientation: CFFontOrientation
            glyphs,      // glyphs: UnsafePointer<CGGlyph>
            &advances,   // advances: UnsafeMutablePointer<CGSize>?
            glyphsCount  // count: CFIndex
        )
        
        return (width: CGFloat(width), sizes: advances)
    }
    
    func getBoundingRects(string: String) -> (overall: CGRect, list: [CGRect])? {
        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        guard CTFontGetGlyphsForCharacters(
            ctFont, // font: CTFont
            &unichars, // characters: UnsafePointer<UniChar>
            &glyphs, // UnsafeMutablePointer<CGGlyph>
            unichars.count // count: CFIndex
            )
            else {
                return nil
        }
        let glyphsCount = glyphs.count
        
        var boundingRects = [CGRect](repeating: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), count: glyphsCount)
        // Result: font design metrics transformed into font space.
        let boundingBox = CTFontGetBoundingRectsForGlyphs(
            ctFont,         // font: CTFont
            .horizontal,    // orientation: CFFontOrientation
            glyphs,         // glyphs: UnsafePointer<CGGlyph>
            &boundingRects, // boundingRects: UnsafeMutablePointer<CGRect>?
            glyphsCount     // count: CFIndex
        )
        return (overall: boundingBox, list: boundingRects)
    }
    
    func getGlyphs(string: String) -> [CGGlyph]? {
        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        guard CTFontGetGlyphsForCharacters(
            ctFont, // font: CTFont
            &unichars, // characters: UnsafePointer<UniChar>
            &glyphs, // UnsafeMutablePointer<CGGlyph>
            unichars.count // count: CFIndex
            )
            else {
                return nil
        }
        
        return glyphs
    }
    
    func getOpticalRects(string: String) -> (overall: CGRect, list: [CGRect])? {
        var unichars = [UniChar](string.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        guard CTFontGetGlyphsForCharacters(
            ctFont, // font: CTFont
            &unichars, // characters: UnsafePointer<UniChar>
            &glyphs, // UnsafeMutablePointer<CGGlyph>
            unichars.count // count: CFIndex
            )
            else {
                return nil
        }
        let glyphsCount = glyphs.count
        
        let options: CFOptionFlags = 0 // Reserved, set to zero.
        var opticalRects = [CGRect](repeating: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0), count: glyphsCount)
        let opticalBox = CTFontGetOpticalBoundsForGlyphs(
            ctFont,        // font: CTFont
            glyphs,        // glyphs: UnsafePointer<CGGlyph>
            &opticalRects, // boundingRects: UnsafeMutablePointer<CGRect>?
            glyphsCount,   // count: CFIndex
            options        // options: CFOptionFlags aka UInt
        )
        
        return (overall: opticalBox, list: opticalRects)
    }
    
    /// ascent: max distance above baseline in points
    func ascent() -> CGFloat {
        let ascentGlyphUnits = CGFloat(cgFont.ascent)
        return ascentGlyphUnits * pointsPerGlyphUnits()
    }
    
    /// descent: max distance below baseline in points
    func decent() -> CGFloat {
        let descentGlyphUnits = CGFloat(cgFont.descent)
        return descentGlyphUnits * pointsPerGlyphUnits()
    }
    
    /// leading: spacing between consecutive text lines in points
    func leading() -> CGFloat {
        let leadingGlyphUnits = CGFloat(cgFont.leading)
        return leadingGlyphUnits * pointsPerGlyphUnits()
    }
    
    /// capHeight: distance baseline to flat capital letters top
    func capHeight() -> CGFloat {
        let capHeightGlyphUnits = CGFloat(cgFont.capHeight)
        return capHeightGlyphUnits * pointsPerGlyphUnits()
    }
    
    /// xHeight: distance baseline to top of flat, non-ascending lowercase letters (e.g. "x")
    func xHeight() -> CGFloat {
        let xHeightGlyphUnits = CGFloat(cgFont.xHeight)
        return xHeightGlyphUnits * pointsPerGlyphUnits()
    }
    
    /// italicAngle: degrees counter-clockwise from the vertical
    func italicAngle() -> CGFloat {
        return cgFont.italicAngle
    }

    /// - Returns: glyph units/em
    func glyphUnitsPerEm() -> CGFloat {
        return CGFloat(cgFont.unitsPerEm)
    }
    
    /// - Returns: font points per glyph units
    func pointsPerGlyphUnits() -> CGFloat {
        return cgFontSize / glyphUnitsPerEm()
    }
    
    func showCharacters(string: String) {
        let cfStr = string as CFString
        let range = CFRange(location: 0, length: string.utf16.count)
        var buffer = [UniChar](repeating: 0, count: string.utf16.count)
        CFStringGetCharacters(
            cfStr,  // theString: CFString!
            range,  // range: CFRange
            &buffer // buffer: UnsafeMutablePointer<UniChar>!
        )
        
        var i = 0
        for idx in string.indices {
            let unichar: UniChar = buffer[i] // UInt16
            let hexcode = String(format: "%04x", unichar)
            let character: Character = string[idx]
            
            let s = String(character)
            let utf8CCharArray = s.utf8CString
            var utf8Str = ""
            for i in 0 ..< utf8CCharArray.count-1 { // -1 ignores null terminator
                let cchar: CChar = utf8CCharArray[i] // Int8
                if cchar >= 0 {
                    utf8Str.append(String(format: "%2x ", cchar) )
                }
                else {
                    // suffix(3) includes trailing space
                    utf8Str.append(String(String(format: "%2x ", cchar).suffix(3)) )
                }
            }
            
            print("Unicode U+\(hexcode) UTF8 \(utf8Str) '\(character)'")
            
            i = i + 1
        }
    }
    
    func showFontInfo() {
        // public typealias CGGlyph = CGFontIndex = UInt16
        
        let cfStringDefault = "nil" as CFString
        for i in 0 ..< 10 {
            let glyphName = cgFont.name(for: CGGlyph(i))
            print("[\(i)] \(glyphName ?? cfStringDefault)")
        }
        
        
        // Glyph count: 3,377 (expected & actual)
        print("cgFont.numberOfGlyphs=\(cgFont.numberOfGlyphs)")
        
        print("canCreatePostScriptSubset aka `CGFontPostScriptFormat.type*`")
        print("   type1: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type1))")
        print("   type3: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type3))")
        print("  type42: \(cgFont.canCreatePostScriptSubset(CGFontPostScriptFormat.type42))")
    }
    
}
