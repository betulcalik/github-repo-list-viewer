//
//  UserDetailView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import SwiftUI

struct UserDetailView: View {
    
    @EnvironmentObject var viewModel: UserDetailViewModel
    @State private var numberOfColumns: Int = 1
    
    var body: some View {
        VStack {
            if viewModel.repositories.isEmpty {
                Text("no_repositories_found")
                    .font(.body)
                    .foregroundStyle(Colors.textColor)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    layoutButton
                    
                    Divider()
                    
                    RepositoryGridView(
                        items: viewModel.repositories.map { repository in
                        RepositoryGridItemModel(
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
                    },
                        numberOfColumns: $numberOfColumns)
                }
            }
            
            Spacer()
        }
        .navigationTitle("repositories".localized())
    }
    
    private func imageName(for columns: Int) -> String {
        switch columns {
        case 1:
            return "rectangle" // 1 column layout
        case 2:
            return "rectangle.split.1x2" // 2 column layout
        case 3:
            return "rectangle.split.3x3" // 3 column layout
        default:
            return "rectangle"
        }
    }
}

extension UserDetailView {
    
    private var layoutButton: some View {
        Button(action: {
            numberOfColumns = (numberOfColumns % 3) + 1
        }) {
            Image(systemName: imageName(for: numberOfColumns))
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
                .padding(5)
                .background(.accent)
                .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    UserDetailView()
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
}
