//
//  UserDetailView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 17.09.2024.
//

import SwiftUI

struct UserDetailView: View {
    
    @EnvironmentObject var viewModel: UserDetailViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var numberOfColumns: Int = 1
    
    var body: some View {
        ZStack {
            Colors.backgroundColor
                .ignoresSafeArea()
            
            VStack {
                if viewModel.repositories.isEmpty {
                    Text("no_repositories_found".localized())
                        .font(.body)
                        .foregroundStyle(Colors.textColor)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        HStack(spacing: 5) {
                            layoutButton
                            sortByStarCountButton
                            sortByCreatedAtButton
                            sortByUpdatedAtButton
                        }
                        
                        Divider()
                        
                        RepositoryGridView(numberOfColumns: $numberOfColumns)
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("repositories".localized())
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            if !networkMonitor.isConnected {
                viewModel.fetchUserRepositoriesFromCoreData()
            }
            
            viewModel.fetchUserRepositories()
        }
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
    
    private var sortByStarCountButton: some View {
        Button(action: {
            viewModel.sortRepositoriesByStarCount()
        }) {
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
                
                Text("Sort by Stars")
                    .foregroundStyle(.white)
            }
            .padding(5)
            .background(.accent)
            .cornerRadius(8)
        }
    }
    
    private var sortByCreatedAtButton: some View {
        Button(action: {
            viewModel.sortRepositoriesByCreatedAt()
        }) {
            Text("Sort by Created At")
                .foregroundStyle(.white)
                .padding(5)
                .background(.accent)
                .cornerRadius(8)
        }
    }
    
    private var sortByUpdatedAtButton: some View {
        Button(action: {
            viewModel.sortRepositoriesByUpdatedAt()
        }) {
            Text("Sort by Updated At")
                .foregroundStyle(.white)
                .padding(5)
                .background(.accent)
                .cornerRadius(8)
        }
    }
}

#Preview {
    UserDetailView()
        .environmentObject(PreviewProvider.shared.userDetailViewModel)
        .environmentObject(PreviewProvider.shared.networkMonitor)
}
