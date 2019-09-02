//
//  InventoryPartsPage.swift
//  MCxPrint
//
//  Created by marc on 2019.07.26.
//

import Foundation

public struct InventoryPartsPage { // MCxPrintSvgSpoolable
    
    let labels: [InventoryPartsLabel]
    
    init(labels: [InventoryPartsLabel]) {
        self.labels = labels
    }
    
    // ////////////////////////////
    // MARK: - MCxPrintSvgSpoolable
    // ////////////////////////////
    
    //    public init(jsonDataBlocks: [Data]) throws {
    //        <#code#>
    //    }
    //    
    //    public init(jsonStrBlocks: [String]) throws {
    //        <#code#>
    //    }
    //    
    //    public init(jsonUrlBlocks: [URL]) throws {
    //        <#code#>
    //    }
    //    
    //    public static func jsonBatchAllowedSizes() -> [Int] {
    //        <#code#>
    //    }
    //    
    //    public static func jsonBatchSupportsPartials() -> Bool {
    //        <#code#>
    //    }
    //    
    //    public func toSpoolSvgStr() -> String {
    //        <#code#>
    //    }
    //    
    //    public func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol) -> URL? {
    //        <#code#>
    //    }
}
