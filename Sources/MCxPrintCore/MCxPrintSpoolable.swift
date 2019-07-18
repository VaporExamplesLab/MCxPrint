//
//  MCxPrintSpoolable.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.13.
//

import Foundation



public protocol MCxPrintEnspoolable {
    
}

public protocol MCxPrintDespoolable {
    
}

public typealias MCxPrintSpoolable = MCxPrintEnspoolable & MCxPrintDespoolable
