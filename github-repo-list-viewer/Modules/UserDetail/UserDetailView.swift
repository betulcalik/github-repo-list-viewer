//
//  UserDetailView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import SwiftUI

struct UserDetailView: View {
    
    @EnvironmentObject var viewModel: UserDetailViewModel
    
    var body: some View {
        VStack {
            if viewModel.repositories.isEmpty {
                Text("No repositories found")
                    .font(.body)
                    .foregroundStyle(Colors.textColor)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                RepositoryGridView(items: viewModel.repositories.map { repository in
                    RepositoryGridItemModel(
                        name: repository.name,
                        isPrivate: repository.isPrivate,
                        description: repository.description,
                        createdAt: repository.createdAt,
                        updatedAt: repository.updatedAt,
                        starCount: Int(repository.starCount),
                        language: repository.language,
                        topics: repository.topics,
                        watchers: Int(repository.watchers)
                    )
                })
            }
            
            Spacer()
        }
    }
}

#Preview {
    UserDetailView()
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
}
