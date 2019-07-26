//
//  MCxPrintSpoolStageType.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.13.
//

import Foundation

public enum MCxPrintSpoolStageType {
    /// Batch grouping (e.g.) occurs during the processing of stage1Json. 
    case stage1Json
    /// SVG layouts are "print media ready" at this time.
    /// :NYI: future Svg might support .part.svg and .page.svg ? 
    case stage2Svg
    case stage3Pdf
    case stage4Printed
    
    public func fileExtension() -> String {
        switch self {
        case .stage1Json:
            return "json"
        case .stage2Svg:
            return "svg"
        case .stage3Pdf, .stage4Printed:
            return "pdf"
        }
    }
}

