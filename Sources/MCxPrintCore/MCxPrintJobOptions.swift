//
//  MCxPrintJobOptions.swift
//  MCxPrint
//
//  Created by marc on 2019.07.30.
//

import Foundation

public struct MCxPrintJobOptions: Codable {
    
    let printerName: String
    let options: [String]
    
    public init(printerName: String, options: [String]) {
        self.printerName = printerName
        self.options = options
    }
    
    public func getArgs() -> [String] {
        var args = [String]()
        args.append(contentsOf: ["-d", printerName])
        for opt in options {
            args.append(contentsOf: ["-o", opt])    
        }
        return args
    }
    
}
