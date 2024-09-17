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
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.users.isEmpty {
                    Text("user_history_not_available".localized())
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Colors.textColor)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            NavigationLink(
                                destination: UserDetailView()
                                    .environmentObject(UserDetailViewModel(user: user, githubManager: githubManager))
                            ) {
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundStyle(Colors.textColor.opacity(0.2))
                                    
                                    Text(user.username ?? "Unknown User")
                                        .foregroundStyle(Colors.textColor)
                                }
                                .frame(height: 36)
                            }
                        }
                    }
                }
            }
            .navigationTitle("search_history".localized())
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    SearchHistoryView()
        .environmentObject(PreviewProvider.shared.userHistoryViewModel)
        .environmentObject(PreviewProvider.shared.githubManager)
}
