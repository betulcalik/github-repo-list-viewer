//
//  BaseView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI
import CoreData

struct BaseView: View {
    
    var body: some View {
        TabView {
            SearchUserView()
                .background(Colors.backgroundColor)
                .tabItem {
                    Label("search".localized(),
                          systemImage: "magnifyingglass")
                }
            
            UserHistoryView()
                .background(Colors.backgroundColor)
                .tabItem {
                    Label("history".localized(),
                          systemImage: "clock")
                }
        }
    }
}

#Preview {
    BaseView()
}
