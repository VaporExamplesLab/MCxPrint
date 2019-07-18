//
//  InventoryPartLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.16.
//

import Foundation

/// Migrate from TagPartRecord.swift
public struct InventoryPartLabel: Codable {
    
    static var queue = MCxPrintSpoolManager("/var/spool/mcxprint_spool/labelpart", batchSize: 1)
    
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
    
}
