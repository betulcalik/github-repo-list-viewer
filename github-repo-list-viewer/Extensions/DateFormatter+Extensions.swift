//
//  DateFormatter+Extensions.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import Foundation

extension DateFormatter {
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
}
