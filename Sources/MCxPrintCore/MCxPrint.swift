//
//  MCxPrint.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

public final class MCxPrint {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
    }

    public func run() throws {
        //guard arguments.count > 1
        //    else {
        //        throw Error.missingFirstArgument
        //    }
        //
        //let firstArgument = arguments[1]
        
        printStderr("Arguments:\n\(arguments)")
        
        // ------------------
        // -- Font Metrics --
        let svgPageFontMetrics = FontMetricsPage()
        let fontMetricsPage = svgPageFontMetrics.svg()
        try? fontMetricsPage.write(to: scratchUrl.appendingPathComponent("PageFontMetrics.svg"), atomically: false, encoding: .utf8)
        
        let printJob = PrintJob()
        printJob.svgToPdf(basename: "PageFontMetrics")
    }
}

public extension MCxPrint {
    enum Error: Swift.Error {
        case missingFirstArgument
        case failedToCreateFile
        case fontNotFound
    }
}

