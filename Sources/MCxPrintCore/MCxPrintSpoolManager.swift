//
//  MCxPrintSpoolManager.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

// 
public struct MCxPrintSpoolManager {

    let batchSize: Int
    //
    public let rootUrl: URL
    public let stage1JsonUrl: URL
    public let stage2SvgUrl: URL
    public let stage3PdfUrl: URL
    public let stage4PrintedUrl: URL
    
    /// root url directory contains stage2SvgUrl/, stage3PdfUrl/, stage4PrintedUrl/ subdirectories.
    public init(_ rootPath: String, batchSize: Int) {
        self.batchSize = batchSize
        //
        self.rootUrl = URL(fileURLWithPath: rootPath, isDirectory: true)
        self.stage1JsonUrl = rootUrl.appendingPathComponent(
            "stage1json",
            isDirectory: true)
        self.stage2SvgUrl = rootUrl.appendingPathComponent(
            "stage2svg",
            isDirectory: true)
        self.stage3PdfUrl = rootUrl.appendingPathComponent(
            "stage3pdf",
            isDirectory: true)
        self.stage4PrintedUrl = rootUrl.appendingPathComponent(
            "stage4printed",
            isDirectory: true)
    }
    
    public func processStage1Json() {
        
    }
    
    public func getJobNames(stage: MCxPrintSpoolStage) -> [String] {
        var readyJobNames = [String]()
        var remainderJobNames = [String]()
        do {
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: self.stage2SvgUrl, 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            for fileUrl in cachedUrls {
                if fileUrl.pathExtension == stage.fileExtension() {
                    if remainderJobNames.count + 1 == batchSize {
                        for rurl in remainderJobNames {
                            readyJobNames.append(rurl)
                        }
                        remainderJobNames.removeAll()
                        readyJobNames.append(fileUrl.deletingPathExtension().lastPathComponent)
                    }
                    else {
                        remainderJobNames.append(fileUrl.deletingPathExtension().lastPathComponent)
                    }
                    
                }
            }
            return readyJobNames
        } 
        catch {
            print(":ERROR:AknowtzPrintSpool:getJobNames(): \(error)")
            return readyJobNames
        }
    }
    
    public func findStageFileUrls(stage: MCxPrintSpoolStage) -> [URL] {
        var readyUrls = [URL]()
        var remainderUrls = [URL]()
        do {            
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: self.stage2SvgUrl, 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            for fileUrl in cachedUrls {
                if fileUrl.pathExtension == stage.fileExtension() {
                    if remainderUrls.count + 1 == batchSize {
                        for rurl in remainderUrls {
                            readyUrls.append(rurl)
                        }
                        remainderUrls.removeAll()
                        readyUrls.append(fileUrl)
                    }
                    else {
                        remainderUrls.append(fileUrl)
                    }
                    
                }
            } 
            return readyUrls
        } 
        catch {
            print(":ERROR: AknowtzPrintSpool findStage2SvgFiles() \(error)")
            return readyUrls
        }
    }
    
    public func processStage2Svg() {

    }
    
    public func findStage2SvgFiles() -> (readyUrls: [URL], remainderUrl: [URL])? {
        do {
            var readyUrls = [URL]()
            var remainderUrls = [URL]()
            
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: self.stage2SvgUrl, 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])

            for fileUrl in cachedUrls {
                if fileUrl.pathExtension == "svg" {
                    if remainderUrls.count + 1 == batchSize {
                        for rurl in remainderUrls {
                            readyUrls.append(rurl)
                        }
                        remainderUrls.removeAll()
                        readyUrls.append(fileUrl)
                    }
                    else {
                        remainderUrls.append(fileUrl)
                    }

                }
            } 
            return (readyUrls, remainderUrls)
        } 
        catch {
            print(":ERROR: AknowtzPrintSpool findStage2SvgFiles() \(error)")
            return nil
        }
    }
    
    /// returns list of file URLs which have been stage3PdfUrl
    public func processStage2SvgToPdf(_ urls: [URL]) -> [URL] {
        var result = [URL]()
        guard let filesToConvert = findStage2SvgFiles() else {
            return result
        }
        //
        for svgFileUrl in filesToConvert.readyUrls {
            let basename = svgFileUrl.deletingPathExtension().lastPathComponent
            svgToPdf(basename: basename)
            
            do {
                let fm = FileManager.default
                // move svg
                let svgToUrl = self.stage3PdfUrl
                    .appendingPathComponent(
                        svgFileUrl.lastPathComponent, 
                        isDirectory: false
                )
                try fm.moveItem(at: svgFileUrl, to: svgToUrl)
                // move pdf
                let pdfFromUrl = svgFileUrl.deletingPathExtension()
                    .appendingPathExtension("pdf")
                let pdfToUrl = self.stage3PdfUrl
                    .appendingPathComponent(pdfFromUrl.lastPathComponent, isDirectory: true)
                try fm.moveItem(at: pdfFromUrl, to: pdfToUrl)
                
                result.append(pdfToUrl)
            }
            catch {
                print(":ERROR: processStage2SvgToPdf failed to move file related to \(svgFileUrl) \(error)")
            }
        }
        return result
    }
    
    /// returns existing PDF files in /stage3PdfUrl/ directory
    public func findStage3PdfFiles() -> [URL] {
        var readyUrls = [URL]()
        do {
            let fm = FileManager.default
            let cachedBookLabels = try fm.contentsOfDirectory(
                at: self.stage3PdfUrl, 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            for fileUrl in cachedBookLabels {
                if fileUrl.pathExtension == "pdf" {
                    readyUrls.append(fileUrl)
                }
            } 
            return readyUrls
        } 
        catch {
            print(":ERROR: AknowtzPrintSpool findStage3PdfFiles() \(error)")
            return readyUrls
        }
    }
    
    public func processStage3PdfToPrinter(_ urls: [URL]) -> [URL] {
        var result = [URL]()
        guard let filesToConvert = findStage2SvgFiles() else {
            return result
        }
        //
        for pdfFileUrl in filesToConvert.readyUrls {
            pdfToPrinter(url: pdfFileUrl)
            
            do {
                let fm = FileManager.default
                // move pdf
                let pdfToUrl = self.stage4PrintedUrl
                    .appendingPathComponent(
                        pdfFileUrl.lastPathComponent, 
                        isDirectory: false
                )
                try fm.moveItem(at: pdfFileUrl, to: pdfToUrl)
                
                result.append(pdfToUrl)
            }
            catch {
                print(":ERROR: processStage3PdfToPrinter failed to move file \(pdfFileUrl) \(error)")
            }
        }
        return result
    }
    
    public func svgToPdf(basename: String) {
        let cachedUrl = self.stage2SvgUrl
        let inputSvgPath = cachedUrl.appendingPathComponent("\(basename).svg", isDirectory: false).path
        let outputPdfPath = cachedUrl.appendingPathComponent("\(basename).pdf", isDirectory: false).path
        
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

        let executableUrl = URL(fileURLWithPath: "/usr/local/bin/svg2pdf", isDirectory: false)
        _ = run(
            executableUrl: executableUrl,
            withArguments: args,
            currentDirectory: cachedUrl,
            printStdio: true
        )
    }
    
    public func pdfToPrinter(url: URL) {
        fatalError(":!!!:NYI: pdfToPrinter(url: URL)")
    }
    
    private func run(executableUrl: URL,
                           withArguments: [String]? = nil,
                           currentDirectory: URL? = nil,
                           printStdio: Bool = false) -> (stdout: String, stderr: String) {
        let process = Process()
        process.executableURL = executableUrl
        if let args = withArguments {
            process.arguments = args
        }
        if let wd = currentDirectory {
            process.currentDirectoryURL = wd
        }
        
        let pipeOutput = Pipe()
        process.standardOutput = pipeOutput
        let pipeError = Pipe()
        process.standardError = pipeError
        
        do {
            try process.run()
            
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
        } catch {
            let errorStr = "FAILED: \(error)"
            return ("", errorStr)
        }
    }
    
}
