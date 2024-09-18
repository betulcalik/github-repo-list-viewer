//
//  RepositoryGridView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import SwiftUI

struct RepositoryGridView: View {
    
    let items: [RepositoryGridItemModel]
    @Binding var numberOfColumns: Int
    
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
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
            .navigationTitle("repository_detail".localized())
    }
}

#Preview {
    RepositoryGridView(items: PreviewProvider.shared.repositoryGridItems, numberOfColumns: .constant(3))
}
