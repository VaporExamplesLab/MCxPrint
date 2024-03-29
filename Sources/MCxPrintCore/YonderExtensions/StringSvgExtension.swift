//
//  StringSvgExtension.swift
//  MCxPrintCore
//
// Forked from PrintSampler_macOS StringSvgExtend.swift
//
//  Created by marc on 2019.06.11.
//

import Foundation


public extension String {
    
    mutating func svgAdd(svg: String) {
        self.append(svg + "\n")
    }
    
    mutating func svgAddCircle(
        cx: Double, cy: Double, r: Double,
        stroke: String? = nil,
        strokeWidth: Double? = nil,   // default: 1.0
        strokeOpacity: Double? = nil, // default: 1.0
        fill: String? = nil,         //
        fillOpacity: Double? = nil    // 0.0 if
        ) {
        svgAddCircle(
            cx: CGFloat(cx),
            cy: CGFloat(cy),
            r: CGFloat(r),
            stroke: stroke,
            strokeWidth: strokeWidth != nil ? CGFloat(strokeWidth!) : nil,     // default: 1.0
            strokeOpacity: strokeWidth != nil ? CGFloat(strokeOpacity!) : nil, // default: 1.0
            fill: fill,                            //
            fillOpacity: strokeWidth != nil ? CGFloat(fillOpacity!) : nil      // 0.0 if
        )
    }
    
    mutating func svgAddCircle(
        cx: Float, cy: Float, r: Float,
        stroke: String? = nil,
        strokeWidth: Float? = nil,   // default: 1.o
        strokeOpacity: Float? = nil, // default: 1.0
        fill: String? = nil,         //
        fillOpacity: Float? = nil    // 0.0 if
        ) {
        svgAddCircle(
            cx: CGFloat(cx),
            cy: CGFloat(cy),
            r: CGFloat(r),
            stroke: stroke,
            strokeWidth: strokeWidth != nil ? CGFloat(strokeWidth!) : nil,     // default: 1.0
            strokeOpacity: strokeWidth != nil ? CGFloat(strokeOpacity!) : nil, // default: 1.0
            fill: fill,                            //
            fillOpacity: strokeWidth != nil ? CGFloat(fillOpacity!) : nil      // 0.0 if
        )
    }
    
    /// \<circle /\>
    ///
    /// [see MDN \<circle\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/circle)
    ///
    /// - parameters:
    ///     - cx: X center (pixels)
    ///     - cy: Y center (pixels)
    ///     - r: radius (pixels)
    ///     - stroke: pixels
    ///     - strokeWidth: pixels
    ///     - strokeOpacity: pixels
    ///     - fill: pixels
    ///     - fillOpacity: pixels
    mutating func svgAddCircle(
        cx: CGFloat, cy: CGFloat, r: CGFloat,
        stroke: String? = nil,
        strokeWidth: CGFloat? = nil,   // default: 1.o
        strokeOpacity: CGFloat? = nil, // default: 1.0
        fill: String? = nil,          //
        fillOpacity: CGFloat? = nil   // 0.0 if
        ) {
        
        var style = ""
        
        // -- stroke --
        if stroke == nil && strokeWidth == nil && strokeOpacity == nil {
            style.append("stroke:black;")
        }
        else {
            if let s = stroke {
                style.append("stroke:\(s);")
            }
            if let sw = strokeWidth {
                style.append("stroke-width:\(sw);")
            }
            if let so = strokeOpacity {
                style.append("stroke-opacity:\(so);")
            }
        }
        
        // -- fill --
        if fill == nil && fillOpacity == nil {
            style.append("fill-opacity:0.0;")
        }
        else {
            if let f = fill {
                style.append("fill:\(f);")
            }
            if let fo = fillOpacity {
                style.append("fill-opacity:\(fo);")
            }
        }
        
        style = "style=\"" + style + "\""
        
        self.append("<circle cx=\"\(cx)\" cy=\"\(cy)\" r=\"\(r)\" \(style) /> \n")
    }
    
    /// \<ellipse /\>
    ///
    /// [see MDN \<ellipse\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/ellipse)
    ///
    
    
    /// \<line /\>
    ///
    /// [see MDN \<line\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/line)
    ///
    /// - parameters:
    ///     - x1: pixels
    ///     - y1: pixels
    ///     - x2: pixels
    ///     - y2: pixels
    ///     - strokeWidth: pixels
    ///     - stroke: String. black, blue, red
    ///     - transform: String. e.g. "rotate(-45 20 100)"
    mutating func svgAddLine(
        x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat,
        strokeWidth: CGFloat = 1.0, // Int = 1
        stroke: String = "black",
        transform: String = ""
        ) {
        self.append("<line x1=\"\(x1)\" y1=\"\(y1)\" x2=\"\(x2)\" y2=\"\(y2)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\" ")
        if !transform.isEmpty {
            self.append("transform=\"\(transform)\" ")
        }
        self.append("/> \n")
    }
    
    // polygon
    
    // path
    
    /// \<rect x="x" y="y" width="width" height="height"/\>
    ///
    /// [see MDN \<rect\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/rect)
    ///
    /// NYI: rx, ry
    ///
    /// - parameters:
    ///     - x: upper pixels
    ///     - y: left pixels
    ///     - width: pixels
    ///     - height: pixels
    ///     - stroke: String
    ///     - strokeWidth: pixels
    ///     - strokeOpacity: pixels
    ///     - fill: String
    ///     - fillOpacity: pixels
    mutating func svgAddRect(
        x: CGFloat, y: CGFloat, width w: CGFloat, height h: CGFloat,
        stroke: String? = nil,
        strokeWidth: CGFloat? = nil,   // default: 1.0
        strokeOpacity: CGFloat? = nil, // default: 1.0
        fill: String? = nil,
        fillOpacity: CGFloat? = nil    // 0.0 if
        ) {
        
        var style = ""
        
        // -- stroke --
        if stroke == nil && strokeWidth == nil && strokeOpacity == nil && fill == nil && fillOpacity == nil {
            // default to a black stroke if no stroke & fill information is provided.
            style.append("stroke:black;")
        }
        else {
            if let s = stroke {
                style.append("stroke:\(s);")
            }
            if let sw = strokeWidth {
                style.append("stroke-width:\(sw);")
            }
            if let so = strokeOpacity {
                style.append("stroke-opacity:\(so);")
            }
        }
        
        // -- fill --
        if fill == nil && fillOpacity == nil {
            style.append("fill-opacity:0.0;")
        }
        else {
            if let f = fill {
                style.append("fill:\(f);")
            }
            if let fo = fillOpacity {
                style.append("fill-opacity:\(fo);")
            }
        }
        
        style = "style=\"" + style + "\""
        
        self.append("<rect x=\"\(x)\" y=\"\(y)\" width=\"\(w)\" height=\"\(h)\" \(style) /> \n")
    }
    
    /// svgAddText \<text x="150" y="125" font-size="60" text-anchor="middle" fill="white"\>SVG\</text\>
    /// \<text x="x" y="y" width="width" height="height"/\>
    /// ```svg
    /// <text
    ///     x="150" y="125"
    ///     font-size="60"
    ///
    ///
    /// ```
    ///
    /// [see MDN \<rect\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)
    ///
    /// fill="rgb(0, 0, 0)"
    /// <text  fill="rgb(0, 0, 0)" font-family="ArialMT, Arial, 'Helvetica Neue', Helvetica, sans-serif" font-size="17" x="38" y="28"><tspan x="38" y="54">Hello, World!</tspan></text>
    ///
    /// - parameters:
    ///     - x: upper pixels
    ///     - y: left pixels
    ///     - fill: String. default: rgb(0, 0, 0) or "white"
    ///     - fontStyles: CSS Font Styles
    ///     - textAnchor: "start", "middle", or "end"
    mutating func svgAddText(
        text: String,
        x: CGFloat,
        y: CGFloat,
        fill: String = "#000000",
        fontFamily: FontHelper.PostscriptName = FontHelper.PostscriptName.dejaVuMono,
        fontSize: CGFloat = 12.0,
        textAnchor: String = "start"
        ) {
        
        let textEncoded = text.filteringToSvgAscii()
        var tagBefore = ""
        var tagAfter = ""
        
        tagBefore.append("<text ")
        tagBefore.append("x=\"\(x)\" y=\"\(y)\" ")
        //tagBefore.append("width=\"\(w)\" height=\"\(h)\" ")
        tagBefore.append("fill=\"\(fill)\" ")

        tagBefore.append("font-family=\"\(fontFamily.rawValue)\" ")
        tagBefore.append("font-size=\"\(fontSize)\" ")

        tagBefore.append("text-anchor=\"\(textAnchor)\" ")

        tagBefore.append(">")
        
        tagAfter.append("</text>\n")
        
        self.append(tagBefore + textEncoded + tagAfter)
    }
    
        
    /// svgAddText \<text x="150" y="125" font-size="60" text-anchor="middle" fill="white"\>SVG\</text\>
    ///
    /// \<text x="x" y="y" width="width" height="height"/\>
    ///
    /// * +x moves "rightward" along the string baseline. 
    /// * +y moves ascends "higher up" relative to the string baseline
    ///
    /// [see MDN \<rect\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/text)
    ///
    /// [see MDN Attribute transform](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform)
    ///
    /// fill="rgb(0, 0, 0)"
    ///
    /// <text  fill="rgb(0, 0, 0)" font-family="ArialMT, Arial, 'Helvetica Neue', Helvetica, sans-serif" font-size="17" x="38" y="28"><tspan x="38" y="54">Hello, World!</tspan></text>
    ///
    /// - parameters:
    ///     - x: upper pixels
    ///     - y: left pixels
    ///     - rotate: degrees
    ///     - fill: String. default: rgb(0, 0, 0) or "white"
    ///     - fontStyles: CSS Font Styles
    mutating func svgAddText(
        text: String,
        x: CGFloat,
        y: CGFloat,
        rotate: CGFloat,
        fill: String = "#000000",
        fontFamily: FontHelper.PostscriptName = FontHelper.PostscriptName.mswImpact,
        fontSize: CGFloat = 12.0,
        textAnchor: String = "start"
        ) {
        
        var tagBefore = ""
        var tagAfter = ""
        let textEncoded = text.filteringToSvgAscii()
        
        tagBefore.append("<text ")
        tagBefore.append("transform=\"translate(\(x) \(y)) rotate(\(rotate))\" ")
        tagBefore.append("fill=\"\(fill)\" ")
        
        tagBefore.append("font-family=\"\(fontFamily.rawValue)\" ")
        tagBefore.append("font-size=\"\(fontSize)\" ")
        
        tagBefore.append("text-anchor=\"\(textAnchor)\" ")

        tagBefore.append(">")
        
        tagAfter.append("</text>\n")
        
        self.append(tagBefore + textEncoded + tagAfter)
    }
    
    /// svgAddTextBox ... reduces whitespace to single spaces.
    ///
    /// ```
    /// <svg style="border:1px solid blue;" text-anchor="end"> 
    ///   <text font-size="30px"> 
    ///     <tspan x="100%" dy="30">tspan line 1</tspan> 
    ///     <tspan x="100%" dy="35">tspan line 2</tspan> 
    ///   </text>
    /// </svg>
    /// ```
    ///
    /// * position +x moves "rightward" along the string baseline. 
    /// * position +y moves descends "lower down" relative to the string baseline
    ///
    /// :TBD: review & document coordinate system for consistent use of X/Y directional system. Font space. SVG space.
    mutating func svgAddTextBox(
        text: String,
        fill: String = "#000000",
        font: FontPointFamilyMetrics,
        fontLineHeight: CGFloat,
        bounds: CGSize,
        position: CGPoint,
        textAnchor: String = "start",
        framed: Bool = false
        ) {
        let textWrapped: [String] = font.wordwrap(string: text, width: bounds.width)
        
        var s = ""
        var lineY: CGFloat = 0.0 // font.ptsAscent
        for line in textWrapped {
            if lineY + font.fontSize + font.ptsDescent < bounds.height {
                s.svgAddText(text: line, x: 0, y: lineY, fill: fill, fontFamily: font.fontFamily, fontSize: font.fontSize, textAnchor: textAnchor) // textAnchor: String
            }
            else {
                break
            }
            lineY = lineY + font.fontSize
            
        }
    
        // group
        s.svgWrapGroup(translate: (position.x, position.y))
        
        if framed {
            if textAnchor.lowercased() == "start" {
                s.svgAddRect(
                    x: position.x, y: position.y - font.ptsAscent, 
                    width: bounds.width, height: bounds.height, 
                    stroke: "black", strokeWidth: 0.25)
            } 
            else if textAnchor.lowercased() == "end" {
                s.svgAddRect(
                    x: position.x - bounds.width, y: position.y - font.ptsAscent, 
                    width: bounds.width, height: bounds.height, 
                    stroke: "black", strokeWidth: 0.25)
            } 
        }
        
        self.append(s)
    }
    
    
    /// \<g >…\<g\>
    ///
    /// **See Also**
    /// * [MDN \<g\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/g)
    /// * [MDN transform](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform)
    mutating func svgWrapGroup(
        translate: (x: CGFloat, y: CGFloat)?
        ) {
        var attributes = ""
        if translate != nil {
            attributes.append(" transform=\"")
            if let t = translate {
                attributes.append("translate(\(t.x),\(t.y))")
            }
            attributes.append("\" ")
        }
        
        self = "<g\(attributes)>\n" + self + "</g>\n"
    }
    
    /// \<svg x="x" y="y" width="width" height="height"\>…\<svg\>
    ///
    /// [see MDN \<svg\>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/svg)
    ///
    /// - parameters:
    ///     - w: width pixels
    ///     - h: height pixels
    ///     - standalone: true to include standalone file format header
    mutating func svgWrapSvgTag(w: CGFloat, h: CGFloat, standalone: Bool = false) {
        var beginTag = ""

        if standalone {
            beginTag.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
            beginTag.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n")
        }
        
        beginTag.append("<svg xmlns=\"http://www.w3.org/2000/svg\" ")
        // viewBox="min-x min-y width height"
        beginTag.append("width=\"\(w)\" height=\"\(h)\"> \n")
        
        self = beginTag + self
        self.append("</svg>\n")
    }
    
    mutating func svgWrapSvgTag(wPercent w: CGFloat, hPercent h: CGFloat, standalone: Bool = false) {
        var beginTag = ""

        if standalone {
            beginTag.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
            beginTag.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n")
        }

        beginTag.append("<svg xmlns=\"http://www.w3.org/2000/svg\" ")
        // viewBox="min-x min-y width height"
        beginTag.append("width=\"\(w)%\" height=\"\(h)%\"> \n")
        
        self = beginTag + self
        self.append("</svg> \n")
    }
    
}
