//
//  LibraryBookLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

// migrate from TagBookRecord: Codable
public struct LibraryBookLabel: Codable {
    
    //"udcCall" : "004.52-•-MC-WEDN",
    let udcCall: String
    //"udcLabel" : "Generic Labels - SVG Layout Example",
    let udcLabel: String
    //"collectionSID" : "ABCDEFgH",
    let collectionSID: String
    
    public init(udcCall: String, udcLabel: String, collectionSID: String, collectionColor: String) {
        self.udcCall = udcCall
        self.udcLabel = udcLabel
        self.collectionSID = collectionSID
    }
    
    public func svg() -> String {
        let wxhLandscape = PrintTemplate.PaperPointRect.ptouchLandscape
        //
        let ptsCallLeft: CGFloat = 46.0
        let ptsCallTop: CGFloat = 18.0 - 6.0
        let ptsFontLineHeight: CGFloat = 13.0
        let ptsLabelHeight = wxhLandscape.height
        //let ptsUdcLabelLeft: CGFloat = ptsCallLeft + 1.0 // :!!!:
        //let ptsUdcLabelTop: CGFloat = ptsCallTop
        
        // udc-facet-author-title
        let callParts = udcCall.components(separatedBy: "-")
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
                fontFamily: FontHelper.PostscriptName.liberationNarrow,
                fontSize: 12.0,
                textAnchor: "end")
            lineNo = lineNo + 1.0
        }
        
        // Collection String ID
        s.svgAddRect(x: 0.0, y: 0.0, width: ptsFontLineHeight + 4.0, height: ptsLabelHeight, fill: "black")
        s.svgAddText(text: collectionSID, x: 4.0, y: 3.0, rotate: 90.0, fill: "white", fontFamily: FontHelper.PostscriptName.gaugeHeavy)
        
        s.svgWrapSvgTag(w: wxhLandscape.width, h: wxhLandscape.height, standalone: true)
        
        return s
    }
    
    // MARK: - Class Methods 
    
    static func spoolLoad(fileUrl: URL) -> LibraryBookLabel? {
        do {
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            let libraryBookLabel = try decoder.decode(LibraryBookLabel.self, from: data)
            return libraryBookLabel
        } 
        catch {
            print("ERROR: failed to load '\(fileUrl.lastPathComponent)' \n\(error)")
            return nil
        }
    }
    
    static func spoolWrite(_ fileLabel: LibraryBookLabel) -> URL? {
        let datestamp = DateTimeUtil.getSpoolTimestamp()
        let filename = "\(fileLabel.udcCall)_\(datestamp)"
        let fileUrl = spoolUrl
            .appendingPathComponent("labelbook")
            .appendingPathComponent(filename)
            .appendingPathExtension("json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(fileLabel)
            let url = fileUrl
            try data.write(to: url)
            return fileUrl
        } 
        catch {
            print("ERROR: failed to save '\(fileUrl.lastPathComponent)' \n\(error)")
            return nil
        }
    }
    
}
