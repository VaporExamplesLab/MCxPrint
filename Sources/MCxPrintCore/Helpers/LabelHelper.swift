//
//  _LabelHelper.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.16.
//

import Foundation

struct LabelHelper {
    
    // Test string to multiple lines base on width.
    
    // UDC number to multiple lines
    public static func udcToFragments(_ udcStr: String) -> [String] {
        var inStr: String = udcStr
        var outStr: [String] = []
        
        // 1.234 decimal position = 1
        // 12.34 decimal position = 2
        // 123.4 decimal position = 3
        guard let index = inStr.index(of: ".") else {
            print("udcNumberToLine(udcStr) missing decimal: \(udcStr)")
            fatalError()
        }
        
        let decimalPosition = inStr.distance(from: inStr.startIndex, to: index)
        if decimalPosition < 1 || decimalPosition > 3 {
            fatalError()
        }
        // add leading spaces if needed.
        for _ in decimalPosition ..< 3 {
            inStr = " " + inStr
        }
        print("inStr=\"\(inStr)\"")
        
        // if UDC <= 7
        if inStr.utf8.count <= 7 {
            return [inStr]
        }
        
        let line1 = String(inStr.prefix(7))
        outStr = [line1]
        inStr = String(inStr.dropFirst(7))
        var charCount = 0
        var subStr = ""
        for idx in inStr.indices {
            charCount = charCount + 1
            subStr.append(inStr[idx])
            if charCount % 3 == 0 {
                if charCount % 6 == 0 {
                    outStr = outStr + [subStr]
                    subStr = ""
                }
                else {
                    subStr.append(" ")
                }
            }
        }
        if !subStr.isEmpty {
            outStr = outStr + [subStr]
        }
        
        print("outStr=\(outStr)")
        
        return outStr
    }
    
}
