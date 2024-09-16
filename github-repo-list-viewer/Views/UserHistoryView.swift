//
//  UserHistoryView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct UserHistoryView: View {
    
    @EnvironmentObject var viewModel: UserHistoryViewModel
    
    var body: some View {
        VStack {
            if viewModel.users.isEmpty {
                Text("There is no user")
            } else {
                List(viewModel.users, id: \.self) { user in
                    VStack(alignment: .leading) {
                        Text(user.username ?? "Unknown User")
                            .font(.headline)
                        if let bio = user.bio {
                            Text(bio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

#Preview {
    UserHistoryView()
        .environmentObject(PreviewProvider.shared.userHistoryViewModel)
}
