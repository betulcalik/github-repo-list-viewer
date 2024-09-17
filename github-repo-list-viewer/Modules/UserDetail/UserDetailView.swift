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
            List {
                ForEach(viewModel.repositories) { repository in
                    Text(repository.name ?? "Unknown")
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .listStyle(PlainListStyle())
            .background(Colors.backgroundColor)
        }
    }
}

#Preview {
    UserDetailView()
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
}
