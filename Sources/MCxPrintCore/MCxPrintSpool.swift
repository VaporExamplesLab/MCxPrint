//
//  MCxPrintSpool.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.11.
//

import Foundation

public struct MCxPrintSpool {
    public let root: URL
    public let stage: SpoolStage
    
    public init(_ rootPath: String) {
        let rootUrl = URL(fileURLWithPath: rootPath, isDirectory: true)
        self.root = rootUrl
        self.stage = SpoolStage(rootUrl)
    }
    
    public struct SpoolStage {
        public let cached: URL
        public let converted: URL
        public let printed: URL
        public let root: URL
        
        public init(_ url: URL) {
            self.root = url
            self.cached = url.appendingPathComponent(
                "cached",
                isDirectory: true)
            self.converted = url.appendingPathComponent(
                "converted",
                isDirectory: true)
            self.printed = url.appendingPathComponent(
                "printed",
                isDirectory: true)
        }
    }
}
