//
//  String+Extensions.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 14.09.2024.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
