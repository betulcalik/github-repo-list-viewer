//
//  SearchUserView.swift
//  github-repo-list-viewer
//
//  Created by Betül Çalık on 16.09.2024.
//

import SwiftUI

struct SearchUserView: View {
    
    @EnvironmentObject var viewModel: SearchUserViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var username: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if !networkMonitor.isConnected {
                    BannerView(text: "no_internet_connection".localized())
                        .transition(.slide)
                }
                
                header
                
                VStack(spacing: 20) {
                    usernameTextField
                    searchButton
                }
                
                Spacer()
            }
            .background(Colors.backgroundColor)
            .animation(.easeInOut, value: networkMonitor.isConnected)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("error".localized()),
                    message: Text(viewModel.getUserError?.errorDescription ?? "unknown_error".localized()),
                    dismissButton: .default(Text("ok".localized()))
                )
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing(true)
            }
        }
    }
}

extension SearchUserView {
    
    private var header: some View {
        VStack {
            Image("githubIcon")
            
            Text("search_github_repositories".localized())
                .font(.title2)
                .foregroundStyle(Colors.textColor)
                .multilineTextAlignment(.center)
                .padding([.horizontal, .bottom])
        }
    }
    
    private var usernameTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading)
            
            TextField("username".localized(), text: $username)
                .frame(height: 48)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
        }
        .background(.thinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var searchButton: some View {
        CustomButton(model: .init(title: "search".localized(),
                                  foregroundColor: Colors.textColor,
                                  backgroundColor: .clear,
                                  action: {
            viewModel.getUser(username: username)
        }))
    }
}

#Preview {
    SearchUserView()
        .environmentObject(PreviewProvider.shared.searchUserViewModel)
}
