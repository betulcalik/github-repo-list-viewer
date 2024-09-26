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
                .tabItem {
                    Label("search".localized(),
                          systemImage: "magnifyingglass")
                }
            
            SearchHistoryView()
                .tabItem {
                    Label("history".localized(),
                          systemImage: "clock")
                }
        }
    }
}

#Preview {
    BaseView()
        .environmentObject(PreviewProvider.shared.searchUserViewModel)
        .environmentObject(PreviewProvider.shared.searchHistoryViewModel)
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
        .environmentObject(PreviewProvider.shared.githubManager)
        .environmentObject(PreviewProvider.shared.githubDataModelManager)
        .environmentObject(PreviewProvider.shared.networkMonitor)
}
