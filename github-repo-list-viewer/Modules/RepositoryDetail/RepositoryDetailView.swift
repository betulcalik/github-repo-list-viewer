//
//  RepositoryDetailView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    let item: RepositoryGridItemModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RepositoryDetailView(item: PreviewProvider.shared.repositoryGridItems[0])
}
