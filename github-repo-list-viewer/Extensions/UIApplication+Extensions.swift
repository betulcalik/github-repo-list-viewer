//
//  UIApplication+Extensions.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import UIKit

extension UIApplication {
    
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
