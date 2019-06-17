//
//  PrintJob.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

internal struct PrintJob {
    
    func svgToPdf(basename: String) {
        let workPath = scratchPath
        let inputSvgPath = workPath.appending("/\(basename).svg")
        let outputPdfPath = workPath.appending("/\(basename).pdf")
        
        var args = [String]()
        // --width=WIDTH    Scale image to be width of WIDTH pixels.
        // The original aspect ratio is preserved.
        
        // --height=HEIGHT  Scale image to be height of HEIGHT pixels.
        // The original aspect ratio is preserved.
        
        // If both the --width and --height options are provided,
        // the  image  will be  scaled  to  the  smaller  dimension
        // and will be centered within any extra space.
        
        // --scale=FACTOR  Scale image by FACTOR.
        // Ignored if either --width or --height options are provided.
        
        // --flipx         Flip the output X coordinates.
        // --flip          Flip the output Y coordinates.

        args = args + [inputSvgPath]
        args = args + [outputPdfPath]

        _ = run(
            commandPath: "/usr/local/bin/svg2pdf",
            withArguments: args,
            workDirectory: workPath,
            printStdio: true
        )
    }
    
    func pdfToPrinter(url: URL) {
        
    }
    
    private func run(commandPath: String,
                           withArguments: [String]? = nil,
                           workDirectory: String? = nil,
                           printStdio: Bool = false) -> (stdout: String, stderr: String) {
        let process = Process()
        process.launchPath = commandPath
        if let args = withArguments {
            process.arguments = args
        }
        if let wd = workDirectory {
            process.currentDirectoryPath = wd
        }
        
        let pipeOutput = Pipe()
        process.standardOutput = pipeOutput
        let pipeError = Pipe()
        process.standardError = pipeError
        process.launch()
        
        var stdoutStr = "" // do not mask foundation stdout
        var stderrStr = "" // do not mask foundation stderr
        
        let data = pipeOutput.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: String.Encoding.utf8) {
            if printStdio {
                print("STANDARD OUTPUT\n" + output)
            }
            stdoutStr.append(output)
        }
        
        let dataError = pipeError.fileHandleForReading.readDataToEndOfFile()
        if let outputError = String(data: dataError, encoding: String.Encoding.utf8) {
            if printStdio {
                print("STANDARD ERROR \n" + outputError)
            }
            stderrStr.append(outputError)
        }
        
        process.waitUntilExit()
        if printStdio {
            let status = process.terminationStatus
            print("STATUS: \(status)")
        }
        
        return (stdoutStr, stderrStr)
    }
    
}
