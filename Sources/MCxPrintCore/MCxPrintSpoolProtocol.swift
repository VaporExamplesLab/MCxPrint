//
//  MCxPrintSpoolProtocol.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.13.
//

import Foundation

public protocol MCxPrintSpoolProtocol {
    // :NYI: batch completion strategy type. e.g. RoundRobin, ReplicateLast
    
    // clearItem(_ itemName: String) // clears from all spool stages.
    func clearSpool()
    func clearSpool(jobnames: [String])
    func clearSpool(name: String?, stage: MCxPrintSpoolStageType)
    
    //func createSpool() // no user interaction at this level.
    //func deleteSpool() // no user interaction at this level.
    
    /// Add Jobs
    func spoolAddStage1Json(item: MCxPrintJsonSpoolable) -> URL?
    func spoolAddStage2Svg(item: MCxPrintSvgSpoolable, jobname jobnameOptional: String?) -> URL?
    
    // Process Stages
    // returns jobes completed
    func processJobs() -> [URL] // all stages
    //    func processJobs(names: [String]) // by job names
    func processJobs(stage: MCxPrintSpoolStageType) -> [URL] // by single stage
    func processJobsStage1Json() -> [URL]
    func processJobsStage2Svg() -> [URL] 
    func processJobsStage3Pdf() -> [URL]
    // func processJobsStage4Print() -> [URL] // :NYI: move to trash with undo URLs
    
    // Query Jobs
    /// getJobNames: returns file names without extension
    /// A JobName list provides a basic status of "what's queued in the spool at this stage"
    func getJobNames(stage: MCxPrintSpoolStageType) -> (ready: [String], remainder: [String])
    func getJobUrls(stage: MCxPrintSpoolStageType) -> (ready: [URL], remainder: [URL])
    
    func getJobRelatedUrls(prefix: String, stage: MCxPrintSpoolStageType) -> [URL]
    
    // Query Stages
    func getStageUrl(stage: MCxPrintSpoolStageType) -> URL
}
