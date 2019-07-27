//
//  MCxPrintSpool.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

/// public struct MCxPrintSpoolManager
///
/// * rootUrl/
///     * stage1JsonUrl/
///     * stage2SvgUrl/
///     * stage3PdfUrl/
///     * stage4PrintedUrl/
public struct MCxPrintSpool: MCxPrintSpoolProtocol {

    let jsonBatchSize: Int
    
    ///
    public let rootUrl: URL
    public let stage1JsonUrl: URL
    public let stage2SvgUrl: URL
    public let stage3PdfUrl: URL
    public let stage4PrintedUrl: URL
    
    // 
    private let jsonSpooler: MCxPrintJsonSpoolable.Type
    private let svgSpooler: MCxPrintSvgSpoolable.Type
    private let printerName: String
            
    /// root url directory contains stage2SvgUrl/, stage3PdfUrl/, stage4PrintedUrl/ subdirectories.
    public init(_ rootPath: String, batchSize: Int, jsonSpooler: MCxPrintJsonSpoolable.Type, svgSpooler: MCxPrintSvgSpoolable.Type, printerName: String) throws {
        
        let allowedBatchsizes = svgSpooler.jsonBatchAllowedSizes()
        if allowedBatchsizes.contains(batchSize) == false &&
            svgSpooler.jsonBatchSupportsPartials() == false {
            throw MCxPrint.Error.unsupportedBatchSize
        }
        if let maxAllowedBatchSize = allowedBatchsizes.max() {
            if batchSize > maxAllowedBatchSize {
                throw MCxPrint.Error.unsupportedBatchSize
            }            
        } 
        
        self.jsonBatchSize = batchSize
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
        
        self.jsonSpooler = jsonSpooler
        self.svgSpooler = svgSpooler
        self.printerName = printerName
    }
    
    // /////////////
    // MARK: - Clear
    // /////////////
    
    public func clearSpool() {
        clearSpool(stage: .stage1Json)
        clearSpool(stage: .stage2Svg)
        clearSpool(stage: .stage3Pdf)
        clearSpool(stage: .stage4Printed)
    }
    
    public func clearSpool(jobnames: [String]) {
        for s in jobnames {
            clearSpool(name: s, stage: .stage1Json)
            clearSpool(name: s, stage: .stage2Svg)
            clearSpool(name: s, stage: .stage3Pdf)
            clearSpool(name: s, stage: .stage4Printed)
        }
    }
    
    public func clearSpool(name: String? = nil, stage: MCxPrintSpoolStageType) {
        
        do {
            let stageUrl: URL = getStageUrl(stage: stage)
            
            let fm = FileManager.default
            let jobUrls = try fm.contentsOfDirectory(
                at: stageUrl, 
                includingPropertiesForKeys: [.isRegularFileKey], 
                options: [.skipsHiddenFiles]
            )
            for url in jobUrls {
                if name == nil {
                    try fm.trashItem(at: url, resultingItemURL: nil)
                    // try fm.removeItem(at: url)
                }
                else if url.lastPathComponent.hasPrefix(name!) { 
                    try fm.trashItem(at: url, resultingItemURL: nil)
                    // try fm.removeItem(at: url)
                }
            }
        } catch {
            print(":ERROR: clearSpool \(name ?? "name=nil") \(stage) \(error)")
        }
    }
    
    // ////////////////
    // MARK: - Add Jobs
    // ////////////////
    
    public func spoolAddStage1Json(item: MCxPrintJsonSpoolable) -> URL? {
        let datestamp = DateTimeUtil.getSpoolTimestamp()
        let jobname = "\(datestamp)_\(item.toSpoolJobBasename())"
        let jsonJobUrl = self.stage1JsonUrl
            .appendingPathComponent(jobname)
            .appendingPathExtension("json")
        
        do {
            guard let jsonData = item.toSpoolJsonData() 
                else {
                    print("ERROR: spoolAddStage1Json item JSON generation failed '\(jobname)'")
                    return nil
            }
            try jsonData.write(to: jsonJobUrl)
            return jsonJobUrl 
        } 
        catch {
            print("ERROR: spoolAddStage1Json failed to save :: '\(jsonJobUrl.lastPathComponent)' :: \(error)")
            return nil
        }
    }
    
    /// spoolAddStage2Svg(item: MCxPrintSvgSpoolable) adds 1 SVG job page
    ///
    /// Scope: Does not manage any Stage 1 JSON content. Bypasses Stage 1 JSON.
    public func spoolAddStage2Svg(item: MCxPrintSvgSpoolable) -> URL? {
        let datestamp = DateTimeUtil.getSpoolTimestamp()
        let jobname = "\(datestamp)_\(item.toSpoolJobBasename())"
        let svgJobUrl = self.stage2SvgUrl
            .appendingPathComponent(jobname)
            .appendingPathExtension("svg")
        
        do {
            let svgStr = item.toSpoolSvgStr() 
            try svgStr.write(to: svgJobUrl, atomically: false, encoding: .utf8)
            return svgJobUrl
        } 
        catch {
            print("ERROR: spoolAddStage2Svg failed to save :: '\(svgJobUrl.lastPathComponent)' :: \(error)")
            return nil
        }
    }
    
    // //////////////////////
    // MARK: - Process Stages
    // //////////////////////
    
    public func processJobs() -> [URL] {
        _ = processJobs(stage: .stage1Json)
        _ = processJobs(stage: .stage2Svg)
        return processJobs(stage: .stage3Pdf)
    }
    
    public func processJobs(stage: MCxPrintSpoolStageType) -> [URL] {
        switch stage {
        case .stage1Json:
            return processJobsStage1Json()
        case .stage2Svg:
            return processJobsStage2Svg()
        case .stage3Pdf:
            return processJobsStage3Pdf()
        case .stage4Printed:
            return [URL]()
        } 
    }
    
    /// processJobsStage1Json()
    ///
    /// Upon completion:
    /// * stage2Svg contains "jobname/" folder and "jobname.svg"
    ///
    /// - returns: URL of jobs completed 
    public func processJobsStage1Json() -> [URL] {
        let jsonIn = getJobUrls(stage: .stage1Json)
        var svgOut = [URL]()
        
        //
        var batchCounter = 0
        var jsonBatchUrls = [URL]()
        for jsonInUrls in jsonIn.ready {
            jsonBatchUrls.append(jsonInUrls)
            batchCounter = batchCounter + 1
            
            // process batch
            if self.jsonBatchSize == batchCounter {
                let json0 = jsonBatchUrls[0]
                let jobname = json0.deletingPathExtension().lastPathComponent
                
                // convert batch
                if let svgSpoolable = try? svgSpooler.init(jsonUrlBlocks: jsonBatchUrls) {
                    if let newSvgJob = spoolAddStage2Svg(item: svgSpoolable) {
                        // move batch to next stage
                        let movedUrl = moveAlong(stage: .stage1Json, jobname: jobname, batch: jsonBatchUrls)
                        if let newJobUrl = movedUrl {
                            svgOut.append(newJobUrl)
                            print(":DEBUG:!!!:???: \(newSvgJob) \(newJobUrl)")
                        } 
                    }
                    
                }
                
                // reset batch
                batchCounter = 0
                jsonBatchUrls.removeAll()
            }            
        }
        return svgOut
    }
    
    /// processJobsStage2Svg() converts SVG to PDF
    /// 
    /// :NYI:NA: process stage2Svg remainders
    /// 
    /// - returns: job URLs which reached stage3Pdf
    public func processJobsStage2Svg()  -> [URL] {
        let svgIn = getJobUrls(stage: .stage2Svg)
        var pdfOut = [URL]()
        
        for svgFileUrl in svgIn.ready {
            let jobname = svgFileUrl.deletingPathExtension().lastPathComponent
            
            runSvgToPdf(jobname: jobname)
            
            let movedUrl = moveAlong(stage: .stage2Svg, jobname: jobname)
            if let newJobUrl = movedUrl {
                pdfOut.append(newJobUrl)                
            }
        }
        return pdfOut
    }
    
    /// :NYI:NA: process stage3Pdf remainders
    /// :NYI: maybe group mutliple pdf into one document if saves print material
    /// - returns: job URLs which reached stage4Printed
    public func processJobsStage3Pdf() -> [URL] {
        let pdfIn = getJobUrls(stage: .stage3Pdf)
        var pdfOut = [URL]()
        
        for pdfFileUrl in pdfIn.ready {
            let jobname = pdfFileUrl.deletingPathExtension().lastPathComponent

            runPdfToPrinter(url: pdfFileUrl)
            
            let movedUrl = moveAlong(stage: .stage3Pdf, jobname: jobname)
            if let newJobUrl = movedUrl {
                pdfOut.append(newJobUrl)                
            }
        }
        return pdfOut
    }
    
    // ///////////////
    // MARK: - Queries
    // ///////////////

    public func getJobNames(stage: MCxPrintSpoolStageType) -> (ready: [String], remainder: [String]) {
        var readyJobNames = [String]()
        var remainderJobNames = [String]()
        do {
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: getStageUrl(stage: stage), 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            for fileUrl in cachedUrls {
                if fileUrl.pathExtension == stage.fileExtension() {
                    let jobname = fileUrl.deletingPathExtension().lastPathComponent
                    if remainderJobNames.count + 1 == getStageBatchSize(stage: stage) {
                        readyJobNames.append(contentsOf: remainderJobNames)
                        remainderJobNames.removeAll()
                        readyJobNames.append(jobname)
                    }
                    else {
                        remainderJobNames.append(jobname)
                    }
                }
            }
            return (readyJobNames, remainderJobNames)
        } 
        catch {
            print(":ERROR:AknowtzPrintSpool:getJobNames(stage: \(stage): \(error)")
            return  (readyJobNames, remainderJobNames)
        }
    }
    
    /// - returns: _all related file urls_ including the current job url 
    public func getJobRelatedUrls(prefix: String, stage: MCxPrintSpoolStageType) -> [URL] {
        var results = [URL]()
        do {
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: getStageUrl(stage: stage), 
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            for fileUrl in cachedUrls {
                if fileUrl.hasDirectoryPath { continue }
                let filename = fileUrl.lastPathComponent
                if filename.hasPrefix(prefix) {
                    results.append(fileUrl)
                }
            }
            return results
        } 
        catch {
            print(":ERROR:AknowtzPrintSpool:getJobRelatedUrls(name: \(prefix), stage: \(stage)): \(error)")
            return results
        }
    }
    
    public func getJobUrls(stage: MCxPrintSpoolStageType) -> (ready: [URL], remainder: [URL]) {
        var readyUrls = [URL]()
        var remainderUrls = [URL]()
        do {            
            let fm = FileManager.default
            let cachedUrls = try fm.contentsOfDirectory(
                at: getStageUrl(stage: stage),
                includingPropertiesForKeys: [URLResourceKey.isRegularFileKey], 
                options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles])
            
            for fileUrl in cachedUrls {
                if fileUrl.hasDirectoryPath { continue }
                if fileUrl.pathExtension == stage.fileExtension() {
                    if remainderUrls.count + 1 == getStageBatchSize(stage: stage) {
                        readyUrls.append(contentsOf: remainderUrls)
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
            print(":ERROR:AknowtzPrintSpool:getJobUrls(stage: \(stage)) \(error)")
            return (readyUrls, remainderUrls)
        }
    }

    public func getStageBatchSize(stage: MCxPrintSpoolStageType) -> Int {
        switch stage {
        case .stage1Json:
            return self.jsonBatchSize
        case .stage2Svg:
            return 1
        case .stage3Pdf:
            return 1
        case .stage4Printed:
            return 1
        }    
    }

    public func getStageExtension(stage: MCxPrintSpoolStageType) -> String {
        switch stage {
        case .stage1Json:
            return MCxPrintSpoolStageType.stage1Json.fileExtension()
        case .stage2Svg:
            return MCxPrintSpoolStageType.stage2Svg.fileExtension()
        case .stage3Pdf:
            return MCxPrintSpoolStageType.stage3Pdf.fileExtension()
        case .stage4Printed:
            return MCxPrintSpoolStageType.stage4Printed.fileExtension()
        }    
    }
    
    public func getStageUrl(stage: MCxPrintSpoolStageType) -> URL {
        switch stage {
        case .stage1Json:
            return self.stage1JsonUrl
        case .stage2Svg:
            return self.stage2SvgUrl
        case .stage3Pdf:
            return self.stage3PdfUrl
        case .stage4Printed:
            return self.stage4PrintedUrl
        }    
    }
    
    // ///////////////
    // MARK: - Private
    // ///////////////
    
    private func moveAlong(stage: MCxPrintSpoolStageType, jobname: String, batch: [URL]? = nil) -> URL? {
        var movedJobUrl: URL?
        
        var stageInUrl: URL!
        var stageOutUrl: URL!
        var stageOutExtension: String!
        switch stage {
        case .stage1Json:
            stageInUrl = self.stage1JsonUrl
            stageOutUrl = self.stage2SvgUrl
            stageOutExtension = MCxPrintSpoolStageType.stage2Svg.fileExtension()
        case .stage2Svg:
            stageInUrl = self.stage2SvgUrl
            stageOutUrl = self.stage3PdfUrl
            stageOutExtension = MCxPrintSpoolStageType.stage3Pdf.fileExtension()
        case .stage3Pdf:
            stageInUrl = self.stage3PdfUrl
            stageOutUrl = self.stage4PrintedUrl
            stageOutExtension = MCxPrintSpoolStageType.stage4Printed.fileExtension()
        case .stage4Printed:
            return nil
        }
        
        do {
            let fm = FileManager.default
            
            // Create the Related Directory, if not already present.
            let relatedDirIn = stageInUrl.appendingPathComponent(jobname, isDirectory: true)
            if fm.fileExists(atPath: relatedDirIn.path) == false {
                try fm.createDirectory(
                    at: relatedDirIn, 
                    withIntermediateDirectories: false, 
                    attributes: nil
                )
            }
            
            // Move related files into Related Directory.
            let relatedUrls = getJobRelatedUrls(prefix: jobname, stage: stage)
            for srcUrl in relatedUrls {
                let filename = srcUrl.lastPathComponent
                if srcUrl.pathExtension == stageOutExtension {
                    let destUrl = stageOutUrl.appendingPathComponent(filename, isDirectory: false)
                    try fm.moveItem(at: srcUrl, to: destUrl) 
                    movedJobUrl = destUrl
                } 
                else {
                    let destUrl = relatedDirIn.appendingPathComponent(filename, isDirectory: false)
                    try fm.moveItem(at: srcUrl, to: destUrl) 
                }
            }
            
            // Move all related batch files into the Related Directory
            if let batchUrls = batch {
                for url in batchUrls {
                    let blockfilename = url.lastPathComponent
                    let blockprefix = url.deletingPathExtension().lastPathComponent
                    let relatedBatchUrls = getJobRelatedUrls(prefix: blockprefix, stage: stage)
                    for rbUrl in relatedBatchUrls {
                        let destUrl = relatedDirIn.appendingPathComponent(blockfilename, isDirectory: false)
                        try fm.moveItem(at: rbUrl, to: destUrl) 
                    }
                }
            }
            
            // Move the Related Directory to the next stage
            let relatedDirOut = stageOutUrl.appendingPathComponent(jobname, isDirectory: true)
            try fm.moveItem(at: relatedDirIn, to: relatedDirOut)            
        }
        catch {
            print(":ERROR: moveAlong failed to move \(stage) \(jobname) files : \(error)")
        }
        return movedJobUrl
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
    
    /// runPdfToPrinter sends a single pdf file to this spool's printer
    ///
    /// ```
    /// lpstat -p  # list available printers
    /// lp -d <PRINTER_NAME> PathToDocument.pdf
    /// ```
    ///
    private func runPdfToPrinter(url: URL) {
        let stageUrl = url.deletingLastPathComponent()
        let pdfPath = url.path
        
        var args = [String]()
        args.append(contentsOf: ["-d", printerName])
        args = args + [pdfPath]
        
        let executableUrl = URL(fileURLWithPath: "/usr/bin/lp", isDirectory: false)
        _ = run(
            executableUrl: executableUrl,
            withArguments: args,
            currentDirectory: stageUrl,
            printStdio: true
        )
    }
    
    private func runSvgToPdf(jobname: String) {
        let stageUrl = self.stage2SvgUrl
        let inputSvgPath = stageUrl.appendingPathComponent("\(jobname).svg", isDirectory: false).path
        let outputPdfPath = stageUrl.appendingPathComponent("\(jobname).pdf", isDirectory: false).path
        
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
            currentDirectory: stageUrl,
            printStdio: true
        )
    }

}
