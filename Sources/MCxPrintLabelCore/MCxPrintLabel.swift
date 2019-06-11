import Foundation
import MCxLogger

public final class MCxPrintLabel {
    private let arguments: [String]
    private let logger: McLogger

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
        self.logger = McLogger()
    }

    public func run() throws {
        guard arguments.count > 1
            else {
                throw Error.missingFirstArgument
            }
        
        let firstArgument = arguments[1]
        
        logger.debug("Arguments:\n\(arguments)")
        
        print("Hello world")
    }
}

public extension MCxPrintLabel {
    enum Error: Swift.Error {
        case missingFirstArgument
        case failedToCreateFile
    }
}

