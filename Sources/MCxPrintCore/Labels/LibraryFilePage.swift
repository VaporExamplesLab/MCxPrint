//
//  LibraryFilePage.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.17.
//

import Foundation

/// provides a page for 1x18, 2x9 or 3x6 label layout
public struct LibraryFilePage: MCxPrintSvgSpoolable {
    
    /// left-to-right, top-to-bottom label sequence
    let labelSequence = [
        [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], //  1
        [ 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1], //  2
        [ 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2], //  3
        //                                                       //  6
        [ 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8], //  9
        //                                                       // 18
    ]
    
    let labels: [LibraryFileLabel]
    
    init(labels: [LibraryFileLabel]) throws {
        if LibraryFilePage.jsonBatchAllowedSizes().contains(labels.count) == false {
            throw MCxPrintCore.Error.unsupportedBatchSize 
        }
        self.labels = labels
    }
    
    func svg(framed: Bool = false) -> String {
        let pageRect = PrintTemplate.PaperPointRect.letter

        let placementIdx: Int
        if labels.count == 1 {
            placementIdx = 0
        }
        else if labels.count == 2 {
            placementIdx = 1
        }
        else if labels.count == 3 {
            placementIdx = 2
        }
        else if labels.count == 9 {
            placementIdx = 3
        }
        else {
            fatalError("LibraryFilePage labels.count=\(labels.count) is not supported")
        }
        
        let columnTopY: CGFloat = 37.0
        let columnLeftX: CGFloat = 36.2
        let columnRightX: CGFloat = 330.0
        let columnStepY: CGFloat = 81.0

        var s = ""

        //
        for i in 0 ..< 18 {
            var x = columnLeftX
            if i % 2 == 0 {
                x = columnRightX
                // hack for single column
                if labels.count == 9 {
                    continue
                }
            }
            let y = columnTopY + CGFloat(i / 2) * columnStepY
            
            let labelIdx = labelSequence[placementIdx][i]
            var labelSvg = labels[labelIdx].svg(framed: framed)
            labelSvg.svgWrapGroup(translate: (x: x, y: y))
            s.svgAdd(svg: labelSvg)
        }

        s.svgWrapSvgTag(w: pageRect.width, h: pageRect.height, standalone: true)
        return s
    }
    
    // ////////////////////////////
    // MARK: - MCxPrintSvgSpoolable
    // ////////////////////////////
    
    public init(jsonDataBlocks: [Data]) throws {
        if LibraryFilePage.jsonBatchAllowedSizes().contains(jsonDataBlocks.count) == false {
            throw MCxPrintCore.Error.unsupportedBatchSize 
        }
        fatalError(":NYI: init(jsonDataBlocks: [Data]) not supported ")
    }
    
    public init(jsonStrBlocks: [String]) throws {
        if LibraryFilePage.jsonBatchAllowedSizes().contains(jsonStrBlocks.count) == false {
            throw MCxPrintCore.Error.unsupportedBatchSize 
        }
        fatalError(":NYI: init(jsonStrBlocks: [String]) not supported ")
    }
    
    public init(jsonUrlBlocks: [URL]) throws {
        if LibraryFilePage.jsonBatchAllowedSizes().contains(jsonUrlBlocks.count) == false {
            throw MCxPrintCore.Error.unsupportedBatchSize 
        }
        var itemBlocks = [LibraryFileLabel]()
        for url in jsonUrlBlocks {
            let label = try LibraryFileLabel(jsonFileUrl: url)
            itemBlocks.append(label)
        }
        try self.init(labels: itemBlocks)
    }
    
    public static func jsonBatchAllowedSizes() -> [Int] {
        return [1,2,3,9]
    }
    
    public static func jsonBatchSupportsPartials() -> Bool {
        return false
    }
    
    public func toSpoolJobBasename() -> String {
        return labels[0].udcCall
    }
    
    public func toSpoolSvgStr() -> String {
        return self.svg()
    }
    
    public func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol) -> URL? {
        return spool.spoolAddStage2Svg(item: self, jobname: nil)
    }
    
    public func spoolAddStage2Svg(spool: MCxPrintSpoolProtocol, jobname: String?) -> URL? {
        return spool.spoolAddStage2Svg(item: self, jobname: jobname)
    }

    
}
