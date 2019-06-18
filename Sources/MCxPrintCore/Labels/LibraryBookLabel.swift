//
//  LibraryBookLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

// migrate from TagBookRecord: Codable
public struct LibraryBookLabel: Codable {
    
    func svg(
        call: String,
        collectionSID: String,
        udcLabel: String
        ) -> String {
        let wxhLandscape = PrintTemplate.PaperPointRect.ptouchLandscape
        //
        let ptsCallLeft: CGFloat = 46.0
        let ptsCallTop: CGFloat = 18.0 - 6.0
        let ptsFontLineHeight: CGFloat = 13.0
        let ptsLabelHeight = PrintTemplate.PaperPointRect.ptouchLandscape.height
        //let ptsUdcLabelLeft: CGFloat = ptsCallLeft + 1.0 // :!!!:
        //let ptsUdcLabelTop: CGFloat = ptsCallTop
        
        // udc-facet-author-title
        let callParts = call.components(separatedBy: "-")
        let callUdc = callParts[0]
        let callFacet = callParts[1]
        let callAuthor = callParts[2]
        var callTitle = callParts[3]
        if callParts.count > 4 {
            callTitle.append("-\(callParts[4])")
        }
        // callVersion // e.g. year such as v2017
        
        var s = ""
        // Call Number
        let callUdcFragments = LabelHelper.udcToFragments(callUdc)
        var callLineNo: CGFloat = 0.0
        for udcFragment in callUdcFragments {
            s.svgAddText(text: udcFragment, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
            callLineNo = callLineNo + 1.0
        }
        if callLineNo > 2.0 && callFacet.compare("•") == ComparisonResult.orderedSame {
            s.svgAddText(text: callAuthor, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
            callLineNo = callLineNo + 1.0
            s.svgAddText(text: callTitle, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
        }
        else if callLineNo > 2.0 {
            
        }
        else {
            s.svgAddText(text: callFacet, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
            callLineNo = callLineNo + 1.0
            s.svgAddText(text: callAuthor, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
            callLineNo = callLineNo + 1.0
            s.svgAddText(text: callTitle, x: ptsCallLeft, y: ptsCallTop + callLineNo * ptsFontLineHeight)
        }
        
        // UDC Description Label
        //guard let udcFont = NSFont(name: CssFontName.arialNarrowItalic, size: 12.0)
        //    else { fatalError() }
        
        // :!!!:WIP: let spaceWidthPts = " ".size(withFont: udcFont).width
        let spaceWidthPts = 16.0 // :!!!:WIP: remove after figuring out font widths.
        let udcLineMaxWidthPts = 98.0 - spaceWidthPts
        
        let udcLabelParts = udcLabel.components(separatedBy: " ")
        var udcLine = ""
        var udcLineList: [String] = []
        for word: String in udcLabelParts {
            // :!!!:WIP: let wordWidthPts = word.size(withFont: udcFont).width
            // :!!!:WIP: let udcLineWidthPts = udcLine.size(withFont: udcFont).width
            let wordWidthPts = 60.0 // :!!!:WIP: remove after figuring out font widths.
            let udcLineWidthPts = 200.0 // :!!!:WIP: remove after figuring out font widths.
            
            if (udcLineWidthPts + spaceWidthPts + wordWidthPts) <= udcLineMaxWidthPts {
                udcLine = udcLine + " " + word
            }
            else {
                udcLineList = udcLineList + [udcLine]
                udcLine = word
            }
        }
        udcLineList = udcLineList + [udcLine]
        print("udcLineList=\(udcLineList)")
        
        let ptsUdcLeft: CGFloat = 230.0
        var lineNo: CGFloat = 0.0
        for line in udcLineList {
            s.svgAddText(
                text: line,
                x: ptsUdcLeft,
                y: ptsCallTop + lineNo * ptsFontLineHeight,
                fontFamily: FontHelper.Name.liberationNarrow,
                fontSize: 12.0,
                textAnchor: "end")
            lineNo = lineNo + 1.0
        }
        
        // Collection String ID
        s.svgAddRect(x: 0.0, y: 0.0, width: ptsFontLineHeight + 4.0, height: ptsLabelHeight, fill: "Black")
        s.svgAddText(text: collectionSID, x: 6.0, y: 5.0, rotate: 90.0, fill: "White")
        
        s.svgWrapTag(w: wxhLandscape.width, h: wxhLandscape.height)
        s.htmlWrapMinimal()
        
        print("PrintTemplate.generateTagBook()\n\(s)")
        return s
    }
    
}

 /* ********************************************
 {
 "version": "0.1.0",
 "labelBooks" : [
 {
 "type" : "book",
 "udcCall" : "004.52-•-MC-WEDN",
 "udcLabel" : "Generic Labels - SVG Layout Example",
 "collectionID" : "ABCDEFgH",
 "collectionColor" : "green"
 }
 ],
 "labelFiles" : [
 {
 "type" : "file",
 "title" : "Wingding Everest Dialog Network",
 "udcCall" : "004.52-•-MC-WEDN",
 "udcLabel" : "Generic Labels - SVG Layout Example",
 "collectionID" : "ABCDEFgH",
 "collectionColor" : "green"
 }
 ],
 "labelParts" : [
 {
 "type" : "part",
 "name" : "Resistor",
 "value": "100K",
 "description": "carbon"
 },
 {
 "type" : "part",
 "name" : "9DOF Sensor",
 "value": "Adafruit-12345",
 "description": "carbon"
 }
 ]
 }
 ******************************************** */
