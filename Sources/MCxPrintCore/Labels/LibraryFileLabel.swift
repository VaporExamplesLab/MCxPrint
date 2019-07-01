//
//  LibraryFileLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

// migrate from TagFileRecord.swift
public struct LibraryFileLabel: Codable {
    
    //"title": "Wingding Everest Dialog Network",
    let title: String
    //"udcCall": "004.52-•-MC-WEDN",
    let udcCall: String
    //"udcLabel": "Generic Labels - SVG Layout Example",
    let udcLabel: String
    //"collectionSID": "ABCDEFgH",
    let collectionSID: String
    ///"collectionColor": "green", "#ffff00", "rgb(0, 0, 0)", "rgba()", "hsl()", "hsla()"
    let collectionColor: LabelColorTheme
    
    public init(title: String, udcCall: String, udcLabel: String, collectionSID: String, collectionColor: LabelColorTheme) {
        self.title = title
        self.udcCall = udcCall
        self.udcLabel = udcLabel
        self.collectionSID = collectionSID
        self.collectionColor = collectionColor
    }
    
    // JSON
    public func svg(framed: Bool = false) -> String {
        let ptsLabelRect = PrintTemplate.PaperPointRect.avery5027
        //
        let ptsFontLineHeight: CGFloat = 13.0
        let ptsCollectionWidth = ptsFontLineHeight + 4.0
        let ptsInsetX = ptsCollectionWidth + 4.0
        let ptsMainWidthY = ptsLabelRect.width - ptsCollectionWidth
        
        let ptsCallNumberY: CGFloat = 13.0 + 4.0
        let ptsTitleY = ptsCallNumberY + 13.0 + 4.0
        let ptsUdcHeadingY = ptsTitleY + 13.0 + 4
        
        let colors = collectionColor.getColor()
        
        var s = ""
        
        // Collection String ID
        //s.svgAddRect(x: 0.0, y: 0.0, width: ptsCollectionWidth, height: ptsLabelRect.height, fill: colors.bFill)
        //s.svgAddText(text: collectionSID, x: 6.0, y: 5.0, rotate: 90.0, fill: colors.bFont, fontFamily: FontHelper.PostscriptName.mswImpact)
        //
        //if framed {
        //    s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: "black")
        //}
        
        // Background
        s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: colors.aFill, fill: colors.aFill)
        //s.svgAddRect(x: 0.0, y: 0.0, width: ptsLabelRect.width, height: ptsLabelRect.height, stroke: colors.aFill)
        
        // Call Number
        //s.svgAddText(text: udcCall, x: ptsInsetX, y: ptsCallNumberY, fill: colors.aFont)
        let fontCallNumber = try! FontMetricExtractor(
            // fontFamily: FontHelper.PostscriptName.gaugeHeavy, 
            fontFamily: FontHelper.PostscriptName.mswImpact, 
            fontSize: 12.0)
        s.svgAddTextBox(
            text: udcCall,
            font: fontCallNumber,
            fontLineHeight: ptsFontLineHeight,
            bounds: CGSize(width: ptsMainWidthY, height: ptsFontLineHeight),
            position: CGPoint(x: ptsInsetX, y: ptsCallNumberY),
            framed: true
        )
        
        // Title
        s.svgAddText(text: title, x: ptsInsetX, y: ptsTitleY, fill: colors.aFont)

        // UDC Heading Label
        s.svgAddText(text: udcLabel, x: ptsInsetX, y: ptsUdcHeadingY, fill: colors.aFont)
        
        return s
    }
}

