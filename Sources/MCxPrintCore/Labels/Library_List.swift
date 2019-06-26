//
//  Library_List.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.16.
//

import Foundation

public class Library_List: Codable {
    var version: String?
    var bookLabels: [LibraryBookLabel]?
    var fileLabels: [LibraryFileLabel]?
}

