//
//  DateTimeUtil.swift
//  MCxPrintCore
//
//  Created by marc on 2019.07.02.
//

import Foundation

/// [Epoch & Unix Timestamp Conversion Tools](https://www.epochconverter.com/)
///
/// `DateFormatter()` is based on RFC 3339, a [IOS 8601](https://en.wikipedia.org/wiki/ISO_8601) profile. 
///
/// - Note: RFC 3339 has minor changes from ISO 8601. 
/// e.g. hyphen-minus U+002D '-' is used instead of minus U+2212 '−' for zulu offset values.
///
/// Unicode Technical Standard (UTS) Technical Report (TR) #35  `setDateFormat()` string patterns:
/// 
/// * [tr35: current](https://unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns) 
/// * [tr35-31: macOS v10.9, iOS 7](http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns)
///
public class DateTimeUtil {
    
    
    ///  - Returns: **now** as "dd_HHmmss_S"
    public static func getSpoolTimestamp() -> String {
        let currentTime = Date()
        let dateFormatter = DateFormatter() // 
        let formatStr = "dd_HHmmss_S" // add `z` for zulu.
        dateFormatter.dateFormat = formatStr
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: currentTime)
    }
    
    ///
    /// - Note: Yields sub-millisecond precision over 10,000 years. 
    /// - Returns: seconds since 1970.01.01 00:00:00 UTC
    public static func getUnixEpochSeconds(date dateString: String, format: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
        else {
            return nil
        }
    }
    
    /// - Note: Yields sub-millisecond precision over 10,000 years. 
    /// - Returns: **now** seconds since 1970.01.01 00:00:00 UTC
    public static func getUnixEpochSeconds() -> Double {
        // NSTimeInterval is Double 
        return Date().timeIntervalSince1970
    }
    
}
