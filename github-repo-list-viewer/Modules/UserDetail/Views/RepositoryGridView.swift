//
//  RepositoryGridView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 18.09.2024.
//

import SwiftUI

struct RepositoryGridView: View {
    
    @EnvironmentObject var viewModel: UserDetailViewModel
    @Binding var numberOfColumns: Int
    
    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(viewModel.repositories.indices, id: \.self) { index in
                        let repository = viewModel.repositories[index]
                        let item = RepositoryGridItemModel(
                            name: repository.name,
                            isPrivate: repository.isPrivate,
                            description: repository.desc,
                            createdAt: repository.createdAt,
                            updatedAt: repository.updatedAt,
                            starCount: Int(repository.starCount),
                            language: repository.language,
                            topics: repository.topics,
                            watchers: Int(repository.watchers)
                        )
                        
                        NavigationLink(destination: destinationView(for: item)) {
                            repositoryDetail(item: item)
                        }
                        .onAppear {
                          //   Trigger fetchMoreRepositories when the last item appears
                            if index == viewModel.repositories.count - 1 {
                                viewModel.fetchMoreRepositories()
                            }
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
    RepositoryGridView(numberOfColumns: .constant(3))
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
}
