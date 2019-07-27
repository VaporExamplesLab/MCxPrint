//
//  InventoryPartsLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.16.
//

import Foundation

/// Migrate from TagPartRecord.swift
public struct InventoryPartsLabel: Codable { // MCxPrintJsonSpoolable
    
    //"name" : "Resistor", "9DOF Sensor"
    let name: String
    //"value": "100K", "Adafruit-12345"
    let value: String
    //"description": "carbon", "…"
    let description: String
    
    public init(name: String, value: String, description: String) {
        self.name = name
        self.value = value
        self.description = description
    }
    
    func svg() -> String {
        return ""
    }
    
    // /////////////////////////////
    // MARK: - MCxPrintJsonSpoolable
    // /////////////////////////////
    
    //    public func spoolAddStage1Json(spool: MCxPrintSpoolProtocol) -> URL? {
    //        <#code#>
    //    }
    //    
    //    public func toSpoolJobBasename() -> String {
    //        <#code#>
    //    }
    //    
    //    public func toSpoolJsonData() -> Data? {
    //        <#code#>
    //    }
    //    
    //    public func toSpoolJsonStr() -> String? {
    //        <#code#>
    //    }

    
}
