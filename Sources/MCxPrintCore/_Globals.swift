//
//  Globals.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.11.
//

import Foundation

internal let scratchPath = "/var/spool/aknowtz_spool/scratch"
internal let scratchUrl = URL(fileURLWithPath: scratchPath)

///////////////////////
/// stdout & stderr ///
///////////////////////

extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

internal var standardError = FileHandle.standardError
internal var standardOutput = FileHandle.standardOutput

internal func printStderr(_ any: Any) {
    print(any, to: &standardError)
}

internal func printStdout(_ any: Any) {
    print(any, to: &standardOutput)
}

