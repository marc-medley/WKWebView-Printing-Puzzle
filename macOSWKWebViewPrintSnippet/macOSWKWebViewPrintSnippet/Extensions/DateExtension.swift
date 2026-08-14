//
//  DateExtension.swift
//  macOSWKWebViewPrintSnippet
//
//

import Foundation

extension Date {
 
    var datestampyyyyMMddHHmmss: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        return dateFormatter.string(from: self)
    }
    
}
