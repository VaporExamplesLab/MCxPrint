//
//  LibraryFileLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

/// * Standard hanging folder tab has vertical visibility of about 42 points.
public struct LibraryFileLabel: Codable {
    
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
        return toJsonStr() ?? "nil"
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
    
    // JSON
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
            framed: false
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
            framed: false
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
            framed: false
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
    
    public func toJsonData() -> Data? {
        do {
            let encoder = JSONEncoder()
            let data: Data = try encoder.encode(self)
            return data
        } catch {
            print(":ERROR: LibraryFileLabel toSpoolJsonData() \(error)")
        }
        return nil
    }
    
    public func toJsonStr() -> String? {
        if let d = toJsonData() {
            return String(data: d, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
    public func spoolWrite(spool: MCxPrintSpool, stage: MCxPrintSpoolStageType = .stage1Json) -> URL? {
        let datestamp = DateTimeUtil.getSpoolTimestamp()
        let filename = "\(self.udcCall)_\(datestamp)"
        let fileUrl = spool.stage2SvgUrl
            .appendingPathComponent(filename)
            .appendingPathExtension("json")
        
        do {
            guard let data = self.toJsonData() 
                else {
                    print("ERROR: LibraryFileLabel failed generate JSON '\(self.description)'")
                    return nil
            }
            let url = fileUrl
            try data.write(to: url)
            return fileUrl
        } 
        catch {
            print("ERROR: LibraryFileLabel failed to save '\(fileUrl.lastPathComponent)' \n\(error)")
            return nil
        }
    }
    
}

