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

    }
}

public extension MCxPrint {
    enum Error: Swift.Error {
        case missingFirstArgument
        case failedToCreateFile
        case failedToInitializeSpoolable
        case failedToLoadFile
        case fontNotFound
        case unsupportedBatchSize
    }
}

