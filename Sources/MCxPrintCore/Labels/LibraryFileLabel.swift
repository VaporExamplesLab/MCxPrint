//
//  LibraryFileLabel.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.13.
//

import Foundation

// migrate from TagFileRecord.swift
public struct LibraryFileLabel: Codable {
    
    //"title" : "Wingding Everest Dialog Network",
    let title: String
    //"udcCall" : "004.52-•-MC-WEDN",
    let udcCall: String
    //"udcLabel" : "Generic Labels - SVG Layout Example",
    let udcLabel: String
    //"collectionID" : "ABCDEFgH",
    let collectionID: String
    //"collectionColor" : "green"
    let collectionColor: String
    
    
    
    // JSON
    func svg() -> String {
        var s = ""
        
        //"title" : "Wingding Everest Dialog Network",
        //"udcCall" : "004.52-•-MC-WEDN",
        //"udcLabel" : "Generic Labels - SVG Layout Example",
        //"collectionID" : "ABCDEFgH",
        //"collectionColor" : "green"
        
        return s
    }
}

/* ********************************************
 {
 "version": "0.1.0",
 "labelBooks" : [
 {
 "type" : "book",
 "udcCall" : "004.52-•-MC-WEDN",
 "udcLabel" : "Generic Labels - SVG Layout Example",
 "collectionID" : "ABCDEFgH",
 "collectionColor" : "green"
 }
 ],
 "labelFile" : [
 {
 "type" : "file",
 "title" : "Wingding Everest Dialog Network",
 "udcCall" : "004.52-•-MC-WEDN",
 "udcLabel" : "Generic Labels - SVG Layout Example",
 "collectionID" : "ABCDEFgH",
 "collectionColor" : "green"
 }
 ],
 "labelParts" : [
 {
 "type" : "part",
 "name" : "Resistor",
 "value": "100K",
 "description": "carbon"
 },
 {
 "type" : "part",
 "name" : "9DOF Sensor",
 "value": "Adafruit-12345",
 "description": "carbon"
 }
 ]
 }
 ******************************************** */
