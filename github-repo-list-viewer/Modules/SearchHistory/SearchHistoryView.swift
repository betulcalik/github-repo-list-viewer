//
//  SearchHistoryView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct SearchHistoryView: View {
    
    @EnvironmentObject var viewModel: SearchHistoryViewModel
    @EnvironmentObject var githubManager: GithubManager
    @EnvironmentObject var githubDataModelManager: GithubDataModelManager
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.users.isEmpty {
                    userHistoryNotAvailable
                } else {
                    usersList
                }
            }
            .navigationTitle("search_history".localized())
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

extension SearchHistoryView {
    
    private var userHistoryNotAvailable: some View {
        Text("user_history_not_available".localized())
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(Colors.textColor)
            .padding()
    }
    
    private var usersList: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(
                    destination: UserDetailView()
                        .environmentObject(UserDetailViewModel(user: user,
                                                               githubManager: githubManager, githubDataModelManager: githubDataModelManager))
                ) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(Colors.textColor.opacity(0.2))
                        
                        Text(user.username ?? "unknown_user".localized())
                            .foregroundStyle(Colors.textColor)
                    }
                    .frame(height: 36)
                }
            }
        }
    }
}

#Preview {
    SearchHistoryView()
        .environmentObject(PreviewProvider.shared.searchHistoryViewModel)
        .environmentObject(PreviewProvider.shared.githubManager)
        .environmentObject(PreviewProvider.shared.githubDataModelManager)
}
