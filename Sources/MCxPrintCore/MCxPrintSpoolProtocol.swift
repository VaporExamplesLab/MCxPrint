//
//  MCxPrintSpoolProtocol.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.13.
//

import Foundation

// :NYI: consideration for different spool types: local disk, memory, remote service
protocol MCxPrintSpoolProtocol {
    // :NYI: batch completion strategy
    
    //func createSpool() // … level up for user interaction?
    //func deleteSpool() // … level up for user interaction?

    func spoolClear()
    
    /// Content
    func spoolWrite()

    // Processing
    func spoolProcess(stage: MCxPrintSpoolStage)

    
    /// Content Query
    func spoolRead(jobname: String?, stage: MCxPrintSpoolStage)
    func getStage1Json(name: String?) -> [String] // ? = nil
    func getStage2Svg(name: String?) -> [String] // ? = nil
    func getStage3Pdf(name: String?) -> [Data] // ? = nil
    
    // JobName Query: file name without extension
    // A JobName list provides a basic status of "what's queued in the spool at each stage"
    func getJobNames(stage: MCxPrintSpoolStage) -> [String]
    // func getStageAllJobNames()
    
    func processStage1JsonJobs()
    func processStage2SvgJobs()
    func processStage3PdfJobs()
    func processAllJobs()
    
    // Content Get
    
    
    
}
