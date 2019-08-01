//
//  LibraryFileLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

/// * Standard hanging folder tab has vertical visibility of about 42 points.
public struct LibraryFileLabel: Codable, MCxPrintJsonSpoolable {

    //"title": "Wingding Everest Dialog Network",
    let title: String
    //"udcCall": "004.52-•-MC-WEDN",
    let udcCall: String
    //"udcLabel": "Generic Labels - SVG Layout Example",
    let udcLabel: String
    //"collectionSID": "ABCDEFgH", (StringID)
    let collectionSID: String
    ///"collectionColor": "green", "#ffff00", "rgb(0, 0, 0)", "rgba()", "hsl()", "hsla()"
    let collectionColor: LabelColorTheme
    
    var description: String {
        return toSpoolJsonStr() ?? "nil"
    }
    
    public init(title: String, udcCall: String, udcLabel: String, collectionSID: String, collectionColor: LabelColorTheme) {
        self.title = title
        self.udcCall = udcCall
        self.udcLabel = udcLabel
        self.collectionSID = collectionSID
        self.collectionColor = collectionColor
    }
    
    public init(jsonFileUrl: URL) throws {
        do {
            let data = try Data(contentsOf: jsonFileUrl)
            let decoder = JSONDecoder()
            let temp = try decoder.decode(LibraryFileLabel.self, from: data)
            self.title = temp.title
            self.udcCall = temp.udcCall
            self.udcLabel = temp.udcLabel
            self.collectionSID = temp.collectionSID
            self.collectionColor = temp.collectionColor
        } catch {
            print(":ERROR: LibraryFileLabel init() failed url=\(jsonFileUrl) error=\(error)" )
            throw MCxPrint.Error.failedToLoadFile
        }
    }
    
    // SVG
    public func svg(framed: Bool = false, standalone: Bool = false) -> String {
        let ptsLabelRect = PrintTemplate.PaperPointRect.avery5027
        //
        let ptsFontLineHeight: CGFloat = 13.0
        let ptsCollectionWidth = ptsFontLineHeight + 4.0
        let ptsInsetX = ptsCollectionWidth + 4.0
        let ptsMainWidthY = ptsLabelRect.width - ptsCollectionWidth - 4.0
        
        let ptsCallNumberY: CGFloat = 13.0
        let ptsTitleY = ptsCallNumberY + 13.0 + 1.0
        let ptsUdcHeadingY = ptsTitleY + 24.0 + 1.0
        
        let colors = collectionColor.getColor()
        
        var s = ""
        
        // Background
        // overprint rectangle. highlight: LabelColorRgbHex.grayDark.rawValue
        s.svgAddRect(x: 0.0 - 4.0, y: 0.0 - 4.0, width: ptsLabelRect.width + 8.0, height: ptsLabelRect.height + 8.0, stroke: colors.aFill, fill: colors.aFill)
        // label rectangle
        s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: colors.aFill, fill: colors.aFill)
        //s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: colors.aFill)
        
        // Call Number
        guard let fontCallNumber = FontPointFamilyMetrics.fileLoad(fontFamily: FontHelper.PostscriptName.dejaVuMonoBold, fontSize: 12.0)
            else { return "FONT NOT FOUND" }

        s.svgAddTextBox(
            text: udcCall,
            fill: colors.aFont,
            font: fontCallNumber,
            fontLineHeight: ptsFontLineHeight,
            bounds: CGSize(width: ptsMainWidthY, height: ptsFontLineHeight),
            position: CGPoint(x: ptsInsetX, y: ptsCallNumberY),
            framed: framed
        )
        
        // Title
        guard let fontTitle = FontPointFamilyMetrics.fileLoad(fontFamily: FontHelper.PostscriptName.dejaVuCondensed, fontSize: 11.0)
            else { return "FONT NOT FOUND" }
        
        s.svgAddTextBox(
            text: title,
            fill: colors.aFont,
            font: fontTitle,
            fontLineHeight: ptsFontLineHeight,
            // reduced height by 1.0 pts per line
            bounds: CGSize(width: ptsMainWidthY, height: (ptsFontLineHeight * 2) - 2.0),
            position: CGPoint(x: ptsInsetX, y: ptsTitleY),
            framed: framed
        )
        
        // UDC Heading Label
        guard let fontUdcHeading = FontPointFamilyMetrics.fileLoad(fontFamily: FontHelper.PostscriptName.dejaVuCondensedOblique, fontSize: 10.0)
            else { return "FONT NOT FOUND" }
        s.svgAddTextBox(
            text: udcLabel,
            fill: colors.aFont,
            font: fontUdcHeading,
            fontLineHeight: ptsFontLineHeight,
            // reduced height by 2.0 pts per line
            bounds: CGSize(width: ptsMainWidthY, height: (ptsFontLineHeight * 2) - 4.0),
            position: CGPoint(
                x: ptsInsetX, 
                y: ptsUdcHeadingY
            ),
            framed: framed
        )
        
        // Collection String ID
        s.svgAddRect(x: 0.0, y: 0.0, width: ptsCollectionWidth, height: ptsLabelRect.height, fill: colors.bFill)
        // x: 6.0, y: 5.0
        // +x moves "rightward" along the string baseline. 
        // +y moves ascends "higher up" relative to the string baseline
        s.svgAddText(text: collectionSID, x: 4.0, y: 3.0, rotate: 90.0, fill: colors.bFont, fontFamily: FontHelper.PostscriptName.gaugeHeavy)
        
        if framed {
            s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: "black")
        }

        if standalone {
            s.svgWrapSvgTag(w: ptsLabelRect.width, h: ptsLabelRect.height, standalone: true)
        }
        
        return s
    }
    
    // /////////////////////////////
    // MARK: - MCxPrintJsonSpoolable
    // /////////////////////////////
    
    public func spoolAddStage1Json(spool: MCxPrintSpoolProtocol) -> URL? {
        return spool.spoolAddStage1Json(item: self)
    }
    
    public func toSpoolJobBasename() -> String {
        return self.udcCall
    }
    
    public func toSpoolJsonData() -> Data? {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(self)
            return data
        } catch {
            print(":ERROR: LibraryFileLabel toSpoolJsonData() \(error)")
        }
        return nil
    }
    
    public func toSpoolJsonStr() -> String? {
        if let d = toSpoolJsonData() {
            return String(data: d, encoding: String.Encoding.utf8)
        }
        return nil
    }

    public func toSpoolSvgPreview(framed: Bool, standalone: Bool) -> Data? {
        return self.svg(framed: framed, standalone: standalone).data(using: String.Encoding.utf8)
    }
    
}

