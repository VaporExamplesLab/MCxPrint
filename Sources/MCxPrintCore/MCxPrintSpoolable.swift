//
//  MCxPrintSpoolable.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.13.
//

import Foundation

public protocol MCxPrintJsonSpoolable {
    func spoolAddStage1Json(spool: MCxPrintSpoolProtocol) -> URL?

    func toSpoolJobBasename() -> String
    func toSpoolJsonData() -> Data?
    func toSpoolJsonStr() -> String?
}

public protocol MCxPrintSvgSpoolable {
    init(jsonDataBlocks: [Data]) throws
    init(jsonStrBlocks: [String]) throws
    init(jsonUrlBlocks: [URL]) throws
    
    static func jsonBatchAllowedSizes() -> [Int]
    static func jsonBatchSupportsPartials() -> Bool
    
    // Basename without timestamp.
    func toSpoolJobBasename() -> String
    
    // Single page for single item.
    func toSpoolSvgStr() -> String

    func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol) -> URL?
}

public typealias MCxPrintSpoolable = MCxPrintJsonSpoolable & MCxPrintSvgSpoolable
