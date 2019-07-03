//
//  LabelColors.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.19.
//

import Foundation

// backgroundLight, backgroundDark, invertedFont
struct LabelColorRecord {
    let aFill: String
    let aFont: String
    let bFill: String
    let bFont: String
    
    init(aFill: LabelColorRgbHex, aFont: LabelColorRgbHex, bFill: LabelColorRgbHex, bFont: LabelColorRgbHex) {
        self.aFill = aFill.rawValue
        self.aFont = aFont.rawValue
        self.bFill = bFill.rawValue
        self.bFont = bFont.rawValue
    }
}

/// http://norgannasaddons.github.io/ColorDial/
enum LabelColorRgbHex: String {
    case black = "#000000"
    case blueDark = "#0000FF"
    case blueLight = "#f0f8ff"
    case burgundyDark = "#941651"
    case burgundyLight = "#fad4e6"
    case grayDark = "#505050"
    case grayLight = "#F5F5F5"
    case greenDark = "#4C7E4C"
    case greenLight = "#E5FFE5"
    case orangeDark = "#e68500"
    case orangeLight = "#ffe4bf"
    case tealDark = "#00adad"
    case tealLight = "#ccffff"
    case white = "#FFFFFF"
    case yellowDark = "#7f8000"
    case yellowLight = "#ffffcc"
}

public enum LabelColorTheme: String, Codable { // LabelColorTheme
    
    /// light grey
    case academic
    /// bright green
    case finances
    /// yellow
    case business
    /// marketing & communication: teal
    case markcom
    /// burgundy
    case people
    /// orange
    case project
    /// blue
    case record
    /// No coloration. Simple black & white. Same as unspecified.
    case reference
    /// Infrastructure. white on black.
    case system
    /// No coloration. Simple black & white.
    case unspecified
    // pendaflex colors not used: lavendar, navy, pink, red, white
    
    func getColor() -> LabelColorRecord {
        
        switch self {
        case .academic:
            return LabelColorRecord(aFill: .grayLight, aFont: .black, bFill: .grayDark, bFont: .white)
        case .finances:
            return LabelColorRecord(aFill: .greenLight, aFont: .black, bFill: .greenDark, bFont: .white)
        /// yellow Business Records
        case .business:
            return LabelColorRecord(aFill: .yellowLight, aFont: .black, bFill: .yellowDark, bFont: .white)
        /// marketing & communication: teal
        case .markcom:
            return LabelColorRecord(aFill: .tealLight, aFont: .black, bFill: .tealDark, bFont: .white)
        /// burgundy
        case .people:
            return LabelColorRecord(aFill: .burgundyLight, aFont: .black, bFill: .burgundyDark, bFont: .white)
        /// orange
        case .project:
             return LabelColorRecord(aFill: .orangeLight, aFont: .black, bFill: .orangeDark, bFont: .white)
        /// blue Personal Records
        case .record:
            return LabelColorRecord(aFill: .blueLight, aFont: .black, bFill: .blueDark, bFont: .white)
        /// No coloration. Simple black & white. Same as unspecified.
        case .reference:
            return LabelColorRecord(aFill: .white, aFont: .black, bFill: .black, bFont: .white)
        case .system:
            return LabelColorRecord(aFill: .grayDark, aFont: .white, bFill: .black, bFont: .white) // bFont: .black to not show font
        case .unspecified:
            return LabelColorRecord(aFill: .white, aFont: .black, bFill: .black, bFont: .white)
        }
    }
    
}
