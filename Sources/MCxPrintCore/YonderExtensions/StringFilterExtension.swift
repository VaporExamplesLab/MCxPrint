//
//  StringFilters.swift
//  MCxPrintCore
//
//  Created by marc on 2019.06.19.
//

import Foundation

public extension String {
    
    ///
    public mutating func filterToSvgAscii() {
        var s: [String] = self.unicodeScalars.map { $0.escaped(asASCII: true)}
        for i in 0 ..< s.count {
            // swap out xml restricted characters
            switch s[i] {
            case "&":
                s[i] = "&amp;"
            case "<":
                s[i] = "&lt;"
            case ">":
                s[i] = "&gt;"
            case "\"":
                s[i] = "&quot;"
            case "'":
                s[i] = "&apos;"
            default:
                break;
            }
        }
        
        let result: String = s.joined(separator: "")
            .replacingOccurrences(
                of: "\\\\u\\{(.+?(?=\\}))\\}", // <- convert from swift format \\u{****}
                with: "&#x$1;",                // <- into svg xml format
                options: .regularExpression)
        
        self = result
    }
    
    public func filteringToSvgAscii() -> String {
        var s: [String] = self.unicodeScalars.map { $0.escaped(asASCII: true)}
        for i in 0 ..< s.count {
            // swap out xml restricted characters
            switch s[i] {
            case "&":
                s[i] = "&amp;"
            case "<":
                s[i] = "&lt;"
            case ">":
                s[i] = "&gt;"
            case "\"":
                s[i] = "&quot;"
            case "'":
                s[i] = "&apos;"
            default:
                break;
            }
        }
        
        let result: String = s.joined(separator: "")
            .replacingOccurrences(
                of: "\\\\u\\{(.+?(?=\\}))\\}", // <- convert from swift format \\u{****}
                with: "&#x$1;",                // <- into svg xml format
                options: .regularExpression)
        
        return result
    }
    
}

// :SWIFT5: supports isASCII
//extension StringProtocol where Self: RangeReplaceableCollection {
//    var asciiRepresentation: SubSequence {
//        return reduce("") { string, char in
//            if char.isASCII { return string + String(char) }
//            let hexa = char.unicodeScalars
//                .map { String($0.value, radix: 16, uppercase: true) }
//                .joined()
//            return string + "\\\\U" + repeatElement("0", count: 8-hexa.count) + hexa
//        }
//    }
//}
