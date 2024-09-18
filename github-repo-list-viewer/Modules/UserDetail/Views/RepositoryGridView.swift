//
//  RepositoryGridView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import SwiftUI

struct RepositoryGridView: View {
    
    let items: [RepositoryGridItemModel]
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible()), // First column
            GridItem(.flexible()), // Second column
            GridItem(.flexible())  // Third column
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(items) { item in
                        NavigationLink(destination: destinationView(for: item)) {
                            repositoryDetail(item: item)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("repositories".localized())
    }
    
    private func repositoryDetail(item: RepositoryGridItemModel) -> some View {
        VStack {
            Text(item.name ?? "")
                .foregroundStyle(Colors.textColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12.0)
    }
    
    @ViewBuilder
    private func destinationView(for item: RepositoryGridItemModel) -> some View {
        RepositoryDetailView(item: item)
    }
}

#Preview {
    RepositoryGridView(items: PreviewProvider.shared.repositoryGridItems)
}
