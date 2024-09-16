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
                            HStack {
                                Image(systemName: "person")
                                    .foregroundStyle(Colors.textColor.opacity(0.2))
                                
                                Text(user.username ?? "Unknown User")
                                    .foregroundStyle(Colors.textColor)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Colors.textColor.opacity(0.4))
                            }
                            .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                return 0
                            }
                            .frame(height: 36)
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
    UserHistoryView()
        .environmentObject(PreviewProvider.shared.userHistoryViewModel)
}
